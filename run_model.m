%% Resilient Observer Initializer
%   - Loads bus data
%   - Defines network Laplacian
%   - Defines discretize system matrices
%   - Resilient Observer
%   - Attack Model
%   - Bad Data Detection
%   - Auxiliary Model

% Jan. 2020 (initial version)
% Olugbenga Moses Anubi
% Carlos A. Wong
% Satish Vedula

% Jan. 2021
% Yu Zheng

%% Parameter Setup
clear variables
close all
clc

addpath('Resilient_Optimizer')
addpath('Attack_Generators')

%% Data Loading
[baseMVA, bus, gen, branch, ~, ~, X_d, H, Dg] = bus14_PSCAD;
[~,I_sort]  = sort(bus.type,'descend');
bus_no      = (1:length(bus.type));
% to be used for rearranging buses with generator buses first

%% Dimension Variables
n_gen       = size(gen,1); % number of generators
n_bus       = size(bus,1); % number of buses
n_states    = 2*n_gen;
p           = n_states + n_bus;
n_meas      = n_gen + n_bus;  % number of measurements


%% Network Laplacian
% relabelling the nodes such that generator nodes come first
fbus_new = interp1(bus_no(I_sort),bus_no,branch.fbus);
tbus_new = interp1(bus_no(I_sort),bus_no,branch.tbus);

sus_weighted_graph = graph(fbus_new,...
                           tbus_new,...
                           branch.x);
Adj                = adjacency(sus_weighted_graph,'weighted');
%   Adjacency of the susceptance weighted graph
Inc                = full(incidence(sus_weighted_graph));
Lap                = diag(sum(Adj)) - Adj; % laplacian
Susc               = diag(1./branch.x);

