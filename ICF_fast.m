function [Sel,reachable,coverage,nr_iter] = ICF_fast(DistM,TRAIN,TRAIN_CL,K,S)
   
nr = length(TRAIN_CL);
pippo = zeros(1,nr);
pippo(S) = 1;

R1 = setdiff(1:nr,S);


progress = 1;
nr_iter = 0;

while progress==1

[reachable,coverage,Ind] = RC_fast(DistM , TRAIN, TRAIN_CL,pippo);
%[reachable,coverage,Ind] = Local_Set_fast(DistM , TRAIN, TRAIN_CL,S);

temp = reachable - coverage;
 R = find(temp < 0);
R1 = union(R,R1);
length(R);
progress = (length(R)>0);
pippo(R1) = 0;
nr_iter = nr_iter+1;
end;

Sel = setdiff(1:nr,R1);
