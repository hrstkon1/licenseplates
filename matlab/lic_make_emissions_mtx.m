function PX_SJ = lic_make_emissions_mtx(labels,px_sj)
m = numel(labels);
n = labels(end);

p_same = 0.1;
p_next = 1.0-p_same;

ii = [];
jj = [];
s = [];

% from whitespace 
ii = cat(2,ii,[1 labels(1:end-1)+1]);
jj = cat(2,jj,ones(size(ii)));
s = px_sj(ii);

% from glyph columns
for i = 2:m
    k = labels(i)-labels(i-1);
    ii_tmp = [labels(i-1)+1:labels(i) labels(i-1)+2:labels(i)];
    ii = cat(2,ii,ii_tmp);
    jj = cat(2,jj,...
             [labels(i-1)+1:labels(i) labels(i-1)+1:labels(i)-1]);
    s = cat(2,s,px_sj(ii_tmp));
end

% add special case for terminal glyph columns
k = m-1;
ii_tmp = ones(1,k);
ii = cat(2,ii,ii_tmp);
jj = cat(2,jj,labels(2:end));
s = cat(2,s,px_sj(ii_tmp));

PX_SJ = sparse(ii,jj,s,n,n);