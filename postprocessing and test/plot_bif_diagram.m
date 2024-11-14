function varargout = plot_bif_diagram(xeq,seq,feq,xlc,slc,flc,variable1,variable2,color,Pointsize,Linesize,e,EdgeAlpha,LineStyle,FaceAlpha)

global lds cds

dim = size(xeq,1) - 1;

%% calculate first limit cycle branch
for j = 1:size(xlc,2)
    X(:,j)=[xlc(e(1),j)*ones(lds.tps,1)',xlc((0:lds.tps-1)*lds.nphase+e(2),j)',xlc((0:lds.tps-1)*lds.nphase+e(3),j)'];
end
X  = X(:,:);
l  = length(X(:,1));
X1 = X(1:l/3,:);
X2 = X((l/3+1):(2*l/3),:);
X3 = X((2*l/3+1):l,:);

%% calculate the stability of the equlibrium curve 
state = zeros(length(feq),2);
parameter = zeros(length(feq),2);
for k = 1:length(feq)
    if max(real(feq(:,k))) < 0
        state1(k,:) = [xeq(variable1,k),9999];
        state2(k,:) = [xeq(variable2,k),9999];
        parameter(k,:) = [xeq(end,k),9999];
    else
        state1(k,:) = [xeq(variable1,k),6666];
        state2(k,:) = [xeq(variable2,k),6666];
        parameter(k,:) = [xeq(end,k),6666];
    end
end

stable = find(state1(:,2)==9999);
unstable = find(state1(:,2)==6666);

if length(stable) == 0
    a = [];
else
    a = [0;stable(1)];
    for kk = 2:length(stable)-1
        if stable(kk) == stable(kk-1) +1
        else
          a(end+1:end+2) = [stable(kk-1),stable(kk)];
        end 
    end
    a(end+1) = stable(end);
    a(1) = [];
end

if length(unstable) == 0
    b = [];
else
    b = [0;unstable(1)];
    for kk = 2:length(unstable)-1
        if unstable(kk) == unstable(kk-1) +1
        else
          b(end+1:end+2) = [unstable(kk-1),unstable(kk)];
        end  
    end
    b(end+1) = unstable(end);
    b(1) = [];
end

%% plot equilibrium curve, Andronov-Hopf bifurcation, fold bifurcation, branch point bifurcation if existent 
h = [0,0,0,0,0,0,0,0,0];
hold on
if isempty(a)
elseif length(a)  < 3
    h(1) = plot3(parameter(stable,1),state1(stable,1),state2(stable,1),'-','Color',color,'Linewidth',Linesize);
else
    for i = 1:2:length(a)
        h(1) = plot3(parameter(a(i):a(i+1),1),state1(a(i):a(i+1),1),state2(a(i):a(i+1),1),'-','Color',color,'Linewidth',Linesize);
    end
end

if isempty(b)
elseif length(b) < 3
    h(2) = plot3(parameter(unstable,1),state1(unstable,1),state2(unstable,1),'--','Color',color,'Linewidth',Linesize);
else
    for i = 1:2:length(b)
        h(2) = plot3(parameter(b(i):b(i+1),1),state1(b(i):b(i+1),1),state2(b(i):b(i+1),1),'--','Color',color,'Linewidth',Linesize);
    end
end

if length(seq) >2
    hold on
    for j = 2:length(seq)-1
        if seq(j).label == 'LP'
            h(3) = plot3(xeq(end,seq(j).index),xeq(variable1,seq(j).index),xeq(variable2,seq(j).index),'.','Color',[0 0 0],'Markersize',Pointsize);
        elseif seq(j).label == 'BP'
            h(4) = plot3(xeq(end,seq(j).index),xeq(variable1,seq(j).index),xeq(variable2,seq(j).index),'.','Color',[1 0 1],'Markersize',Pointsize);
        elseif seq(j).data.lyapunov == 'Neutral saddle'
    
        elseif seq(j).data.lyapunov > 0
            h(5) = plot3(xeq(end,seq(j).index),xeq(variable1,seq(j).index),xeq(variable2,seq(j).index),'.','Color',[0 0 1],'Markersize',Pointsize);
            if abs(xlc(end,1)-xeq(end,seq(j).index)) < 1e-6
                %% plot the first limit cycle branch 
                h(7)  = surface(X1,X2,X3);
                set(h(7),'Facecolor',[0 0 1],'LineStyle',LineStyle,'FaceAlpha',FaceAlpha,'EdgeAlpha',EdgeAlpha);
                for k = 2:length(slc)-1
                    if slc(k).label == 'NS '
                        h(8) = plot3(xlc(end,slc(k).index)*xlc(variable1:dim:end-2,slc(k).index)./xlc(variable1:dim:end-2,slc(k).index),xlc(variable1:dim:end-2,slc(k).index),xlc(variable2:dim:end-2,slc(k).index),'-','Color',[0 0 1],'Linewidth',3);
                    elseif slc(k).label == 'PD '
                        h(9) = plot3(xlc(end,slc(k).index)*xlc(variable1:dim:end-2,slc(k).index)./xlc(variable1:dim:end-2,slc(k).index),xlc(variable1:dim:end-2,slc(k).index),xlc(variable2:dim:end-2,slc(k).index),'-','Color',[0 1 1],'Linewidth',3);
                    end
                end
            end
        elseif seq(j).data.lyapunov < 0
            h(6) = plot3(xeq(end,seq(j).index),xeq(variable1,seq(j).index),xeq(variable2,seq(j).index),'.','Color',[1 0 0],'Markersize',Pointsize);
            if abs(xlc(end,1)-xeq(end,seq(j).index)) < 1e-6
                %% plot the first limit cycle branch 
                h(7)  = surface(X1,X2,X3);
                set(h(7),'Facecolor',[1 0 0],'LineStyle',LineStyle,'FaceAlpha',FaceAlpha,'EdgeAlpha',EdgeAlpha);
                for k = 2:length(slc)-1
                    if slc(k).label == 'NS '
                        h(8) = plot3(xlc(end,slc(k).index)*xlc(variable1:dim:end-2,slc(k).index)./xlc(variable1:dim:end-2,slc(k).index),xlc(variable1:dim:end-2,slc(k).index),xlc(variable2:dim:end-2,slc(k).index),'-','Color',[0 0 1],'Linewidth',3);
                    elseif slc(k).label == 'PD '
                        h(9) = plot3(xlc(end,slc(k).index)*xlc(variable1:dim:end-2,slc(k).index)./xlc(variable1:dim:end-2,slc(k).index),xlc(variable1:dim:end-2,slc(k).index),xlc(variable2:dim:end-2,slc(k).index),'-','Color',[0 1 1],'Linewidth',3);
                    end
                end
            end
        end
    end
end

HL    = {'stable steady states','unstable steady states','fold bifurcation','branch point bifurcation','subcritical Hopf bifurcation','supercritical Hopf bifurcation','first limit cycle branch','torus bifurcation','period doubling bifurcation'};
l     = find(h==0);
h(l)  = [];
HL(l) = [];
L = legend(h,HL);
set(L,'Interpreter','latex','Box','off','Fontsize',30,'FontWeight','bold','Location','northeast');
set(gca,'Fontsize',50,'FontWeight','bold');
grid on
end