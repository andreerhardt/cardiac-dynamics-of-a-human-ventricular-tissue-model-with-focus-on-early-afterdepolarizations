%% author: André H. Erhardt (andre.erhardt@wias-berlin.de, https://orcid.org/0000-0003-4389-8554)
%%
% the function files TP06_epi_14d and TP06_epi_14d_bif are required
%%
clear all
close all
clc
global lds cds
tic
%% parameters
scaleKr  = 0.18; 
scaleCaL = 5;
name = 'TP06_14D_epi_case';

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% simulation
opts    = odeset('RelTol',1e-13,'AbsTol',1e-18);
hfs1    = TP06_epi_14d;
hfs_bif = TP06_epi_14d_bif;
tspan   = [0 1000]; 
y0      = [-86.709,0.00448,0.0087,0.00155,3.164e-5,0.8009,0.9778,0.9953,0.3212,0.9068,0.00013,3.715,0.00036,10.355];
[t1,y1] = ode15s(hfs1{2},tspan,y0,opts,p_bif(1),p_bif(2),p_bif(3),p_bif(4),p_bif(5),p_bif(6),p_bif(7));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% equilibrium curve
xinit   = y1(end,:)';
fun     = @(x) hfs_bif{2}(0,x,p_bif(1),p_bif(2),p_bif(3),p_bif(4),p_bif(5),p_bif(6),p_bif(7));
xinit   = fsolve(fun,xinit);
[x0,v0] = init_EP_EP(@TP06_epi_14d_bif,xinit,p_bif,ap);

opt = contset;
opt = contset(opt,'Eigenvalues'   ,        1);
opt = contset(opt,'SymDerivative' ,        3); 
opt = contset(opt,'SymDerivativeP',        2); 
opt = contset(opt,'MaxNumPoints'  ,    10000); 
opt = contset(opt,'MinStepsize'   ,    1e-10); 
opt = contset(opt,'MaxStepsize'   ,     1e-3);
opt = contset(opt,'InitStepsize'  ,0.25*1e-3); 
opt = contset(opt,'Singularities' ,        1);
opt = contset(opt,'Backward'      ,        1);

[xeq,veq,seq,heq,feq] = cont(@equilibrium,x0,v0,opt);

opt = contset(opt,'Backward'      ,        0);

[xeq1,veq1,seq1,heq1,feq1] = cont(@equilibrium,x0,v0,opt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Andronov-Hopf continuation
h         = 1e-6;
ntst      =   50;
ncol      =    4;
xinit     = xeq(1:end-1,seq(2).index);
p_bif(ap) = xeq(end,seq(2).index);
[x0,v0]   = init_H_LC(@TP06_epi_14d_bif,xinit,p_bif,ap,h,ntst,ncol);

opt = contset;
opt = contset(opt,'MaxNumPoints'       ,    200); 
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
%% limit-cycle continuation from the first period-doubling bifurcation
[x1,v1] = init_PD_LC(@TP06_epi_14d_bif,xlc,slc(end-1),ntst,ncol,h);
opt = contset(opt,'MaxNumPoints'       ,    150); 
[xpd,vpd,spd,hpd,fpd]=cont(@limitcycle,x1,v1,opt);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% save
save(name)

q = 7;
figure;
plot_bif_diagram(xeq,seq,feq,xlc,slc,flc,q,1,[0 0 0],50,3,[size(xlc,1) q 1],0.3,'none',0.2)
xlim([0.06 0.13])
view([155 5])

figure;
hold on
cpl_stability_codim1(xeq1,seq1,feq1,q,1,[0 0 0],50,3)
plotlimitcycle(xpd(:,1:1:end),vpd(:,1:1:end),spd,[size(xpd,1) q 1],[0 1 1],0.3,'none',0.2)
plot_bif_diagram(xeq,seq,feq,xlc,slc,flc,q,1,[0 0 0],50,3,[size(xlc,1) q 1],0.3,'none',0.2)
xlim([0.06 0.13])
view([155 5])