%% Admitance Matrix (Ybus)
% Assume G = 0 then the network is lossles
L_gg   = diag(1./X_d);
L_gl   = [diag(1./X_d) zeros(n_gen, n_bus-n_gen)];
L_lg   = L_gl.';
L_ll   = -blkdiag(L_gg,zeros(n_bus-n_gen)) - Lap;
LL = [L_gg L_gl; L_lg L_ll];
% sanity check
disp('Sanity Check: Positive?')
disp(eig(L_gg-(L_gl*(L_ll\L_lg))).')

%% Inertia Matrix
% Reference data
f_ref = 60;             % reference frequency in Hz
% S_base  = baseMVA;      % 3-phase base rating for the generators MVA
omega_r = 2*pi*f_ref;   % reference frequency in rad/sec

Mass_gen = 2*H/omega_r;
M = diag(Mass_gen);     % mass matrix for the generators
Dg = diag(Dg);          % damping matrix for the generators

%% Power Flow
V = ones(n_bus,1);      % voltage @ each bus assumed to be 1 p.u.
% Pst(theta) - power injected into network at s onto line h to bus h
R = diag(exp(abs(Inc).'*log(V)))*Susc*Inc.';
% Pnw(theta) - power flow for net power flowing into network        - n_bus
J = -Inc*R;

%% System Matrices
%%%% state update matrix                        - 2*n_gen x 2*n_gen
A_bar = [zeros(n_gen)                   eye(n_gen);
        -M\(L_gg-(L_gl*(L_ll\L_lg)))    -M\Dg];
%%%% input matrix                               - 2*n_gen x n_gen+n_bus
%        Pg           Pd
B_bar = [zeros(n_gen) zeros(n_gen, n_bus);
        inv(M)       -M\(L_gl/L_ll)];
%%%% output matrix                              - 
%%% in terms of x_bar = [delta; omega];
C_omega = [zeros(n_gen)     eye(n_gen)];
C_theta = [-L_ll\L_lg       zeros(n_bus,n_gen)];
% theta will not be an output
C_Pnet  = [-J*(L_ll\L_lg)   zeros(n_bus,n_gen)];
% Does not consider the power injected from generators
C_bar   = [C_omega; C_theta; C_Pnet];
C_obsv  = [C_omega; C_Pnet];

%%%% feedforward matrix
D_omega = zeros(n_gen,n_gen+n_bus);
D_theta = [zeros(n_bus,n_gen) eye(n_bus)];
D_Pnet  = [zeros(n_bus,n_gen) -J/L_ll];
D_bar   = [D_omega; D_theta; D_Pnet];
D_obsv  = [D_omega; D_Pnet];

%% Discretized System Model
T_sample = 0.01;
[A_bar_d, B_bar_d] = discretize_linear_model(A_bar,B_bar,T_sample);
C_obsv_d = C_obsv;
D_obsv_d = D_obsv;

disp('eigenvalues of linearized A')
disp(eig(A_bar_d).')

%% system matrix unit testing
%controllability and observability
disp('controllability')
disp(rank(ctrb(A_bar_d,B_bar_d))) % fully controllable with PID controller
disp('observability')
disp(rank(obsv(A_bar_d,C_obsv_d))) % fully observable

%% Observer Dynamics
%%% Pole Placement
P = .1 + .4*rand(2*n_gen,1);
L_obsv = place(A_bar_d.',C_obsv_d.',P).';
disp('discrete observer (A-L*C) eigenvalues: negative?')
disp(eig(A_bar_d-L_obsv*C_obsv_d).')
 
%% Simulation Initialization
x0          = zeros(n_states,1);
x0_hat      = zeros(n_states,1);
load_buses  = [zeros(n_gen,1); ones(n_bus-n_gen,1)];

%% Resilient Observer Parameters

% parameters
n       = n_states;         % # of states
m       = n_meas;           % # of measurements
l       = n_meas;           % # of inputs

T       = round(2*n);     % receeding horizon

N_samples      = 800; % The total number of samples to run
T_final        = N_samples*T_sample;  % Total time for simulation
% T_start_opt    = 1.5*T*T_sample; % start time for the optimization routines. Wait to collect enoguh data before calling the optimizers
tau     = 0.1;              % auxiliary model (1-reliability level)

% tapped delay
U0      = zeros(m,T);
Y0      = zeros(m,T);
q0      = ones(m,T);   % q=1 means safe
p0      = zeros(m,T);

[PhiT,HT,Theta_T,G_T,r_tau] = opti_params(A_bar_d,B_bar_d,C_obsv_d,T,tau);

% solver initial condition
z_0         = zeros(n+m*T,1);

%% Attack Parameters
T_start_attack = .2*T_final;  % Time to begin attack. Neede to sshow system responses with/without attacks in the same simulation
n_attack =  round(0.6*n_meas);
% max_attack = 100; % maximum allowable attack per channel

%% Bad Data Detection
BDD_thresh = 0.5e-1;  % Bad data detection tolerance
[U,~,~] = svd(C_obsv_d);
U2 = U(:,n_states+1:end);

% turn on attacks and optimizers
T_start_opt(:)    = 1.5*T*T_sample; % start time for the optimization routines. Wait to collect enoguh data before calling the optimizers
max_attack(:)     = 100;



%% parameter for pruning algorithm 
Tr = 0.5;   % agreement probability of oracle

%% parameters for event-triggered luenburger observer
[A_ETLO,B_ETLO,Q_ETLO] = ETLO_params(A_bar_d,B_bar_d,C_obsv_d,T);

%% Auxiliary model (paramter for multi-model observer)
% Generating surrogate auxiliary model
%  Steps:
%     1. Turn off attack and turn off resilient optimizers
%     2. Run modle without attacks and collect datat
%     3. Estimate the std for each channel
%     4. Trun attack and optimizers back on and set the right parameters

n_stds = 3;  % number of standard deviations to locate auxiliary mean

% Initial Sigmas
sigma_inv_k = 1e4*(3 + 2*rand(m,1)); % surrogate inverse covariance values. Assume diagonal covariance matrix.
Sigma_inv_k = diag(sigma_inv_k);

sigma = (1e-3)*(1 + 2*rand(m,1));
Sigma = diag(sigma);

U_y_1 = 0;

%% Parameters for H2 observer
size_I = n_meas - n_attack;
size_V = n_attack;






