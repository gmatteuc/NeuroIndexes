close all
clear all
clc

% -------------------------------------------------------------------------
% README: This test function creates 3 dummy bivariate distributions with
% different levels of correlation between the two variables. It demonstrates
% the "get_lin_fit_with_ci" and "plot_shaded_mu_std_BN2p" functions to plot
% the best-fit regression lines and scatterplots of the two variables.
% -------------------------------------------------------------------------

% generate synthetic data -------------------------------------------------

% set number of samples to generate
n_points = 100;
% define means for three bivariate distributions
means = [5, 4, -3; -5, 4, 5];
% define standard deviations for three bivariate distributions
std_devs = [1, 10.5, 3; 1, 2.5, 8];
% define correlation coefficients for three bivariate distributions
correlations = [0, 0.4, -0.5];
% initialize cell arrays to hold distributions
input_distr = cell(1, 3);
% generate bivariate distributions
for i = 1:size(means, 2)  % Changed the loop limit here
    % set sigmas
    sigma = diag([std_devs(1, i), std_devs(2, i)]);
    % set covariances
    R = [1, correlations(i); correlations(i), 1];
    % create covariance matrix
    cov_matrix = sigma * R * sigma;
    % generate bivariate normal distribution
    input_distr{i} = mvnrnd(means(:, i)', cov_matrix, n_points);  % Transposed means(:, i) here
end
input_labels = {'distribution 1', 'distribution 2', 'distribution 3'};
input_colors = {[0.5, 0.5, 1], [0, 0, 0.95], [0.2, 0, 0.45]};
input_varnames = {'variable 1','variable 2'};
input_axislims = {[], []}; % {[-10,10], [-20,20]};
input_titlestring = 'example scatterplot of bivariate distributions';

% initialize figure -------------------------------------------------------
fhandle = figure('units','normalized','outerposition',[0 0 1 1]);

% plot scatter plot -------------------------------------------------------
subplot(3,4,[1,2,3,5,6,7,9,10,11])
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
    % get data to compute fit and correlation
    xtofit = input_distr{i}(:,1);
    ytofit = input_distr{i}(:,2);
    % get best fit line with confidence interval
    xpredlims = xlimstouse;
    [curr_ypred, curr_ypred_ci, curr_xpred, curr_opt_b, curr_opt_b_ci, lmodel] = get_lin_fit_with_ci(xtofit, ytofit, xpredlims);
    % get correlation
    [curr_rho, curr_p] = corr(xtofit, ytofit);
    % get current label setting
    curr_label = input_labels{i};
    curr_color = input_colors{i};
    curr_alpha = 0.15;
    % plot best fit line with confidence interval
    [hmu, hstd] = plot_shaded_mu_std(gca, curr_xpred, curr_ypred, curr_ypred_ci, curr_color, curr_alpha);
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

% add slope barplots ------------------------------------------------

% add correlation barplots ------------------------------------------------

% errorbars using: [r_lCI, r_uCI] = get_CI_from_p_for_correlation(p_value, r_value, sample_size, alpha_level)
