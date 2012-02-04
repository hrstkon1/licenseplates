function P = lic_make_transition_mtx(labels)
m = numel(labels);
n = labels(end);

p_same = 0.0;
p_next = 1.0-p_same;

p_ws = 0.25;
p_nws = 1.0-p_ws;

% from whitespace middle
ii = [1 labels(1:end-3)+1];
jj = ones(size(ii));
s = [p_ws ones(1,numel(ii)-1)*p_nws/(numel(ii)-1)];

% from whitespace left
ii = cat(2,ii,[labels(m-2)+1 labels(1:m-3)+1]);
jj = cat(2,jj,[(labels(m-2)+1)*ones(1,m-2)]);
s = cat(2,s,[p_ws ones(1,m-3)*p_nws/(m-3)]);

% from whitespace right
ii = cat(2,ii,labels(m-1)+1);
jj = cat(2,jj,labels(m-1)+1);
s = cat(2,s,1);

% from glyph columns
for i = 2:m-2
    k = labels(i)-labels(i-1);
    ii = cat(2,ii,...
             [labels(i-1)+1:labels(i) labels(i-1)+2:labels(i)]);
    jj = cat(2,jj,...
             [labels(i-1)+1:labels(i) labels(i-1)+1:labels(i)-1]);
    s = cat(2,s,[p_same*ones(1,k) p_next*ones(1,k-1)]);
end

% from terminal glyph columns
k = m-3;
ii = cat(2,ii,[ones(1,k) n*ones(1,k)]);
jj = cat(2,jj,[labels(2:end-2) labels(2:end-2)]);
s = cat(2,s,[(p_next/2)*ones(1,2*k)]);

P = sparse(ii,jj,s,n,n);

aa = 3;
