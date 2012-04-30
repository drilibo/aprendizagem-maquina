function S = Repeated_ENN_fast(DistM, TRAIN_CL,K,rep)

    nr =  length(TRAIN_CL);
    
    
    I = 1:nr;
   R = ones(1,nr);
    
tmp = 1;


if rep & K==1

    while tmp
   tmp = 0;  
 for i=1:nr  

l = TRAIN_CL(i);
Ir = setdiff(I,i);

Lr = TRAIN_CL(Ir);
[sorted, idx_sorted] = sort(DistM(i,Ir));
idx =idx_sorted(1:K);
nr_same = length(find(Lr(idx)==l));
if nr_same == 0 & R(i)
R(i) = 0;
tmp = tmp+1;
end;
end;
end;

else

 for i=1:nr  

l = TRAIN_CL(i);
Ir = setdiff(I,i);
Lr = TRAIN_CL(Ir);
[sorted, idx_sorted] = sort(DistM(i,Ir));
idx =idx_sorted(1:K);
nr_same = find(Lr(idx)==l);
if length(nr_same) < length(idx)/2 & R(i)
R(i) = 0;
end;
end;

end;


S = find(R==1);
