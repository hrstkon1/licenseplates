function [uf,sf,ub,sb,alpha,labels,B] = lic_get_emission_pd()
[B,ix] = sort('[]#258BEILPTX0369CFJMRUY147ADHKNSVZ');

alpha = [];
labels = [];

for b = B
    data = textread(sprintf('../trained_data1/%s.csv',b), ...
                    '', 'delimiter', ',')';
    alpha = cat(2,alpha,data);
    labels = [labels size(alpha,2)];
end

data = textread('../trained_data1/pfb.csv', ...
                '', 'delimiter', ',')';
uf = data(1,1);
sf = data(1,2);
ub = data(2,1);
sb = data(2,2);