function [nn_ex,idx] = nearest_n(example, tempSample,K)

[ignore, nr_p] = size( tempSample);

dist = sum((repmat(example,1,nr_p)-tempSample).^2,1);
[sortedweight, Idx] = sort(dist );
nn_ex =  tempSample(:, Idx(1:K));
idx =  Idx(1:K);

