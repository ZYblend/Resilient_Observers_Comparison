function z_proj = projection(z,n,m,k,T)
%% function z_proj = projection(z,n,m,k,T)
% projection operator
% please refer to the Definition 4.1 in <Event-Triggered State Observers
% for Sparse Sensor Noise/Attacks>
%
% Jan.29
% Yu Zheng

e = z(n+1:end);
e_r = reshape(e,[m,T]);
e_n = vecnorm(e_r,2,2);
[~,idx] = mink(e_n,m-k);
e_r(idx,:) = 0;
e_r = e_r.';
e_proj = e_r(:);
z_proj = [z(1:n);e_proj];

end