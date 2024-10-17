function res = plotlimitcycle(x,v,s,e,color,EdgeAlpha,LineStyle,FaceAlpha)

global lds cds

for j = 1:size(x,2)
    if isempty(find([s.index]==j))
        X(:,j)=[x(e(1),j)*ones(lds.tps,1)',x((0:lds.tps-1)*lds.nphase+e(2),j)',x((0:lds.tps-1)*lds.nphase+e(3),j)'];
    else
        X(:,j)=[x(e(1),j)*ones(lds.tps,1)',x((0:lds.tps-1)*lds.nphase+e(2),j)',x((0:lds.tps-1)*lds.nphase+e(3),j)'];
    end
end

X  = X(:,:);
l  = length(X(:,1));
X1 = X(1:l/3,:);
X2 = X((l/3+1):(2*l/3),:);
X3 = X((2*l/3+1):l,:);
%% Shilnikov-Plot
h  = surface(X1,X2,X3);
%% surface properties
set(h,'Facecolor',color,'LineStyle',LineStyle,'FaceAlpha',FaceAlpha,'EdgeAlpha',EdgeAlpha)
end