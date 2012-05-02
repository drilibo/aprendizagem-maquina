function [sel, R, V] = HMN_remedit(SO,p1,p2,nc,TRAIN_CL,I)

     [nd, m] = size(SO);
     eps = .1;
    
R = [];

for i=1:nd
l = TRAIN_CL(i);
idxl = find(TRAIN_CL==l);
ni = length(idxl);

V(i,2)= p1(i)*SO(i,2);
V(i,1)= p2(i)*SO(i,1);

if  sum(SO(i,:))==0 | ( (SO(i,1)<ni/4) &  (p1(i)*SO(i,2) +eps >= p2(i)*SO(i,1))&  (nc <=3 |length(unique(TRAIN_CL(I{i,2}))) >= .5*nc) )
 R = [R i];

 end;


 end;

 sel = setdiff(1:nd,R);

