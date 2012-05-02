function  [S, seledit, Miss] =call_function_hmn1(TRAIN, TEST, TRAIN_CL,TEST_CL, DistM)

nr_neighbors = 1;
%S =  ENN(DistM, TRAIN_CL,nr_neighbors);
% S =  Repeated_ENN_fast(DistM, TRAIN_CL,1,1);
S = 1:length(TRAIN_CL);
 T = TRAIN(:,S);
 L = TRAIN_CL(S);
Dista = DistM(S,S);

[G,SO,I] = HMN_construct_fast(Dista,L);


degr = SO(:,1)+SO(:,2);

sel = find(degr>0);

Ed1 = T(:,sel);
[neig, erp, ern, Miss] = NN1cl(Ed1,L(sel),TEST,TEST_CL);


ns = length(L);
for p=1:ns
l=L(p);
p1(p) = length(find(L==l))/ns;
p2(p) = length(find(L~=l))/ns;
end;
nc = length(unique(L));
[sedit, rimossi, V] = HMN_remedit(SO,p1,p2,nc,L,I);
t = L(sedit);
cl = unique(L(sedit));
td = find(degr>0);

aggiu = [  ];
for m=1:length(cl)
hu = find(t==cl(m));   
n = length(hu);

%%RULE R2
%if less than 4 elements selected for some class then add elements as below
if  n <= 3
a2 = intersect(find(L==cl(m)), find(degr==1));
a1 = intersect(find(L==cl(m)), find(SO(:,1)>0));
pa = union(a1,a2);
if isempty(pa)
pa = find(L==cl(m));
end;
aggiu =[aggiu; pa ];
end;
end;


%seledit = setdiff(union(sedit,aggiu),rimossi_wil) ;
seledit = unique(union(sedit,aggiu));


Ed = T(:,seledit);
[neig, erp, ern, Miss] = NN1cl(Ed,L(seledit),TEST,TEST_CL);

     
