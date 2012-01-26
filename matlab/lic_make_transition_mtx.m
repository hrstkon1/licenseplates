function P = lic_make_transition_mtx(labels)
m = numel(labels);
n = labels(end);

p_same = 0.1;
p_next = 1.0-p_same;

% from whitespace 
ii = [1 labels(1:end-1)+1];
jj = ones(size(ii));
s = [0.3 ones(1,numel(ii)-1)*0.7/(numel(ii)-1)];

% from glyph columns
for i = 2:m
    k = labels(i)-labels(i-1);
    ii = cat(2,ii,...
             [labels(i-1)+1:labels(i) labels(i-1)+2:labels(i)]);
    jj = cat(2,jj,...
             [labels(i-1)+1:labels(i) labels(i-1)+1:labels(i)-1]);
    s = cat(2,s,[p_same*ones(1,k) p_next*ones(1,k-1)]);
end

% add special case for terminal glyph columns
k = m-1;
ii = cat(2,ii,ones(1,k));
jj = cat(2,jj,labels(2:end));
s = cat(2,s,p_next*ones(1,k));

P = sparse(ii,jj,s,n,n);