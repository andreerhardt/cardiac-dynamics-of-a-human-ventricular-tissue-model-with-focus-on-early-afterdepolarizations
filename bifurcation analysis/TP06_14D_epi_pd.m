clear all
close all
clc
global lds cds
epi_case = 2;
if epi_case == 1
    name = 'TP06_14D_epi_case_1';
elseif epi_case == 2
    name = 'TP06_14D_epi_case_2';
end

load(name)

[x1,v1] = init_PD_LC(@TP06_epi_14d_bif,xlc,slc(end-1),ntst,ncol,h);

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

[xpd,vpd,spd,hpd,fpd]=cont(@limitcycle,x1,v1,opt);
% save(name)

for i = 1:2
    [xpd,vpd,spd,hpd,fpd]=cont(xpd,vpd,spd,hpd,fpd,cds);
    % save(name)
end

figure;
hold on
cpl(xeq,veq,seq,[size(xeq,1) 1],[0 0 0]);
cpl(xeq1,veq1,seq1,[size(xeq1,1) 1],[0 0 0]);
cpl(xeq1a,veq1a,seq1a,[size(xeq1a,1) 1],[0 0 0]);
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

points = size(xlc1,2);
xx     = xlc1(1:end-2,:);
xx     = reshape(xx, [ODEDim size(xx,1)/ODEDim points]);
Param  = xlc1(end,:);
xmax   = squeeze(max(xx(1,:,:), [], 2));
xmin   = squeeze(min(xx(1,:,:), [], 2));
cpl([Param; xmax'], vlc1, slc1, [1 2]);
cpl([Param; xmin'], vlc1, slc1, [1 2]);

points = size(xpd,2);
xx     = xpd(1:end-2,:);
xx     = reshape(xx, [ODEDim size(xx,1)/ODEDim points]);
Param  = xpd(end,:);
xmax   = squeeze(max(xx(1,:,:), [], 2));
xmin   = squeeze(min(xx(1,:,:), [], 2));
cpl([Param; xmax'], vpd, spd, [1 2]);
cpl([Param; xmin'], vpd, spd, [1 2]);
xlim([0.06 0.13])

figure;
q = 6;
hold on
cpl_stability_codim1(xeq,seq,feq,q,1,[0 0 0],50,3)
plotlimitcycle(xpd(:,1:1:end),vpd(:,1:1:end),spd,[size(xpd,1) q 1],[0 1 1],0.3,'none',0.2)
plotlimitcycle(xlc1(:,1:1:end),vlc1(:,1:1:end),slc1,[size(xlc1,1) q 1],[1 0 0],0.3,'none',0.2)
plotlimitcycle(xlc2(:,1:1:end),vlc2(:,1:1:end),slc2,[size(xlc2,1) q 1],[1 0 0],0.3,'none',0.2)
dim = size(xeq,1) - 1;
for k = 2:length(spd)-1
    if spd(k).label == 'NS '
        plot3(xpd(end,spd(k).index)*xpd(q:dim:end-2,spd(k).index)./xpd(q:dim:end-2,spd(k).index),xpd(q:dim:end-2,spd(k).index),xpd(1:dim:end-2,spd(k).index),'-','Color',[0 0 1],'Linewidth',3);
    elseif spd(k).label == 'PD '
        plot3(xpd(end,spd(k).index)*xpd(q:dim:end-2,spd(k).index)./xpd(q:dim:end-2,spd(k).index),xpd(q:dim:end-2,spd(k).index),xpd(1:dim:end-2,spd(k).index),'-','Color',[0 1 1],'Linewidth',3);
    end
end
plot_bif_diagram(xeq1a,seq1a,feq1a,xlc,slc,flc,q,1,[0 0 0],50,3,[size(xlc,1) q 1],0.3,'none',0.2)
xlim([0.06 0.13])
view([155 5])


% par=spd(end).data.parametervalues;
% [x2,v2] = init_LC_LC(@TP06_epi_14d_bif, xpd, vpd, spd(end), par, ap, ntst, ncol);
% opt = contset(opt,'MaxStepsize'        ,      10);
% opt = contset(opt,'MinStepsize'        ,   1e-12);
% opt = contset(opt,'MaxNewtonIters'     ,       3);
% opt = contset(opt,'MaxCorrIters'       ,     100);
% opt = contset(opt,'MaxTestIters'       ,     100);
% opt = contset(opt,'Singularities'      ,       0);
% opt = contset(opt,'Backward'           ,       1);
% opt = contset(opt,'FunTolerance'       ,    1e-4);
% [xpd1,vpd1,spd1,hpd1,fpd1]=cont(@limitcycle,x2,v2,opt);
% 
% for i = 1:2
%     [xpd1,vpd1,spd1,hpd1,fpd1]=cont(xpd1,vpd1,spd1,hpd1,fpd1,cds);
%     % save(name)
% end
% 
% figure;
% q = 7;
% xlim([0.06 0.13])
% view([155 5])
% hold on 
% %plotfigure1(xlc(:,1:end),vlc(:,1:end),slc,[size(xlc,1) q 1],[1 0 0]);
% plotfigure1(xpd(:,1:end),vpd(:,1:end),spd,[size(xpd,1) q 1],[0 0 1]);
% plotfigure(xpd1(:,1:end),vpd1(:,1:end),spd1,[size(xpd1,1) q 1],[1 0 0]);