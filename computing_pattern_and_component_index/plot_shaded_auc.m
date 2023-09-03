function pp = plot_shaded_auc(ax, distr_x, distr_y, alpha, color)
% plot_shaded_auc(ax, distr_x, distr_y, alpha, color)
% plot shaded area under the curve for a given distribution.
%   ax: axis handle where the plot is drawn
%   distr_x: x-values of the distribution
%   distr_y: y-values of the distribution
%   alpha: transparency level for the shaded area
%   color: RGB color for the shaded area
% --------------------------------
% Giulio Matteucci 2021

% initialize the y-values for the patch
yP = [distr_y, 0, 0];
% initialize the x-values for the patch
xP = [distr_x, distr_x(end), distr_x(1)];
% create the patch
pp = patch(ax, xP, yP, 1, 'facecolor', color, 'edgecolor', 'none', 'facealpha', alpha);

end
