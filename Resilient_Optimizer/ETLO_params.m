function [A_ETLO,B_ETLO,Q_ETLO] = ETLO_params(A_bar_d,B_bar_d,C_obsv_d,T)
%% function [A_ETLO,B_ETLO,Q_ETLO] = ETLO_params(A_bar_d,B_bar_d,C_obsv_d,T)
% This function is to construct the system model for event-triggered
% luenburger observer
% Shoukry, Yasser, and Paulo Tabuada. "Event-triggered state observers for sparse sensor noise/attacks." IEEE Transactions on Automatic Control 61.8 (2015): 2079-2091.
%
% Jan. 29
% Yu Zheng

[m,n] = size(C_obsv_d);
p = size(B_bar_d,2);

S = [zeros(T-1,1) eye(T-1,T-1);
     zeros(1,T)];

A_ETLO = [A_bar_d zeros(n,T*m);
          zeros(T*m,T*m+n)];
B_ETLO = [B_bar_d zeros(n,(T-1)*p+m);
          zeros(T*m,T*p+m)];

      
for i = 1:m
    A_ETLO(n+(i-1)*T+1:n+i*T, 1:n) = [zeros(T-1,n); -C_obsv_d(i,:)*A_bar_d^T];
    A_ETLO(n+(i-1)*T+1:n+i*T, n+(i-1)*T+1:n+i*T) = S;
    
    for j = 1:T
        H = zeros(T,T*p);
        H(T,1+p*(j-1):p*j) = -C_obsv_d(i,:)*A_bar_d^(T-j)*B_bar_d;
        G = zeros(T,n);
        G(j,:) = C_obsv_d(i,:)*A_bar_d^(j-1);
    end      
    B_ETLO(n+(i-1)*T+1:n+i*T,1:T*p) = H;
    b = zeros(1,m);
    b(i) = 1;
    B_ETLO(n+(i-1)*T+1:n+i*T,T*p+1:end) = [zeros(T-1,m);b];
    
    Q_ETLO = zeros(T*m,n+T*m);
    Q_ETLO(1+(i-1)*T:T*i,1:n) = G;
    Q_ETLO(:,n+1:end) = eye(T*m);
end

end