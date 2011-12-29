function [] = lic_detect()

load('../data/np-images-5000.mat');

[uf,sf,ub,sb,alpha,labels,B] = lic_get_emission_pd();
x = data(1).nimg;

P = lic_make_transition_mtx(labels);

m = size(P,1);
n = size(x,2);

psi = ones(m,n);
rho = ones(m,n);

p_Xj_Sj = zeros(m,n);
for j = 1:n
    p_XijF_Sj = repmat(normpdf(x(:,j),uf,sf),1,m);
    p_XijB_Sj = repmat(normpdf(x(:,j),ub,sb),1,m);
    p_Xj_Sj(:,j) = prod(alpha.*p_XijF_Sj+(1-alpha).*p_XijB_Sj,1);
end

rho(:,1) = [p_Xj_Sj(1,1) zeros(1,m-1)]';

for j = 2:n-1
    P_Xj_Sj = lic_make_emissions_mtx(labels,p_Xj_Sj(:,j)');
    P2 = P.*P_Xj_Sj;
    rho(:,j) = P2*rho(:,j-1);
end

P_Xj_Sj = lic_make_emissions_mtx(labels,p_Xj_Sj(:,end)');
P2 = P'.*P_Xj_Sj';

psi(:,end) = P2*ones(m,1);

for j = n-1:-1:1
    P_Xj_Sj = lic_make_emissions_mtx(labels,p_Xj_Sj(:,j)');
    P2 = P.*P_Xj_Sj;
    psi(:,j) = P2'*psi(:,j+1);
end

p_xs = rho.*psi;
sj = max(p_xs,1);

figure;imagesc(rho);
figure;imagesc(psi);