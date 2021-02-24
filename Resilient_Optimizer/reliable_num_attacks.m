function L_eta = reliable_num_attacks(r,eta)
% Obtain reliable number of attacked nodes
%      Reliability (eta)
%
% Inputs:
%     - r [N+1-by-1]        : Poission-Binomial pmf of estimate
% Outputs:
%     - L_eta [scalar]      : trust number
%
% @Written by Yu Zheng, Tallahassee, Florida, Aug. 2020

% define a reliability /eta, and use the probaility r wo get reliable number of attacked nodes
if r(1) > (1-eta) 
     L_eta=0;
else
    sum = r(1);
    k=1;
    while sum <=(1-eta)
        k=k+1;
        sum = sum+r(k);
    end
    L_eta=k-2;
end
end