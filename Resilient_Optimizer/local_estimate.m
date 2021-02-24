function [x_hat,res,F,P]=local_estimate(size_I,n_meas,A,C,B,y,x_last)
%% function [x_hat,res]=local_estimate(size_I,size_V,A,C,B)
% local estimator for the H2 observer
% Attack-Resilient H2, H_?nfty, and L1$ State Estimator, Nakahira, Mo.Y
%
% Jan.31
% Yu Zheng

%% redefine the system model for local estimator
I = randperm(n_meas,size_I);
y_I = y(I);
C_I = C(I,:);

%% estimation scheme
[P,~,~] = idare(A.', C_I.',B*B.',0,[],[]);
if size(P,1) == 0
    P =zeros(size(A));
end
K = (P*C_I.')*inv(C_I*P*C_I.');


x_hat = A*x_last-K*(y_I-C_I*x_last);
res = y_I-C_I*x_last;

%% a matrix for threshold
F = [A+K*C_I B;
     C_I zeros(size_I,size(B,2))];


end