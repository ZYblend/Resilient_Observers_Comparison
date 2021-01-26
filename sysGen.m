function [A,C]= sysGen(m,n)
% function [A,C]= sysGen(m,n)
% Inputs: 
%          m: [scalar] number of measurements
%          n: [scalar] number of states
% Outputs:
%          system: x^{+} = Ax
%                  y = Cx
%
% @Written by Yu Zheng, Tallahassee, Florida, Aug. 2020

% generate properly normalized Gaussian matrix A with i.i.d. entries
A_gen = (1/sqrt(n)) * randn(n,n);
A = zeros(size(A_gen));
for col = 1:n
    A(:,col) = A_gen(:,col)/norm( A_gen(:,col) );
end
C_gen = (1/sqrt(n)) * randn(m,n);
C = zeros(size(C_gen));
for col = 1:n
    C(:,col) = C_gen(:,col)/norm( C_gen(:,col) );
end


% examinate observability
unob = rank(obsv(A,C))-length(A); 
if unob == 0
    fprintf('full observable\n');
else
    fprintf('no full observable\n');
end

    
end
    