function sj_labels = lic_detect(lic_num,debug_output)
global m n;

if nargin < 1
    lic_num = 1;
end

if nargin < 2
    debug_output = 0;
end

load('../data/np-images-5000.mat');

[uf,sf,ub,sb,alpha,labels,B] = lic_get_emission_pd();

x = cropInputImage(data(lic_num).nimg);
xs = sort(unique(x));

P = lic_make_transition_mtx(labels);

m = size(P,1);
n = size(x,2);

psi = zeros(m,n);
rho = zeros(m,n);

p_Xj_Sj = zeros(m,n);
P_Xj_Sj = cell(1,n);

for j = 1:n
    p_XijF = repmat(normpdf(x(:,j),uf,sf),1,m);
    p_XijB = repmat(normpdf(x(:,j),ub,sb),1,m);
    p_Xj_Sj(:,j) = prod(alpha.*p_XijF+(1-alpha).*p_XijB,1);
    P_Xj_Sj{j} = lic_make_emissions_mtx(labels,p_Xj_Sj(:,j));
end

rho(:,1) = [zeros(1,m-2) p_Xj_Sj(end,1) 0]';
rho(:,1) = rho(:,1)/sum(rho(:,1));
for j = 2:n
    P2 = P_Xj_Sj{j}*P;
    rho(:,j) = P2*rho(:,j-1);
    rho(:,j) = rho(:,j)/sum(rho(:,j));
end

P2 = P_Xj_Sj{n}*P;

psi(:,end) = P2'*ones(m,1);
psi(:,end) = psi(:,end)/sum(psi(:,end));
for j = n-1:-1:1
    P2 = P_Xj_Sj{j}*P;
    psi(:,j) = P2'*psi(:,j+1);
    psi(:,j) = psi(:,j)/sum(psi(:,j));
end

p_xs = rho.*psi;

sj = lic_calc_best_path(p_xs,P);
%[cc,sj] = max(p_xs,[],1);

sj_labels = lic_get_glyph_col(sj,labels,B);

[lic_str,cols] = get_label_string(sj_labels);

lic_display_result(x,lic_str,cols);
%lic_display_pds(uf,sf,ub,sb);
%
if debug_output
    figure;imagesc(rho);colormap(gray);
    figure;imagesc(p_xs);colormap gray;
end

