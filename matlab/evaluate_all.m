load('results.mat')
load('../data/np-images-5000.mat');
%%
[p_d p_fa] = lic_evaluate(data, results);
%%
lDist = zeros(numel(results), 1);
allChars = 0;

for i = 1:numel(data)
   lDist(i) = min(strdist(data(i).text.str, get_label_string(results{i})), numel(data(i).text.str));
   allChars = allChars + numel(data(i).text.str);
end

%%
figure(1)
x = min(lDist):max(lDist);
h = hist(lDist,x);
h = h/sum(h(:));
hh = cumsum(h);
bar(x,hh);
xlabel('Levenshtein distance')

accuracy = 1-sum(lDist)/allChars;

fprintf('p_d = %f\np_fa = %f\naccuracy = %f\n', p_d, p_fa, accuracy);