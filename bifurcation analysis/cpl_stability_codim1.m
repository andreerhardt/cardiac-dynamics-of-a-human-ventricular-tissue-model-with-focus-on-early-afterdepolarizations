function varargout = cplanim(xeq,seq,feq,variable1,variable2,color,Pointsize,Linesize)
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

h = [0,0,0,0,0,0];
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
        elseif seq(j).data.lyapunov < 0
            h(6) = plot3(xeq(end,seq(j).index),xeq(variable1,seq(j).index),xeq(variable2,seq(j).index),'.','Color',[1 0 0],'Markersize',Pointsize);
        end
    end
end

% HL    = {'stable steady states','unstable steady states','fold bifurcation','branch point bifurcation','subcritical Hopf bifurcation','supercritical Hopf bifurcation'};
% l     = find(h==0);
% h(l)  = [];
% HL(l) = [];
% L = legend(h,HL);
% set(L,'Interpreter','latex','Box','off','Fontsize',50,'FontWeight','bold','Location','northeast');
% set(gca,'Fontsize',50,'FontWeight','bold');
grid on
end