function sj_labels = lic_get_glyph_col(sj,labels,B)
global m n;
ix = sum(repmat(sj,size(labels,2),1) > repmat(labels',1,numel(sj)))+1;
ch = B(ix);
labels2 = [0 labels];
col = sj-labels2(ix);

for i = 1:length(ch)
    if ch(i) ~= '#'
        sj_labels{i} = sprintf('%s%d',ch(i),col(i));
    else
        sj_labels{i} = '#';
    end
end