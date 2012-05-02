function [G,S,I] = HMN_construct_fast(DistM,TRAIN_CL);
%%%%G(i,j)=1/nr if j is a nearest hit/miss of i, with nr number elements of hit/miss classes
%%%%S(i,1) nr neighbours of same class, S(i,2) nr neighbours of other classes, 
   %%%%I{i,1} index of  neighbours of same class, I{i,2} index of  neighbours of other classes
classes = sort(unique(TRAIN_CL),'descend');
nrc = length(classes);


nd = length(TRAIN_CL);

%initialize G
G = zeros(nd,nd);

%%for each class

for k=1:nrc
idxk = find(TRAIN_CL==classes(k));
nre = length(idxk);

for  i=1:nre


idxr = setdiff(idxk, idxk(i));
if ~isempty(idxr)
[mind, id] = min(DistM(idxk(i),idxr));
G(idxr(id),idxk(i)) = 1;
end;

for j=1:k-1
idxr = find(TRAIN_CL==classes(j));
if ~isempty(idxr)
[minmissss,id] = min(DistM(idxk(i), idxr));
G(idxr(id),idxk(i)) = 1;
end;
end;

for j=k+1:nrc
idxr = find(TRAIN_CL==classes(j));
if ~isempty(idxr)
[minmissss,id] = min(DistM(idxk(i), idxr));
G(idxr(id),idxk(i)) = 1;
end;
end;

end;

end;

for k=1:nrc
idxk = find(TRAIN_CL==classes(k));
nre = length(idxk);
%num_el = length(find(TRAIN_CL==classes(k)));
for  i=1:nre

S(idxk(i),1) = sum(G(idxk(i),idxk));
altri = setdiff(idxk,idxk(i));
idxr = find(G(idxk(i),altri)>0);
I{idxk(i), 1} = altri(idxr);
altri = setdiff(1:nd,idxk);
idxr = find(G(idxk(i),altri)>0);
I{idxk(i),2} = altri(idxr);
S(idxk(i),2) = sum(G(idxk(i),altri(idxr)));
end;
end;




