function [] = lic_display_result(x,s,c)
figure;
imagesc(x);
axis equal;
colormap gray;

dy = 10;

X = [c(1,:) c(2,:);
     c(1,:) c(2,:)];

Y = [zeros(1,size(X,2))-dy; ...
     size(x,1)*ones(1,size(X,2))+dy];

for m = 1:numel(s)
    text((c(1,m)+c(2,m))/2,size(x,1)+15,s(m), ...
         'FontSize',23, ...
         'Color',[0 0 0], ...
         'HorizontalAlignment','center');
    line(X,Y,'LineWidth',3,'Color','b');
end