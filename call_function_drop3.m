function  [T, L, S, Ed, Missdrop] = call_function_drop3(TRAIN, TEST, TRAIN_CL,TEST_CL, DistM)
     %Nsel indices of points selected by first step
     %Eddrop indices of points selected ***in S***

nr_neighbors = 1;

%first step of DROP3: remove misclassified instances from training set
 S =  ENN(DistM, TRAIN_CL,nr_neighbors);

 T = TRAIN(:,S);
 L = TRAIN_CL(S);
Dista = DistM(S,S);

clear DistM;

Ranked = [];
ns = length(S);
 for i=1:ns
[sorted, idx_sorted] = sort(Dista(i,:));
Ranked = [Ranked; idx_sorted];
end;


%%Ranked(i,:) indices of instances sorted by their distance from instance i: note Ranked(i,1)=i!!!!!

%%%compute Ass{i} which contains indices of associates of i: s is associate of i if i is one of the 1 nearest neighbor of s

for i=1:ns
temp = find(Ranked(:,2)==i);
Ass{i} = temp;
NN_pointer(i) = 2;
end;

     
%second step of DROP3: sort instances in T by their distance to their miss, those with bigger distance come first (are preferred for removal)

 S1 = step2_drop3(Dista,T,L,ns);

%third step of  DROP3:

Ed = 1:ns;

for i=1:ns
%select in order wrt farther distance from enemy
id = S1(i);

%temp = associates of id
temp = Ass{id};
na = length(temp);


%%with = # associates correctly classified using
with = length(find(L(temp)==L(id)));

without = 0;
no_drop = 0;
%check if associates accuracy becomes equal or better without i

for k=1:na

if no_drop == 0

 t0 = find(Ranked(temp(k),:) == id);
 j=t0+1;
 while isempty(intersect(Ranked(temp(k),j:ns), Ed)) & j< ns
  j = j+1;
 end;
 if j <=ns
    without = without + L( Ranked(temp(k),j) )==L(temp(k));
    NN_pointer(temp(k)) = j;
      else
	no_drop = 1;
 end;
		 
end; %if no_drop 

end; %for k


if (without -with) >= 0 & (no_drop==0)
   %%remove id
   Ed =setdiff(Ed,id);
   %for each associate temp(j) of i, add temp(j)  to the list of asociates of the new nearest neighbor of temp(j)
   for j=1:na
     new_nn =  Ranked(temp(k), NN_pointer(temp(k)));
     Ass{new_nn } = [Ass{new_nn}; temp(j)];
    end;
end;


end; %for i=1:ns



[neig1, erp1, ern1, Missdrop] = NN1cl(T(:,Ed),L(Ed),TEST,TEST_CL );

