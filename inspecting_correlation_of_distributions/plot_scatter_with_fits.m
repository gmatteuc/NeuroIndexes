function fh = plot_scatter_with_fits(input_distr, input_labels, input_colors, input_varnames, input_titlestring, output_rho, output_p, output_opt_b, output_opt_b_ci, output_ypred, output_ypred_ci, output_xpred, input_axislims)
% plot_scatter_with_fits(input_distr, input_labels, input_colors, input_varnames, input_titlestring, output_rho, output_p, output_opt_b, output_opt_b_ci, output_ypred, output_ypred_ci, output_xpred, xlimstouse, input_axislims)
% plot the results of the data analysis, including scatter plots, best-fit lines, and bar plots for slopes and correlations.
%   input_distr: cell array of input distributions
%   input_labels: cell array of labels for each distribution
%   input_colors: cell array of RGB colors for each distribution
%   input_varnames: cell array of variable names
%   input_titlestring: title for the scatter plot
%   output_rho: cell array of correlation coefficients
%   output_p: cell array of p-values for correlations
%   output_opt_b: cell array of best-fit parameters
%   output_opt_b_ci: cell array of confidence intervals for best-fit parameters
%   output_ypred: cell array of predicted y-values for best-fit line
%   output_ypred_ci: cell array of confidence intervals for predicted y-values
%   output_xpred: cell array of x-values for best-fit line
%   input_axislims: x-axis and y-axis limits for scatter plot
% --------------------------------
% Giulio Matteucci 2021

% Initialize figure
fh = figure('units','normalized','outerposition',[0 0 1 1]);

