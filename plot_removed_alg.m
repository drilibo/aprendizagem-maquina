 function h = plot_removed_alg(E, L, resto, restoL)

h = figure;
hold on;
plot([-1,1],[0,0],'k-');
plot([0,0],[1,-1],'k-');
labels = unique(L);
Ep = E(:,find(L==labels(1)));
En = E(:,find(L==labels(2)));	 
plot(Ep(1,:),Ep(2,:),'bo','MarkerSize',8);
plot(En(1,:), En(2,:),'rs','MarkerSize',8);

Erp  = resto(:,find(restoL==labels(1)));
Ern = resto(:,find(restoL==labels(2)));
plot(Erp(1,:),Erp(2,:),'Marker', 'o','MarkerSize',10,'Color','k',...
'MarkerFaceColor','k', 'LineWidth',3, 'LineStyle','none');
plot(Ern(1,:),Ern(2,:),'Marker', 's','MarkerSize',10,'Color','r',...
'MarkerFaceColor','k', 'LineWidth',3, 'LineStyle','none');

