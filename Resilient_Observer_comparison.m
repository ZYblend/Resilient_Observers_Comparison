%% Resilient Observer comparison

%% parameters
tot = 100; % times for simulation
n = 20;    % number of states
m = 100;   % number of measurements
pa = 0.3;  % attack percentage
n_attack = fix(m*Pa);   % number of attacks

x0 = randn(n,1);  % initial states

%% System generation
[A,C]= sysGen(m,n);    % observation pair
y0 = C*A*x0;

x_hat = x0;  % initialization
for iter = 1:tot   
    %% attack injection
    I_attack_local = randperm(m,n_attack);

    max_attack = 500;  % maximum allowable attack
    tau = .1;   % escape parameter for BDD
    I_attack = zeros(n_attack*(T+1),1);

    ya = gen_attack_channel(H,max_attack,I_attack,tau);   % attack signal

    y = C*A*x_hat + ya;


%% resilient observer 1
x_hat = resilient_observer1();


end