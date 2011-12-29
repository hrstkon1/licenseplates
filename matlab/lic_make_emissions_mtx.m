function PX_SJ = lic_make_emissions_mtx(labels,px_sj)
m = numel(labels);
n = labels(end);

ii = [];
jj = [];
s = [];

% whitespace transitions
jj = cat(2,jj,[1 labels(2:end)-1]);
ii = cat(2,ii,ones(size(jj)));
s = px_sj(ii);

% first column transitions
k = m-1;
jj = cat(2,jj,ones(1,k));
jj = cat(2,jj,labels(1:end-1)+1);
t = [labels(1:end-1)+1 labels(1:end-1)+1];
ii = cat(2,ii,t);
s = cat(2,s,px_sj(t));

% other column transitions
for i = 2:m
    k = labels(i)-labels(i-1)-1;
    t = [labels(i-1)+2:labels(i) labels(i-1)+2:labels(i)];
    ii = cat(2,ii,t);
    jj = cat(2,jj,...
             [labels(i-1)+1:labels(i)-1 labels(i-1)+2:labels(i)]);
    s = cat(2,s,px_sj(t));
end

PX_SJ = sparse(ii,jj,s,n,n);