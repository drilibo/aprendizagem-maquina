function S = ENN(DistM, TRAIN_CL,K)
%%removes instances of training set misclassified by kNN rule
    nr =  length(TRAIN_CL);
    
    
    I = 1:nr;
   R = ones(1,nr);
tmp = 1;

 for i=1:nr  

l = TRAIN_CL(i);
Ir = setdiff(I,i);
Lr = TRAIN_CL(Ir);
[sorted, idx_sorted] = sort(DistM(i,Ir));
idx =idx_sorted(1:K);
nr_same = find(Lr(idx)==l);
if length(nr_same) < length(idx)-length(nr_same) & R(i)
R(i) = 0;
end;
end;


S = find(R==1);

