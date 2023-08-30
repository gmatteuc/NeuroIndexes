function plot_surprise_matrix(reordered_matrix, reordered_labels, reordered_colors, titlestring, currax)
% plot reodered matrix
hold(currax, 'on');
imagesc(currax, flipud(reordered_matrix));
colormap(gray);
colorbar;
% set axis labels
yticks(currax, 1:size(reordered_matrix, 1));
xticks(currax, 1:size(reordered_matrix, 1));
yticklabels(currax, reordered_labels(size(reordered_matrix, 1):-1:1));
xticklabels(currax, reordered_labels(1:size(reordered_matrix, 1)));
xlim(currax, [(1 - 0.5), (size(reordered_matrix, 1) + 0.5)]);
ylim(currax, [(1 - 0.5), (size(reordered_matrix, 1) + 0.5)]);
% color individual ticks
cm=cell2mat(reordered_colors');
ax=gca;
for itick = 1:numel(ax.XTickLabel)
    ax.XTickLabel{itick} = ...
        sprintf('\\color[rgb]{%f,%f,%f}%s',...
        cm(itick,:)*0.85,...
        ax.XTickLabel{itick});
end
for itick = 1:numel(ax.YTickLabel)
    ax.YTickLabel{itick} = ...
        sprintf('\\color[rgb]{%f,%f,%f}%s',...
        cm(itick,:)*0.85,...
        ax.YTickLabel{itick});
end
title(currax, titlestring);
set(currax, 'fontsize', 12);
end