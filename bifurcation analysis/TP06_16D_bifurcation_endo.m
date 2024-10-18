%% author: André H. Erhardt (andre.erhardt@wias-berlin.de, https://orcid.org/0000-0003-4389-8554)
clear all
close all
clc
global lds cds
tic
%% parameters
endo_case = 1;
if endo_case == 1
    scaleKr  = 0.1; 
    scaleCaL = 5;
    name = 'TP06_16D_endo_case_1';
elseif endo_case == 2
    scaleKr  = 0.5; 
    scaleCaL = 6;
    name = 'TP06_16D_endo_case_2';
end
g_Kr    = 0.153*scaleKr;
g_CaL   = 3.98e-5*scaleCaL;

g_Ks    = 0.038;
g_Ks_M  = 0.098;
g_Na    = 14.838;
g_K1    = 5.405;
K_i     = 138.3;
Cm      = 1;
ap      = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% parameter setting
p_bif(1) = g_Kr;
p_bif(2) = g_Ks;
p_bif(3) = g_Na;
p_bif(4) = g_K1;
p_bif(5) = g_CaL;
p_bif(6) = Cm;
p_bif(7) = K_i;
p_bif    = p_bif(:);

p(1) = g_Kr;
p(2) = g_Ks;
p(3) = g_Na;
p(4) = g_K1;
p(5) = g_CaL;
p(6) = K_i;
p(7) = Cm;
p    = p(:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% simulation
opts    = odeset('RelTol',1e-13,'AbsTol',1e-18);
hfs     = TP06_endo;
hfs1    = TP06_endo_16d;
hfs_bif = TP06_endo_16d_bif;
tspan   = [0 200000]; 
y0      = [-86.709,0.00448,0.476,0.0087,0.00155,0.7573, 0.7,3.164e-5,0.8009,0.9778,0.9953,0.3212,2.235e-8,0.9068,0.00013,3.715,0.00036,10.355,K_i];
[t,y]   = ode15s(hfs{2},tspan,y0,opts,p(1),p(2),p(3),p(4),p(5),p(7));
y0      = [-86.709,0.00448,0.476,0.0087,0.00155,3.164e-5,0.8009,0.9778,0.9953,0.3212,2.235e-8,0.9068,0.00013,3.715,0.00036,10.355];
[t1,y1] = ode15s(hfs1{2},tspan,y0,opts,p_bif(1),p_bif(2),p_bif(3),p_bif(4),p_bif(5),p_bif(6),p_bif(7));
%% plot 
figure;
hold on
h  = plot(t,y(:,1),'-','Linewidth',3,'Color',[0 0 0]);
h1 = plot(t1,y1(:,1),'--','Linewidth',3,'Color',[0 0 1]);
ylabel('Voltage V (mV)')
xlabel('time t (ms)')
set(gca,'Fontsize',20,'FontWeight','bold');
xlabel('time $t$ (ms)','Interpreter','latex');
ylabel('voltage $V$ (mV)','Interpreter','latex');
set(gca,'Fontsize',50,'FontWeight','bold');
L = legend([h,h1],'endocardial cell TP06','endocardial cell modified TP06');
set(L,'Interpreter','latex','Box','off','Fontsize',25,'FontWeight','bold');
grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% equilibrium curve
xinit   = y1(end,:)';
fun     = @(x) hfs_bif{2}(0,x,p_bif(1),p_bif(2),p_bif(3),p_bif(4),p_bif(5),p_bif(6),p_bif(7));
xinit   = fsolve(fun,xinit);
[x0,v0] = init_EP_EP(@TP06_endo_16d_bif,xinit,p_bif,ap);

opt = contset;
opt = contset(opt,'Eigenvalues'   ,        1);
opt = contset(opt,'SymDerivative' ,        3); 
opt = contset(opt,'SymDerivativeP',        2); 
opt = contset(opt,'MaxNumPoints'  ,    20000); 
opt = contset(opt,'MinStepsize'   ,    1e-10); 
opt = contset(opt,'MaxStepsize'   ,     1e-3);
opt = contset(opt,'InitStepsize'  ,0.25*1e-3); 
opt = contset(opt,'Singularities' ,        1);
opt = contset(opt,'Backward'      ,        0);

[xeq,veq,seq,heq,feq] = cont(@equilibrium,x0,v0,opt);

opt = contset(opt,'Backward'      ,        1);

[xeq1,veq1,seq1,heq1,feq1] = cont(@equilibrium,x0,v0,opt);

opt = contset;
opt = contset(opt,'Eigenvalues'   ,        1);
opt = contset(opt,'SymDerivative' ,        4); 
opt = contset(opt,'SymDerivativeP',        2); 
opt = contset(opt,'MaxNumPoints'  ,    20000); 
opt = contset(opt,'MaxStepsize'   ,        1); 
opt = contset(opt,'Singularities' ,        1);
opt = contset(opt,'Backward'      ,        1);

[xeq1a,veq1a,seq1a,heq1a,feq1a] = cont(@equilibrium,x0,v0,opt);
%% plot
figure;
hold on
cpl(xeq,veq,seq,[size(xeq,1) 1]);
cpl(xeq1,veq1,seq1,[size(xeq1,1) 1]);
xlabel('bifurcation parameter')
ylabel('voltage V')
xlim([0 0.4])
hold off


figure;
    hold on
    cpl_stability_1(xeq,feq)
    cpl_stability_1(xeq1,feq1)
    for j = 2:length(seq)-1
        if seq(j).data.lyapunov == 'Neutral saddle'

        elseif seq(j).data.lyapunov > 0
            plot (xeq(end,seq(j).index),xeq(1,seq(j).index),'.','Color',[0 0 1],'Markersize',15)
        elseif seq(j).data.lyapunov < 0
            plot (xeq(end,seq(j).index),xeq(1,seq(j).index),'.','Color',[1 0 0],'Markersize',15)
        end
    end
    for j = 2:length(seq1)-1
        if seq1(j).data.lyapunov == 'Neutral saddle'

        elseif seq1(j).data.lyapunov > 0
            plot (xeq1(end,seq1(j).index),xeq1(1,seq1(j).index),'.','Color',[0 0 1],'Markersize',15)
        elseif seq1(j).data.lyapunov < 0
            plot (xeq1(end,seq1(j).index),xeq1(1,seq1(j).index),'.','Color',[1 0 0],'Markersize',15)
        end
    end
    xlabel('bifurcation parameter')
    ylabel('voltage V')
    xlim([0 0.4])
    hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Andronov-Hopf continuation
h         = 1e-6;
ntst      =  400;
ncol      =    4;
xinit     = xeq1a(1:end-1,seq1a(2).index);
p_bif(ap) = xeq1a(end,seq1a(2).index);
[x0,v0]   = init_H_LC(@TP06_endo_16d_bif,xinit,p_bif,ap,h,ntst,ncol);

opt = contset;
opt = contset(opt,'MaxNumPoints'       ,    100); 
opt = contset(opt,'Singularities'      ,      1);
opt = contset(opt,'MinStepsize'        ,  1e-10);
opt = contset(opt,'MaxStepsize'        ,      5); 
opt = contset(opt,'SymDerivative'      ,      3); 
opt = contset(opt,'SymDerivativeP'     ,      2); 
opt = contset(opt,'IgnoreSingularity'  ,  [1,3]);
opt = contset(opt,'MoorePenrose'       ,      1);
opt = contset(opt,'MaxNewtonIters'     ,     50);
opt = contset(opt,'MaxCorrIters'       ,     50);
 
[xlc,vlc,slc,hlc,flc]=cont(@limitcycle,x0,v0,opt);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% save, plot and continue
save(name)

for i = 1:10     
    i
    figure;
    hold on
    cpl(xeq,veq,seq,[size(xeq,1) 1]);
    cpl(xeq1,veq1,seq1,[size(xeq1,1) 1]);
    cpl(xeq1a,veq1a,seq1a,[size(xeq1a,1) 1]);
    xlabel('bifurcation parameter')
    ylabel('voltage V')
    hold on
    ODEDim = size(xeq,1)-1;
    points = size(xlc,2);
    xx     = xlc(1:end-2,:);
    xx     = reshape(xx, [ODEDim size(xx,1)/ODEDim points]);
    Param  = xlc(end,:);
    xmax   = squeeze(max(xx(1,:,:), [], 2));
    xmin   = squeeze(min(xx(1,:,:), [], 2));
    cpl([Param; xmax'], vlc, slc, [1 2]);
    cpl([Param; xmin'], vlc, slc, [1 2]);
    xlim([0.06 0.13])

    [xlc,vlc,slc,hlc,flc] = cont(xlc,vlc,slc,hlc,flc,cds);
    save(name)
end

q = 7;
figure;
hold on 
plotlimitcycle(xlc(:,1:1:end),vlc(:,1:1:end),slc,[size(xlc,1) q 1],[1 0 0],0.3,'none',0.2)
cpl_stability_codim1(xeq,seq,feq,q,1,[0 0 0],50,3)
cpl_stability_codim1(xeq1a,seq1a,feq1a,q,1,[0 0 0],50,3)
xlim([0.06 0.13])
view([155 5])

save(name)
