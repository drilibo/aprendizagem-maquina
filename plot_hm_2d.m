function  plot_hm_2d(G,TRAIN,TRAIN_CL)
     [nf, nd] = size(TRAIN);
figure;
hold on;
for j=1:nd
for k=1:nd
if G(j,k) >0
plot(TRAIN(1,[j k]),TRAIN(2,[j k]),'k-','LineWidth',2);
x = TRAIN(:,j);
y = TRAIN(:,k);
CreateArrow([x(1) y(1)], [x(2) y(2)]);
end;
end;
end;
hold on;
for j=1:nd
if TRAIN_CL(j)==1
plot(TRAIN(1,j),TRAIN(2,j),'Marker', '*','MarkerSize',8,'Color','b','LineStyle','none');
plot(TRAIN(1,j),TRAIN(2,j),'Marker', 'o','MarkerSize',9,'Color','b','LineStyle','none');
else
plot(TRAIN(1,j),TRAIN(2,j),'Marker', '+','MarkerSize',8,'Color','r','LineStyle','none');
plot(TRAIN(1,j),TRAIN(2,j),'Marker', 's','MarkerSize',9,'Color','r','LineStyle','none');
end;
%text(TRAIN(1, j)+.05, TRAIN(2,j)+.05, int2str(degr(j)));
end;
plot([-1,1],[0,0],'k-');
plot([0,0],[1,-1],'k-');
%hold off;
