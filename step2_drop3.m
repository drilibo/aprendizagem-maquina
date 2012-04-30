function  S1 = step2_drop3(Dist1,T,L,ns)
     %S1: indices of instances sorted wrt the distance from their miss point:
     D_enemy = [];
for i=1:ns
l = L(i);
lab = find(L~=l);
 D_enemy = [ D_enemy min(Dist1(i,lab))];
end;
[sorted, S1] = sort(-D_enemy);
