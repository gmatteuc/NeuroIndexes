function plot_surprise_matrix(surprise_matrix, surprise_labels, surprise_colors, titlestring, currax)
% plot_surprise_matrix(surprise_matrix, surprise_labels, surprise_colors, titlestring, currax)
% plot a surprise matrix with custom axis labels, tick colors, and title.
%   surprise_matrix: 2D surprise data to plot
%   surprise_labels: axis labels
%   surprise_colors: tick colors
%   titlestring: plot title
%   currax: axis handle
% --------------------------------
% Giulio MAtteucci 2021

% plot reodered matrix
hold(currax, 'on');
tempmat = flipud(surprise_matrix);
imagesc(currax,tempmat);
for i=1:size(tempmat,1)
    for j=1:size(tempmat,2)
        if tempmat(i,j)>=-log10(0.05)
            scatter(j,i,100,'*',...
                'MarkerFaceColor',[0.5,0.5,0.5],...
                'MarkerEdgeColor',[0.5,0.5,0.5])
        end
    end
end
colormap(gray);
colorbar;
% set axis labels
yticks(currax, 1:size(surprise_matrix, 1));
xticks(currax, 1:size(surprise_matrix, 1));
yticklabels(currax, surprise_labels(size(surprise_matrix, 1):-1:1));
xticklabels(currax, surprise_labels(1:size(surprise_matrix, 1)));
xlim(currax, [(1 - 0.5), (size(surprise_matrix, 1) + 0.5)]);
ylim(currax, [(1 - 0.5), (size(surprise_matrix, 1) + 0.5)]);
% color individual ticks
cm=cell2mat(surprise_colors');
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