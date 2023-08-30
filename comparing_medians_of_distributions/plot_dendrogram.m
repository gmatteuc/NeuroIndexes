function plot_dendrogram(tree, reordered_labels, reordered_colors, reordering_permutation, titlestring, currax)
% plot dendrogram
dd = dendrogram(tree, 'Reorder', reordering_permutation);
for i = 1:numel(dd)
    dd(i).Color = [0 0 0];
    dd(i).LineWidth = 2;
end
xticklabels(reordered_labels);
xtickangle(45);
% color individual ticks
cm=cell2mat(reordered_colors');
ax=gca;
for itick = 1:numel(ax.XTickLabel)
    ax.XTickLabel{itick} = ...
        sprintf('\\color[rgb]{%f,%f,%f}%s',...
        cm(itick,:)*0.85,...
        ax.XTickLabel{itick});
end
title(currax, titlestring);
ylabel(currax, 'distance');
set(currax, 'fontsize', 12);
end