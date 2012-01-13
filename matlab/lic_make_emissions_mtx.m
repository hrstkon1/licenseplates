function PX_SJ = lic_make_emissions_mtx(labels,px_sj)
k = numel(px_sj);
PX_SJ = spdiags(px_sj,0,k,k);