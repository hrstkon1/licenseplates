function sj = lic_calc_best_path(p_xs,P)
global m n;
pred = zeros(m,n);
g0 = zeros(n,1);
g0(end-1,1) = p_xs(end-1,1);

for j = 2:n
    gmask = g0 > 0;
    k = sum(gmask);
    im = find(gmask);
    
    pp_xs = p_xs(:,j*ones(1,k));
    pmask = full(P(:,gmask) > 0);
    g1 = zeros(m,k);
    g1(pmask) = pp_xs(pmask);

    for k2 = 1:k
        g1(pmask(:,k2),k2) = g1(pmask(:,k2),k2)+g0(im(k2));
    end
    [CC,II] = max(g1,[],2);
    ic = CC > eps;
    g0(ic) = CC(ic);
    g0(~ic) = 0;
    pred(ic,j) = im(II(ic));
end

[dummy,sn] = max(g0);
sj = zeros(1,n);
sj(n) = sn;

for k = n:-1:2
    sj(k-1) = pred(sj(k),k);
end
