clear all
close all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('TP06_16D_endo_case_1.mat')
%
figure;
hold on
cpl_stability_1(xeq,feq)
cpl_stability_1(xeq1,feq1)
for j = 2:length(seq)-1
    if seq(j).data.lyapunov == 'Neutral saddle'

    elseif seq(j).data.lyapunov > 0
        plot (xeq(end,seq(j).index),xeq(1,seq(j).index),'.','Color',[0 0 1],'Markersize',15)
        seq(j).data
        xeq(end,seq(j).index)
    elseif seq(j).data.lyapunov < 0
        plot (xeq(end,seq(j).index),xeq(1,seq(j).index),'.','Color',[1 0 0],'Markersize',15)
        seq(j).data
        xeq(end,seq(j).index)
    end
end
for j = 2:length(seq1)-1
    if seq1(j).data.lyapunov == 'Neutral saddle'

    elseif seq1(j).data.lyapunov > 0
        plot (xeq1(end,seq1(j).index),xeq1(1,seq1(j).index),'.','Color',[0 0 1],'Markersize',15)
        seq1(j).data
        xeq1(end,seq1(j).index)
    elseif seq1(j).data.lyapunov < 0
        plot (xeq1(end,seq1(j).index),xeq1(1,seq1(j).index),'.','Color',[1 0 0],'Markersize',15)
        seq1(j).data
        xeq1(end,seq1(j).index)
    end
end
xlabel('bifurcation parameter')
ylabel('voltage V')
xlim([0 0.4])
hold off
%
q = 7;
figure;
hold on 
%title('16-dimensional TP06 model')
plotlimitcycle(xlc(:,1:1:end),vlc(:,1:1:end),slc,[size(xlc,1) q 1],[1 0 0],0.3,'none',0.2)
cpl_stability_codim1(xeq,seq,feq,q,1,[0 0 0],50,3)
cpl_stability_codim1(xeq1a,seq1a,feq1a,q,1,[0 0 0],50,3)
xlabel('bifurcation parameter $G_{Ks}$','Interpreter','latex')
ylabel('gating variable $f$','Interpreter','latex')
zlabel('voltage V (mV)','Interpreter','latex')
xlim([0.06 0.13])
ylim([0 1])
zlim([-50 50])
view([135 22])
slc(2).data
slc(2).data.parametervalues(ap)
slc(end-1).data
slc(end-1).data.parametervalues(ap)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('TP06_14D_endo_case_1.mat')
%
figure;
hold on
cpl_stability_1(xeq,feq)
cpl_stability_1(xeq1,feq1)
for j = 2:length(seq)-1
    if seq(j).data.lyapunov == 'Neutral saddle'

    elseif seq(j).data.lyapunov > 0
        plot (xeq(end,seq(j).index),xeq(1,seq(j).index),'.','Color',[0 0 1],'Markersize',15)
        seq(j).data
        xeq(end,seq(j).index)
    elseif seq(j).data.lyapunov < 0
        plot (xeq(end,seq(j).index),xeq(1,seq(j).index),'.','Color',[1 0 0],'Markersize',15)
        seq(j).data
        xeq(end,seq(j).index)
    end
end
for j = 2:length(seq1)-1
    if seq1(j).data.lyapunov == 'Neutral saddle'

    elseif seq1(j).data.lyapunov > 0
        plot (xeq1(end,seq1(j).index),xeq1(1,seq1(j).index),'.','Color',[0 0 1],'Markersize',15)
        seq1(j).data
        xeq1(end,seq1(j).index)
    elseif seq1(j).data.lyapunov < 0
        plot (xeq1(end,seq1(j).index),xeq1(1,seq1(j).index),'.','Color',[1 0 0],'Markersize',15)
        seq1(j).data
        xeq1(end,seq1(j).index)
    end
end
xlabel('bifurcation parameter')
ylabel('voltage V')
xlim([0 0.4])
hold off
%
q = 6;
figure;
hold on 
%title('14-dimensional TP06 model')
% plotlimitcycle(xlc(:,1:1:end),vlc(:,1:1:end),slc,[size(xlc,1) q 1],[1 0 0],0.3,':',0.2)
plotlimitcycle(xlc(:,1:1:end),vlc(:,1:1:end),slc,[size(xlc,1) q 1],[1 0 0],0.3,'none',0.2)
cpl_stability_codim1(xeq,seq,feq,q,1,[0 0 0],50,3)
cpl_stability_codim1(xeq1a,seq1a,feq1a,q,1,[0 0 0],50,3)
xlabel('bifurcation parameter $G_{Ks}$','Interpreter','latex')
ylabel('gating variable $f$','Interpreter','latex')
zlabel('voltage V (mV)','Interpreter','latex')
xlim([0.06 0.13])
ylim([0 1])
zlim([-50 50])
view([135 22])
slc(2).data
slc(2).data.parametervalues(ap)
slc(end-1).data
slc(end-1).data.parametervalues(ap)
