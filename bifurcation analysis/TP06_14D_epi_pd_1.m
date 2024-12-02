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

[x1,v1] = init_PD_LC(@TP06_epi_14d_bif,xpd,spd(2),ntst,ncol,h*10000);%*10000

opt = contset(opt,'MaxNumPoints'       ,     100);
opt = contset(opt,'MaxStepsize'        ,     0.1);
opt = contset(opt,'MaxNewtonIters'     ,       3);
opt = contset(opt,'MaxCorrIters'       ,     100);
opt = contset(opt,'MaxTestIters'       ,     100);

[xpd1,vpd1,spd1,hpd1,fpd1]=cont(@limitcycle,x1,v1,opt);
[xpd1,vpd1,spd1,hpd1,fpd1]=cont(xpd1,vpd1,spd1,hpd1,fpd1,cds);

for i = 1:2
    [xpd1,vpd1,spd1,hpd1,fpd1]=cont(xpd1,vpd1,spd1,hpd1,fpd1,cds);
    save(name)
end

par = spd1(end).data.parametervalues;
[x1,v1] = init_LC_LC(@TP06_epi_14d_bif,xpd1,vpd1,spd1(end),par,ap,ntst,ncol);
opt = contset(opt,'MaxStepsize'        ,       10);
[xpd2,vpd2,spd2,hpd2,fpd2]=cont(@limitcycle,x1,v1,opt);
[xpd2,vpd2,spd2,hpd2,fpd2]=cont(xpd2,vpd2,spd2,hpd2,fpd2,cds);

[x1,v1] = init_PD_LC(@TP06_epi_14d_bif,xpd1,spd1(2),ntst,ncol,h*10000);
[xpd3,vpd3,spd3,hpd3,fpd3]=cont(@limitcycle,x1,v1,opt);
[xpd3,vpd3,spd3,hpd3,fpd3]=cont(xpd3,vpd3,spd3,hpd3,fpd3,cds);

[Y1,Z1] = meshgrid(0:0.025:1,-85:40:85);
X1     = 0.098*Y1./Y1;

figure;
q = 6;
hold on
plotlimitcycle(xpd(:,1:1:end),vpd(:,1:1:end),spd,[size(xpd,1) q 1],[0 1 1],0.3,'none',0.2)
plotlimitcycle(xpd1(:,1:1:end),vpd1(:,1:1:end),spd1,[size(xpd1,1) q 1],[0 0 1],0.5,'none',0.5)
plotlimitcycle(xpd2(:,1:1:end),vpd2(:,1:1:end),spd2,[size(xpd2,1) q 1],[0 0 1],0.5,'none',0.5)
plotlimitcycle(xlc1(:,1:1:end),vlc1(:,1:1:end),slc1,[size(xlc1,1) q 1],[1 0 0],0.3,'none',0.2)
plotlimitcycle(xlc2(:,1:1:end),vlc2(:,1:1:end),slc2,[size(xlc2,1) q 1],[1 0 0],0.3,'none',0.2)
surf(X1,Y1,Z1,'Facecolor',[0.5 0.5 0.5],'LineStyle','none','FaceAlpha',0.3,'EdgeAlpha',0.2)
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
zlim([-85 85])
view([155 5])
