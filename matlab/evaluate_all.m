load('results.mat')
load('../data/np-images-5000.mat');
%%
p_d = zeros(numel(results), 1);
p_fa = zeros(numel(results), 1);
hammingDist = zeros(numel(results), 1);

for i = 1:numel(data)
   [a b] = lic_evaluate(data(i), results{i});
   p_d(i) = a;
   p_fa(i) = b;
   hammingDist(i) = strdist(data(i).text.str, get_label_string(results{i}));
end

%%
figure(1)
hist3([p_d p_fa], [8 8])
xlabel('p_d');
ylabel('p_{fa}');

%%
figure(2)
hist(hammingDist)

