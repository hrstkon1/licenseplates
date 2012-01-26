function [] = lic_display_pds(uf,sf,ub,sb);
    ix = uf-3*sf:1e-3:uf+3*sf; %covers more than 99% of the curve
    iy = pdf('normal',ix,uf,sf);
    figure;
    h1 = plot(ix,iy,'r-');

    ix = ub-3*sb:1e-3:ub+3*sb; %covers more than 99% of the curve
    iy = pdf('normal',ix,ub,sb);
    hold on;
    h2 = plot(ix,iy,'b-');

    hold off;
    
    hLegend = legend('foreground', 'background')
    xlabel('normalized intensity')
    ylabel('relative frequency')

    set([hLegend, gca], 'FontSize', 8);
    set(h1, 'LineWidth', 2, ...
            'Color', [0 0 .5]);
    set(h2, 'LineWidth', 2, ...
            'Color', [0 .5 0]);
end