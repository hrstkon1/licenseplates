function [] = lic_make_fig

load('perf.mat');

%%
hist3([p_d p_fa], [8 8]);
xlabel('P_d');
ylabel('P_{fa}');

%%
hist(hammingDist,0:11);
xlabel('edit distance');
ylabel('frequency');
set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 hamming.eps
close;


%[f2] = ecdf(hammingDist);
%figure;
%stairs(-1:numel(f2)-1,f2,'LineWidth',2);
%
%ttt = 3;