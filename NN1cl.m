function [neig, erp, ern, Mis] = NN1cl(Data,Labels,TEST,TEST_CL)

[feat, nr] = size(TEST);
erp = 0;
ern = 0;
 Mis = [ ];
 neig = [];


for i=1:nr
    x = TEST(:,i);
    [hit,idx] = nearest_n(x, Data ,1);
    neig = [neig idx];
    if TEST_CL(i)~=Labels(idx)
        erp = erp + abs(TEST_CL(i) +1)/2;
        ern = ern + abs(TEST_CL(i) -1)/2;    
        Mis = [Mis i];
    end;
end;
