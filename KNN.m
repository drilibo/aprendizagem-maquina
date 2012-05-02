function [err, Miss] =  KNN( D,L,T,TL,K)
     err = 0;
nr = length(TL);
Miss = [];
for i=1:nr
example = T(:,i);
l = TL(i);
  [ignore, nr_p] = size(D);
    
  dist = sum((repmat(example,1,nr_p)-D).^2,1);
    [sortedweight, Idx] = sort(dist );
     idx =  Idx(1:K);
     nr_eq = length(find(L(idx)==l));
      if nr_eq < K- nr_eq
     err = err +1;
Miss = [Miss i];
     end;
end;
