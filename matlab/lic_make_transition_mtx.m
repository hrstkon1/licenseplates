function P = lic_make_transition_mtx(labels)
m = numel(labels);
n = labels(end);

ii = [];
jj = [];
s = [];

% whitespace transitions
jj = cat(2,jj,[1 labels(2:end)-1]);
ii = cat(2,ii,ones(size(jj)));
s = cat(2,s,ii/sum(ii));

% first column transitions
k = m-1;
jj = cat(2,jj,ones(1,k));
jj = cat(2,jj,labels(1:end-1)+1);
ii = cat(2,ii,[labels(1:end-1)+1 labels(1:end-1)+1]);
s = cat(2,s,[0.9*ones(1,k) 0.1*ones(1,k)]);

% other column transitions
for i = 2:m
    k = labels(i)-labels(i-1)-1;
    ii = cat(2,ii,...
             [labels(i-1)+2:labels(i) labels(i-1)+2:labels(i)]);
    jj = cat(2,jj,...
             [labels(i-1)+1:labels(i)-1 labels(i-1)+2:labels(i)]);
    s = cat(2,s,[0.9*ones(1,k) 0.1*ones(1,k)]);
end

P = sparse(ii,jj,s,n,n);