% Plot scatter plot
subplot(2,4,[1,2,3,5,6,7])
% determine axis limits
if isempty(input_axislims{1})
    temp = cellfun(@(x) x(:, 1), input_distr, 'UniformOutput', false);
    temp = cell2mat(temp');
    xlimstouse = [min(temp(:)), max(temp(:))];
    xlimstouse = [xlimstouse(1)-0.1.*diff(xlimstouse),...
        xlimstouse(end)+0.1.*diff(xlimstouse)];
else
    xlimstouse = input_axislims{1};
end
if isempty(input_axislims{2})
    temp = cellfun(@(x) x(:, 2), input_distr, 'UniformOutput', false);
    temp = cell2mat(temp');
    ylimstouse = [min(temp(:)), max(temp(:))];
    ylimstouse = [ylimstouse(1)-0.1.*diff(ylimstouse),...
        ylimstouse(end)+0.1.*diff(ylimstouse)];
else
    ylimstouse = input_axislims{2};
end
% loop through each distribution
for i = 1:numel(input_distr)
    hold on;
    % get data for scatter
    xtofit = input_distr{i}(:,1);
    ytofit = input_distr{i}(:,2);
    % get correlation and linear fit results
    curr_rho = output_rho{i};
    curr_p = output_p{i};
    curr_opt_b = output_opt_b{i};
    curr_opt_b_ci = output_opt_b_ci{i};
    curr_ypred = output_ypred{i};
    curr_ypred_ci = output_ypred_ci{i};
    curr_xpred = output_xpred{i};
    % get current label setting
    curr_label = input_labels{i};
    curr_color = input_colors{i};
    curr_alpha = 0.15;
    % plot best fit line with confidence interval
    [~, ~] = plot_shaded_mu_std(gca, curr_xpred, curr_ypred, curr_ypred_ci, curr_color, curr_alpha);
    plot(curr_xpred, curr_ypred,'-','linewidth',2,'color',curr_color);
    % plot data points as scatter plot
    scatter(xtofit, ytofit, 75, 'o', 'Markerfacecolor', curr_color, 'Markeredgecolor', curr_color, 'Markerfacealpha', 0.99, 'Markeredgealpha', 0.99);
    % add zero lines
    plot(xlimstouse,[0,0],':','linewidth',1,'color',[0.5,0.5,0.5]);
    plot([0,0],ylimstouse,':','linewidth',1,'color',[0.5,0.5,0.5]);
    % write up linear fit slopes
    text(xlimstouse(1) + 0.025 * diff(xlimstouse), ylimstouse(2) - (0.025 + (i - 1) * 0.03) * diff(ylimstouse),...
        [curr_label, ' slope = ', num2str(round(curr_opt_b(2),2)),...
        ' +/- ', num2str(round(abs(curr_opt_b_ci(2, 2) - curr_opt_b(2)),2))],...
        'fontsize', 12, 'color', curr_color);
    % write up correlation coefficient values
    text(xlimstouse(end) - 0.35 * diff(xlimstouse), ylimstouse(2) - (0.025 + (i - 1) * 0.03) * diff(ylimstouse),...
        [curr_label, ' \rho = ', num2str(round(curr_rho,2)),...
        '  p(\rho) = ', num2str(curr_p)],...
        'fontsize', 12, 'color', curr_color);
end
% set axis limits
xlim(xlimstouse)
ylim(ylimstouse)
% set axis labels
xlabel(input_varnames{1})
ylabel(input_varnames{2})
% set axis properties
set(gca, 'fontsize', 12);
% add title
title(input_titlestring)

% Add slope barplots
subplot(2,4,4)
slope_value = NaN(1,numel(input_distr));
slope_lCI = NaN(1,numel(input_distr));
slope_uCI = NaN(1,numel(input_distr));
slope_pos = 1:numel(input_distr);
for i = 1:numel(input_distr)
    % get confidence interval for correlation with Fisher transform
    slope_value(i) = output_opt_b{i}(2);
    slope_lCI(i) = output_opt_b_ci{i}(2,1);
    slope_uCI(i) = output_opt_b_ci{i}(2,2);
end
hold on;
for i = 1:numel(input_distr)
    bar(slope_pos(i),slope_value(i),...
        'facecolor',input_colors{i},...
        'edgecolor',input_colors{i},...
        'facealpha',0.5,...
        'linewidth',2,...
        'barwidth',0.6)
end
errorbar(slope_pos,slope_value,abs(slope_value-slope_lCI),abs(slope_value-slope_uCI),'LineStyle','none','LineWidth',2,'Color',[0,0,0]);
scatter(slope_pos,slope_value,50,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor',[0,0,0]);
titlestring='slope values';
title(titlestring)
% ylim([-1.1,1.1])
xticks(slope_pos)
xticklabels(input_labels)
xtickangle(45)
ylabel('best fit slope');
set(gca,'fontsize',12)

% Add correlation barplots
subplot(2,4,8)
rho_value = NaN(1,numel(input_distr));
p_value = NaN(1,numel(input_distr));
rho_lCI = NaN(1,numel(input_distr));
rho_uCI = NaN(1,numel(input_distr));
rho_pos = 1:numel(input_distr);
for i = 1:numel(input_distr)
    % get confidence interval for correlation with Fisher transform
    alpha_level = 0.95;
    curr_rho = output_rho{i};
    curr_p = output_p{i};
    rho_value(i) = curr_rho;
    p_value(i) = curr_p;
    % get confidence interval for rho
    [~, ~, rho_lCI(i), rho_uCI(i)] = get_CI_from_p(p_value(i),rho_value(i),alpha_level,'twosided');
end
hold on;
for i = 1:numel(input_distr)
    bar(rho_pos(i),rho_value(i),...
        'facecolor',input_colors{i},...
        'edgecolor',input_colors{i},...
        'facealpha',0.5,...
        'linewidth',2,...
        'barwidth',0.6)
end
errorbar(rho_pos,rho_value,abs(rho_value-rho_lCI),abs(rho_value-rho_uCI),'LineStyle','none','LineWidth',2,'Color',[0,0,0]);
scatter(rho_pos,rho_value,50,'MarkerFaceColor',[0,0,0],'MarkerEdgeColor',[0,0,0]);
titlestring='correlation values';
title(titlestring)
ylim([-1.1,1.1])
xticks(rho_pos)
xticklabels(input_labels)
xtickangle(45)
ylabel(['\rho (',input_varnames{1},',',input_varnames{2},')']);
set(gca,'fontsize',12)

end