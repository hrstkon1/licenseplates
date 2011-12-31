function sj_labels = lic_detect(lic_num)

if nargin < 1
    lic_num = 1;
end

load('../data/np-images-5000.mat');

[uf,sf,ub,sb,alpha,labels,B] = lic_get_emission_pd();

figure;
ix = uf-3*sf:1e-3:uf+3*sf; %covers more than 99% of the curve
iy = pdf('normal',ix,uf,sf);
figure;plot(ix,iy);

ix = ub-3*sb:1e-3:ub+3*sb; %covers more than 99% of the curve
iy = pdf('normal',ix,ub,sb);
hold on;plot(ix,iy);hold off;

x = cropInputImage(data(lic_num).nimg);
xs = sort(unique(x));
dx = median(xs(2:end)-xs(1:end-1))/2;

P = lic_make_transition_mtx(labels);

m = size(P,1);
n = size(x,2);

psi = zeros(m,n);
rho = zeros(m,n);

p_Xj_Sj = zeros(m,n);

for j = 1:n
    p_XijF = repmat(normcdf(x(:,j)+dx,uf,sf)-normcdf(x(:,j)-dx,uf,sf),1,m);
    p_XijB = repmat(normcdf(x(:,j)+dx,ub,sb)-normcdf(x(:,j)-dx,ub,sb),1,m);
    p_Xj_Sj(:,j) = prod(alpha.*p_XijF+(1-alpha).*p_XijB,1);
end

rho(:,1) = [p_Xj_Sj(1,1) zeros(1,m-1)]';
rho(:,1) = rho(:,1)/sum(rho(:,1));
for j = 2:n
    P_Xj_Sj = lic_make_emissions_mtx(labels,p_Xj_Sj(:,j)');
    P2 = P.*P_Xj_Sj;
    rho(:,j) = P2*rho(:,j-1);
    rho(:,j) = rho(:,j)/sum(rho(:,j));
end

figure;imagesc(rho);colormap(gray);

P_Xj_Sj = lic_make_emissions_mtx(labels,p_Xj_Sj(:,end)');
P2 = P.*P_Xj_Sj;

psi(:,end) = P2'*ones(m,1);
psi(:,end) = psi(:,end)/sum(psi(:,end));
for j = n-1:-1:1
    P_Xj_Sj = lic_make_emissions_mtx(labels,p_Xj_Sj(:,j)');
    P2 = P.*P_Xj_Sj;
    psi(:,j) = P2'*psi(:,j+1);
    psi(:,j) = psi(:,j)/sum(psi(:,j));
end

p_xs = rho.*psi;

[p_sj,sj] = max(p_xs,[],1);
figure;imagesc(p_xs);colormap gray;

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

figure;
imagesc(x);
axis equal;
colormap gray;
set(gca,'fontsize',6);
set(gca,'XTick',[1:n]); 
set(gca,'XTickLabels',sj_labels);