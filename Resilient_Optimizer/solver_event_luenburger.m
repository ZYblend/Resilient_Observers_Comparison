function [z_next,V] = solver_event_luenburger(y,u,z,A_ETLO,B_ETLO,Q_ETLO,n_attack,n_state,n_meas,T,V_last)
%% function z = solver_event_luenburger()
% this is the solver for event-tiggered luenburger observer
%
% Jan.29
% Yu Zheng

%% Time update
u_bar = [u;y];
z_hat = A_ETLO*z+B_ETLO*u_bar;

%% Pojection operation
z_proj = projection(z_hat,n_state,n_meas,n_attack,T);
z_next = z_proj;

%% Lyapunov-based event trigger
a = 0.1;
V = Lyapunov(y,Q_ETLO,z_next);
sigma = eye(T*n_meas);
L = Q_ETLO.' * sigma;

while V >= (1-a)*V_last
    m = 0;
    z_proj = projection(z_next,n_state,n_meas,n_attack,T);
    z_hat = z_proj;
    V_temp = Lyapunov(y,Q_ETLO,z_hat);
    while V_temp >=(1-a)*V
        z_hat = z_hat + L*(y-Q_ETLO*z_hat);
        V_temp = Lyapunov(y,Q_ETLO,z_hat);
        m =m+1;
        if m>5
            break
        end
    end
    z_next = z_hat;
    if m>5
        break
    end
end



end

function v = Lyapunov(y,Q,z)
v = 0.5 * norm(y-Q*z)^2;
end
