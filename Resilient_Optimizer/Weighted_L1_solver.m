function z = Weighted_L1_solver(y,u,H,Phi,q)
%
% @Written by Yu Zheng, Tallahassee, Florida, Aug. 2020


n  = size(Phi,2);  % the number of states
N = length(y); % length of measured outputs over the entire receding horizon

w = ones(N,1);
% w(q<0.5) = 0.1 + (0.1+0.9)*rand(1,1);
w(q<0.5) = 0.01;

f = [zeros(n,1);
     w];
A = [-Phi -eye(N);
      Phi -eye(N)];
b = [-y+H*u;
      y-H*u];
z = linprog(f,A,b);
% if length(t)~=N+n
%     error = norm(x0);
% else
%     x_hat = t(1:n);
% 
%     %% calculate the estimate error measured by l2 norm
%     error = norm(x_hat-x0);
% end
end