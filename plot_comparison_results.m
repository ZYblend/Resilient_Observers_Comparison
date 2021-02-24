%% plot the resilient obserevrs comparison result

% Yu Zheng, 2021, Jan,31

%% Extracting values
time_vec  = out.logsout.getElement('x').Values.Time;

% State vectors
x         = out.logsout.getElement('x').Values.Data; % true states
error_LO  = out.logsout.getElement('error_LO').Values.Data; % error of luenburger
error_L1O  = out.logsout.getElement('error_L1O').Values.Data; % error of L1 observer
error_ELO = out.logsout.getElement('error_ELO').Values.Data; % error of event-triggered luenburger
error_MMO = out.logsout.getElement('error_MMO').Values.Data; % error of multi-model observer
error_WL1P = out.logsout.getElement('error_WL1P').Values.Data; % error of pruning observer

x_hat_LO  = out.logsout.getElement('x_hat_LO').Values.Data; % Observed states (Luenberger)
x_hat_L1O = out.logsout.getElement('x_hat_L1O').Values.Data; % Observed states (Unconstrained l1)
x_hat_MMO = out.logsout.getElement('x_hat_MMO').Values.Data; % Observed states (muti-model)
x_hat_ELO = out.logsout.getElement('x_hat_ELO').Values.Data; % Observed states (event-triggered luenburger)
x_hat_WL1P = out.logsout.getElement('x_hat_WL1P').Values.Data; % Observed states (pruning)

% FDIA performance
aux_model_res  = out.logsout.getElement('y_obsv').Values.Data; % measured y for observer (y_obsv = y-D*u)
BDD_res        = out.logsout.getElement('BDD_res').Values.Data; % Bad data residue

%% Ploting/Visualization/Metric tables
% figure(1) % errors
figure(2) % states
% figure(3) % BDD

LW = 1.3;  % linewidth
FS = 15;   % font size

% % error visulization
% figure(1)
% subplot(5,1,1)
% plot(time_vec,error_LO,'LineWidth',LW)
% ylabel('error','FontWeight','bold','Fontsize',FS)
% title('Luenburger Observer','Fontsize',FS)
% set(gca,'fontweight','bold','fontsize',FS) 
% set(gca,'LineWidth',1)
% 
% figure(1)
% subplot(5,1,2)
% plot(time_vec,error_L1O,'LineWidth',LW)
% ylabel('error','FontWeight','bold','Fontsize',FS)
% title('Unconstrained L_1 Observer','Fontsize',FS)
% set(gca,'fontweight','bold','fontsize',FS) 
% set(gca,'LineWidth',1)
% 
% 
% figure(1)
% subplot(5,1,3)
% plot(time_vec,error_MMO,'LineWidth',LW)
% ylabel('error','FontWeight','bold','Fontsize',FS)
% title('Multi-model Observer','Fontsize',FS)
% set(gca,'fontweight','bold','fontsize',FS) 
% set(gca,'LineWidth',1)
% 
% 
% figure(1)
% subplot(5,1,4)
% plot(time_vec,error_ELO,'LineWidth',LW)
% ylabel('error','FontWeight','bold','Fontsize',FS)
% title('Event-triggered Luenburger Observer','Fontsize',FS)
% set(gca,'fontweight','bold','fontsize',FS) 
% set(gca,'LineWidth',1)
% 
% 
% figure(1)
% subplot(5,1,5)
% plot(time_vec,error_WL1P,'LineWidth',LW)
% ylabel('error','FontWeight','bold','Fontsize',FS)
% title('Resilient Pruning Observer','Fontsize',FS)
% set(gca,'fontweight','bold','fontsize',FS) 
% set(gca,'LineWidth',1)


% states estimation compare


figure (2)
for iter=1:5
    subplot(5,5,1+(iter-1)*5)
    plot(time_vec,error_LO(:,iter),'k','LineWidth',LW)
    if(iter == 1)
        title('LO','Fontsize',FS)
    end
    ylabel(['$$\delta_{' num2str(iter) '}-\hat{\delta_{' num2str(iter) '}}$$'],'FontWeight','bold','Fontsize',FS,'interpreter','latex')
    set(gca,'fontweight','bold','fontsize',12) 
    set(gca,'LineWidth',1)
    
    subplot(5,5,2+(iter-1)*5)
    plot(time_vec,error_L1O(:,iter),'k','LineWidth',LW)
    if(iter == 1)
        title('UL1O','Fontsize',FS)
    end
    set(gca,'fontweight','bold','fontsize',12) 
    set(gca,'LineWidth',1)
    
    subplot(5,5,3+(iter-1)*5)
    plot(time_vec,error_MMO(:,iter),'k','LineWidth',LW)
    if(iter == 1)
        title('MMO','Fontsize',FS)
    end
    set(gca,'fontweight','bold','fontsize',12) 
    set(gca,'LineWidth',1)

    subplot(5,5,4+(iter-1)*5)
    plot(time_vec,error_ELO(:,iter),'k','LineWidth',LW)
    if(iter == 1)
        title('ETLO','Fontsize',FS)
    end
    set(gca,'fontweight','bold','fontsize',12) 
    set(gca,'LineWidth',1)
    
    subplot(5,5,5+(iter-1)*5)
    plot(time_vec,error_WL1P(:,iter),'k','LineWidth',LW)
    if(iter == 1)
        title('RPO','Fontsize',FS)
    end
    set(gca,'fontweight','bold','fontsize',12) 
    set(gca,'LineWidth',1)
    
end


% % BDD_res
% figure(3)
% plot(time_vec,BDD_res,'k','LineWidth',LW), hold on
% plot(time_vec,BDD_thresh*ones(length(time_vec),1),'r--','LineWidth',2*LW)
% ylabel('Bad Data Detection Residual','FontWeight','bold')

% error metric table (for rotor angle)
n_delta = size(x,2)/2;  % number of generator angles
error_LO_delta = error_LO(:,1:n_delta).';
error_L1O_delta = error_L1O(:,1:n_delta).';
error_ELO_delta = error_ELO(:,1:n_delta).';
error_MMO_delta = error_MMO(:,1:n_delta).';
error_WL1P_delta = error_WL1P(:,1:n_delta).';

metric_rms = @(x,dim) sqrt(sum(x.^2,dim)/size(x,dim));
metric_max = @(x,dim) max(abs(x),[],dim);
error_table = [metric_rms(error_LO_delta,2) metric_rms(error_L1O_delta,2) metric_rms(error_ELO_delta,2) metric_rms(error_MMO_delta,2) metric_rms(error_WL1P_delta,2) ...
               metric_max(error_LO_delta,2) metric_max(error_L1O_delta,2) metric_max(error_ELO_delta,2) metric_max(error_MMO_delta,2) metric_max(error_WL1P_delta,2)];
