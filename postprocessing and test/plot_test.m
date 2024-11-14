clear all
close all
clc

name = 'TP06_14D_epi_case';
load(name)
q = 7; % first variable, i.e. f2. The second variable is V
%% plot (only) equilibrium curve containing the stability and bifurcation
%% points if existent using cpl_stability_codim1(xeq,seq,feq,variable1,variable2,color,Pointsize,Linesize)
%% 
figure;
hold on
cpl_stability_codim1(xeq,seq,feq,q,1,[0 0 0],50,3)
cpl_stability_codim1(xeq1,seq1,feq1,q,1,[0 0 0],50,3)
%% plot (only) only limit cycle branch using
%% plotlimitcycle(x,v,s,e,color,EdgeAlpha,LineStyle,FaceAlpha)
figure;
plotlimitcycle(xlc(:,1:1:end),vlc(:,1:1:end),slc,[size(xlc,1) q 1],[1 0 0],0.3,'none',0.2)
xlim([0.06 0.13])
view([155 5])
%% plot bifurcation diagram including the equilibrium curve and the first 
%% limit cycle branch with potential codim one bifurcations, i.e. Andronov-
%% Hopf bifurcation, fold bifurcation, branch point bifurcation, torus and
%% period doubling bifurcation
figure;
plot_bif_diagram(xeq,seq,feq,xlc,slc,flc,q,1,[0 0 0],50,3,[size(xlc,1) q 1],0.3,'none',0.2)
xlim([0.06 0.13])
view([155 5])
% 
figure;
hold on
cpl_stability_codim1(xeq1,seq1,feq1,q,1,[0 0 0],50,3)
plotlimitcycle(xpd(:,1:1:end),vpd(:,1:1:end),spd,[size(xpd,1) q 1],[0 1 1],0.3,'none',0.2)
plot_bif_diagram(xeq,seq,feq,xlc,slc,flc,q,1,[0 0 0],50,3,[size(xlc,1) q 1],0.3,'none',0.2)
xlim([0.06 0.13])
view([155 5])