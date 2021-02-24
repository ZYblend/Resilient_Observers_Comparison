function q_eta_hat = pruning_algorithm(q,Tr)
% function q_eta_hat = pruning_algorithm(I_attack)
% Description:
%              This function is to implement pruning algorithm based on
%              uncertain oracle
%              1. oracle is generated by Bernulli model 
%              2. prunning based on oracle
%       Inputs:
%              q: [N-by-1] indicator of support of attack location
%              Pa: [scalar] attack percentage
%      Outputs:
%              q_eta_hat: {N-by-1] pruning indicator
%   parameters:
%              eta: (0,1) reliability
%
% @Written by Yu Zheng, Tallahassee, Florida, Aug. 2020

N = length(q);
%% estimated support (oracle)
    P = zeros(N,1);
    while sum(P>0.5) == 0
        u = rand(N,1);
        P = (0.5/(1-Tr)*u).*double(u<(1-Tr)) + (0.5 + (0.5/Tr)*(u-1+Tr)).*double(u>=(1-Tr));% ROC
    end
 
    epsilon = double(P>0.5);                         % agreement 
    q_hat = (q - (1-epsilon))./(2*epsilon-1);        % estimate support indics
    
%% obtain trust number
% L_eta: the smallest number of success estimates in oracle with
% probability of at least eta

% Define reliability eta satisfying the upper bound
eta_ub = 1-exp(1)*(1-((exp(1)-1)*sum(P(q_hat > 0.5)))/(exp(1)*N))^N;
eta = eta_ub*0.6;

% calculate L_eta
P_hat_safe = P(q_hat >0.5);                      
r = pmf_PB(P_hat_safe);                          % Oracle Poission-Binomial pmf
L_eta = reliable_num_attacks(r,eta);

%% pruning operation
[~,indx] = sort(q_hat.*P,'descend');   % (q_hat \circ P) = P_{T_hat_c}
idx_eta = indx(1:L_eta);
q_eta_hat = zeros(N,1);
q_eta_hat(idx_eta) = 1;

end