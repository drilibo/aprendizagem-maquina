function [ Reach, Cover,Ind] = RC_fast(Dista, TRAIN,TRAIN_CL,pippo)
    


T = TRAIN;
L = TRAIN_CL;

nr = length(TRAIN_CL);
Ind = zeros(nr,nr);

for i=1:nr
if (pippo(i)> 0)
     
l = L(i);
Is = intersect(find(L==l), find(pippo>0));
Io = intersect(find(L~=l), find(pippo>0));
a1 = Dista(i, Is);
a2 = Dista(i, Io);

if ~isempty(a2)
thre = min(a2);
id_reachable = find(a1 < thre);
Ind(i, Is(id_reachable)) = 1;

end;
end;
end;

for i=1:nr
Reach(i) = sum(Ind(:,i));
Cover(i) = sum(Ind(i,:));
end;

