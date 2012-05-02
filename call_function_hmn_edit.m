function  [SO, sel, seledit, Miss, Miss1, Missedit] =call_function_hmn_edit(TRAIN, TEST, TRAIN_CL,TEST_CL, DistM)

     %selected by Wilson's editing
S =  Repeated_ENN_fast(DistM, TRAIN_CL,1,0);
     
artificial =0;
do_plot = 0;
gen_ran = 0;
no_cons =0;
nd = length(TRAIN_CL);

%%%%%% G adjacency matrix describes edges of NHMN built from the training set
[G,SO,I] = HMN_construct_fast(DistM,TRAIN_CL);


if ( artificial|gen_ran| no_cons)& nd < 100
     %plot HMN graph 
%S = 1:nd;
plot_hm_2d(G,TRAIN,TRAIN_CL);
hold on;
for j=1:nd
text(TRAIN(1, j)-.02, TRAIN(2,j)+.07, int2str(SO(j,1)));
text(TRAIN(1, j), TRAIN(2,j)+.05, ',');
text(TRAIN(1, j)+.02,TRAIN(2,j)+.07, int2str(SO(j,2)));
end;
end;






if do_plot
%plot training set
figure;
hold on;
plot([-1,1],[0,0],'k-');
plot([0,0],[1,-1],'k-');
EdL =  TRAIN_CL;
E = TRAIN;
Edp = E(:,find(EdL>0));
Edn = E(:,find(EdL<0));

plot(Edp(1,:),Edp(2,:),'Marker', '*','MarkerSize',8,'Color','b','LineStyle','none');
plot(Edp(1,:),Edp(2,:),'Marker', 'o','MarkerSize',10,'Color','b','LineStyle','none');
plot(Edn(1,:), Edn(2,:),'Marker', '+','MarkerSize',8,'Color','r','LineStyle','none');
plot(Edn(1,:),Edn(2,:),'Marker', 's','MarkerSize',10,'Color','r','LineStyle','none');


degr = sum(SO(:,:)');
[sorted, idx ] = sort(degr,'descend');
gradi = unique(sorted);
for j=1:length(gradi)
id_tmp{j} = find(sorted==gradi(j));
nr(j) = size(id_tmp{j},2);
end;
%plot degrees
figure;
plot(1:nd,sorted,'ko','MarkerSize',8);


end; %if do_plot



degr = SO(:,1)+SO(:,2);
sel = find(degr>0);
rimossi_wil = setdiff(1:nd,S);
%sel = setdiff(find(degr>0), rimossi_wil);
Ed1 = TRAIN(:,sel);
[neig, erp, ern, Miss] = NN1cl(Ed1,TRAIN_CL(sel),TEST,TEST_CL);



for p=1:nd
l=TRAIN_CL(p);
p1(p) = length(find(TRAIN_CL==l))/nd;
p2(p) = length(find(TRAIN_CL~=l))/nd;
end;
nc = length(unique(TRAIN_CL));
[sedit, rimossi, V] = HMN_remedit(SO,p1,p2,nc,TRAIN_CL,I);
t = TRAIN_CL(sedit);
cl = unique(TRAIN_CL(sedit));
td = find(degr>0);

aggiu = [  ];
for m=1:length(cl)
hu = find(t==cl(m));   
n = length(hu);

%%RULE R2
%if less than 4 elements selected for some class then add elements as below
if  n <= 3
a2 = intersect(find(TRAIN_CL==cl(m)), find(degr==1));
a1 = intersect(find(TRAIN_CL==cl(m)), find(SO(:,1)>0));
pa = union(a1,a2);
if isempty(pa)
pa = find(TRAIN_CL==cl(m));
end;
aggiu =[aggiu pa ];
end;
end;

seledit = setdiff(union(sedit,aggiu),rimossi_wil) ;
seledit = unique(union(sedit,aggiu));


Ededit = TRAIN(:,seledit);
[neig, erp, ern, Missedit] = NN1cl(Ededit,TRAIN_CL(seledit),TEST,TEST_CL);
[neig1, erp1, ern1, Miss1] = NN1cl(TRAIN,TRAIN_CL,TEST,TEST_CL);

Miss1;
Missedit ;



if  gen_ran & 0
figure;
EdL =  TRAIN_CL(seledit);
E= Ededit;
Edp = E(:,find(EdL>0));
Edn = E(:,find(EdL<0));
resto = setdiff(1:nd,seledit);
restoL = TRAIN_CL(resto);
restop = resto(:,find(restoL>0));
reston = resto(:,find(restoL<0));
hold on;
plot(TRAIN(1,restop),TRAIN(2,restop),'Marker', 'o','MarkerSize',10,'Color','k',...
'LineWidth',3, 'LineStyle','none');
plot(TRAIN(1,reston),TRAIN(2,reston),'Marker', 's','MarkerSize',10,'Color','r',...
'LineWidth',3, 'LineStyle','none');
plot(Edp(1,:),Edp(2,:),'bo','MarkerSize',8);
plot(Edn(1,:), Edn(2,:),'rs','MarkerSize',8);
plot([-1,1],[0,0],'k-');
plot([0,0],[1,-1],'k-');

end;





if  artificial
figure;
EdL =  TRAIN_CL(seledit);
E= Ededit;
Edp = E(:,find(EdL>0));
Edn = E(:,find(EdL<0));
hold on;
plot(Edp(1,:),Edp(2,:),'Marker', 'o','MarkerSize',9,'Color','k',...
'MarkerFaceColor','k','LineStyle','none');
plot(Edn(1,:), Edn(2,:),'Marker', 's','MarkerSize',10,'Color','r',...
'MarkerFaceColor','k', 'LineStyle','none');
resto = setdiff(1:nd,seledit);
restoL = TRAIN_CL(resto);
restop = resto(:,find(restoL>0));
reston = resto(:,find(restoL<0));
plot(TRAIN(1,restop),TRAIN(2,restop),'bo','MarkerSize',8);
plot(TRAIN(1,reston),TRAIN(2,reston),'rs','MarkerSize',8);
plot([-1,1],[0,0],'k-');
plot([0,0],[1,-1],'k-');

end;

