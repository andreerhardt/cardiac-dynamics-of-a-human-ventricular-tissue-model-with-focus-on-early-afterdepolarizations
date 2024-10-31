clear all
close all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 0:2
    if i == 0
        % epi
        cases = 'epi';
    elseif i == 1
        % endo
        cases = 'end';
    elseif i == 2   
        % M
        cases = 'M';
    end
%% parameters
    if cases == 'epi'
        % epi 
        choice = 0;
        g_Ks = 0.392;
    elseif cases == 'end'
        % endo
        g_Ks = 0.392;
        choice = 1;
    elseif cases == 'M'
        % M cell
        choice = 0;   
        g_Ks = 0.098;
    end
    g_Kr  = 0.153*0.1;
    g_Na  = 14.838; 
    g_K1  = 5.405; 
    g_CaL = 3.98e-5*5;
    K_i   = 138.3;
    Cm    = 1;
    stim  = 85;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% simulation
    opts  = odeset('RelTol',1e-13,'AbsTol',1e-18);
    tspan = [0 4000]; 
    y0_ = [-86.709,0.00448,      0.0087,0.00155,            3.164e-5,0.8009,0.9778,0.9953,0.3212,         0.9068,0.00013,3.715,0.00036,10.355];
    y0  = [-86.709,0.00448,0.476,0.0087,0.00155,            3.164e-5,0.8009,0.9778,0.9953,0.3212,2.235e-8,0.9068,0.00013,3.715,0.00036,10.355];
    y01 = [-86.709,0.00448,0.476,0.0087,0.00155,0.7573, 0.7,3.164e-5,0.8009,0.9778,0.9953,0.3212,2.235e-8,0.9068,0.00013,3.715,0.00036,10.355,K_i];
    y02 = [-86.709,0.00448,0.476,0.0087,0.00155,0.7573, 0.7,3.164e-5,0.8009,0.9778,0.9953,0.3212,2.235e-8,0.9068,0.00013,3.715,0.00036,10.355];
    if cases == 'epi'
        % epi 
        [t_epi1,y_epi1]   = ode15s(@fun_modified_TP06_epi_M_endo_14d,tspan,y0_,opts,g_Kr,g_Ks,g_Na,g_K1,g_CaL,K_i,stim,choice);
        [t_epi,y_epi]     = ode15s(@fun_modified_TP06_epi_M_endo_16d,tspan,y0,opts,g_Kr,g_Ks,g_Na,g_K1,g_CaL,K_i,stim,choice);
        [t,y]             = ode15s(@fun_TP06_model,tspan,y01,opts,g_Kr,g_Ks,g_Na,g_K1,g_CaL,choice);
        [t_epi_,y_epi_]   = ode15s(@fun_modified_TP06_epi_M_endo_18d,tspan,y02,opts,g_Kr,g_Ks,g_Na,g_K1,g_CaL,K_i,choice);
    elseif cases == 'end'
        % endo
        [t_endo1,y_endo1] = ode15s(@fun_modified_TP06_epi_M_endo_14d,tspan,y0_,opts,g_Kr,g_Ks,g_Na,g_K1,g_CaL,K_i,stim,choice);
        [t_endo,y_endo]   = ode15s(@fun_modified_TP06_epi_M_endo_16d,tspan,y0,opts,g_Kr,g_Ks,g_Na,g_K1,g_CaL,K_i,stim,choice);
        [t1,y1]           = ode15s(@fun_TP06_model,tspan,y01,opts,g_Kr,g_Ks,g_Na,g_K1,g_CaL,choice);
        [t_endo_,y_endo_] = ode15s(@fun_modified_TP06_epi_M_endo_18d,tspan,y02,opts,g_Kr,g_Ks,g_Na,g_K1,g_CaL,K_i,choice);
    elseif cases == 'M'
        % M cell
        [t_M,y_M]       = ode15s(@fun_modified_TP06_epi_M_endo_16d,tspan,y0,opts,g_Kr,g_Ks,g_Na,g_K1,g_CaL,K_i,52,choice);
        [t_M1,y_M1]     = ode15s(@fun_modified_TP06_epi_M_endo_16d,tspan,y0,opts,g_Kr,g_Ks,g_Na,g_K1,g_CaL,K_i,60,choice);
        [t_M2,y_M2]     = ode15s(@fun_modified_TP06_epi_M_endo_14d,tspan,y0_,opts,g_Kr,g_Ks,g_Na,g_K1,g_CaL,K_i,85,choice);
        [t2,y2]         = ode15s(@fun_TP06_model,tspan,y01,opts,g_Kr,g_Ks,g_Na,g_K1,g_CaL,choice);
        [t_M_,y_M_]     = ode15s(@fun_modified_TP06_epi_M_endo_18d,tspan,y02,opts,g_Kr,g_Ks,g_Na,g_K1,g_CaL,K_i,choice);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot
