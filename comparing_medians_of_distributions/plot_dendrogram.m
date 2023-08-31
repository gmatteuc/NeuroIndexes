function plot_dendrogram(tree, reordered_labels, reordered_colors, reordering_permutation, titlestring, currax)
% plot_dendrogram(tree, reordered_labels, reordered_colors, reordering_permutation, titlestring, currax)
% plot a dendrogram with custom labels, tick colors, and title.
%   tree: hierarchical clustering tree
%   reordered_labels: reordered labels for the x-axis
%   reordered_colors: cell array of RGB colors for x-axis ticks
%   reordering_permutation: permutation used for reordering the dendrogram
%   titlestring: title for the plot
%   currax: axis handle where the plot is drawn
% --------------------------------
% Giulio Matteucci 2021

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