figure;
tiledlayout("vertical")
nexttile
hold on 
h   = plot(t_epi,y_epi(:,1),'-','Linewidth',10,'Color',[0.3010 0.7450 0.9330]);
h1  = plot(t,y(:,1),'--','Linewidth',10,'Color',[1 0 0]);
h2  = plot(t_epi_,y_epi_(:,1),'-','Linewidth',4,'Color',[0 0 0]);
title('epicardial cell','Interpreter','latex')
set(gca,'Fontsize',50,'FontWeight','bold');
ylabel('voltage $V$ (mV)','Interpreter','latex');
L = legend([h,h1,h2],'16 dimensional model','TP06 model','18 dimensional model');
set(L,'Interpreter','latex','Box','off','Fontsize',50,'FontWeight','bold','Location','southwest');
ylim([-90 85])
xlim([0 500])
xticks([])
nexttile
hold on
h   = plot(t_endo,y_endo(:,1),'-','Linewidth',10,'Color',[0.3010 0.7450 0.9330]);
h1  = plot(t1,y1(:,1),'--','Linewidth',10,'Color',[1 0 0]);
h2  = plot(t_endo_,y_endo_(:,1),'-','Linewidth',4,'Color',[0 0 0]);
title('endocardial cell','Interpreter','latex')
set(gca,'Fontsize',50,'FontWeight','bold');
ylim([-90 85])
xlim([0 500])
xlabel('time $t$ (ms)','Interpreter','latex');
ylabel('voltage $V$ (mV)','Interpreter','latex');
L = legend([h,h1,h2],'16 dimensional model','TP06 model','18 dimensional model');
set(L,'Interpreter','latex','Box','off','Fontsize',50,'FontWeight','bold','Location','southwest');

figure;
tiledlayout("vertical")
nexttile
hold on 
h   = plot(t_M,y_M(:,1),'-','Linewidth',10,'Color',[0.3010 0.7450 0.9330]);
h1  = plot(t2,y2(:,1),'--','Linewidth',10,'Color',[1 0 0]);
h2  = plot(t_M_,y_M_(:,1),'-','Linewidth',4,'Color',[0 0 0]);
title('M cell','Interpreter','latex')
set(gca,'Fontsize',50,'FontWeight','bold');
ylabel('voltage $V$ (mV)','Interpreter','latex');
L = legend([h],'16 dimensional model with $\mathrm{I}_\mathrm{stim} = 52 \frac{pA}{pF}$');
set(L,'Interpreter','latex','Box','off','Fontsize',50,'FontWeight','bold','Location','northeast');
ylim([-90 85])
%xlim([0 1800])
xticks([])
nexttile
hold on
h   = plot(t_M1,y_M1(:,1),'-','Linewidth',10,'Color',[0.3010 0.7450 0.9330]);
h1  = plot(t2,y2(:,1),'--','Linewidth',10,'Color',[1 0 0]);
h2  = plot(t_M_,y_M_(:,1),'-','Linewidth',4,'Color',[0 0 0]);
h3  = plot(t_M2,y_M2(:,1),':','Linewidth',4,'Color',[0.4660 0.6740 0.1880]);
set(gca,'Fontsize',50,'FontWeight','bold');
ylim([-90 85])
% xlim([0 1800])
xlabel('time $t$ (ms)','Interpreter','latex');
ylabel('voltage $V$ (mV)','Interpreter','latex');
L1 = legend([h1,h2],'TP06 model','18 dimensional model');
set(L1,'Interpreter','latex','Box','off','Fontsize',50,'FontWeight','bold','Location','southwest','NumColumns',1);
ah1 = axes('position',get(gca,'position'),'visible','off');
L2 = legend(ah1,[h,h3],'16 dimensional model with $\mathrm{I}_\mathrm{stim} = 60 \frac{pA}{pF}$','14 dimensional model with $\mathrm{I}_\mathrm{stim} = 85 \frac{pA}{pF}$');
set(L2,'Interpreter','latex','Box','off','Fontsize',50,'FontWeight','bold','Location','northeast');