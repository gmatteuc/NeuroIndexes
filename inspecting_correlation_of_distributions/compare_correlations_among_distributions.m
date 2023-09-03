lose all
clear all
clc

% -------------------------------------------------------------------------
% README: This test function creates 3 dummy bivariate distributions with
% different levels of correlation between the two variables. It demonstrates
% the "get_lin_fit_with_ci" and "plot_shaded_mu_std_BN2p" functions to plot
% the best-fit regression lines and scatterplots of the two variables.
% -------------------------------------------------------------------------

% add to path utility function --------------------------------------------

% get utility function path
current_script_fullpath = mfilename('fullpath');
[current_script_dir, ~, ~] = fileparts(current_script_fullpath);
folder_to_add = fullfile(current_script_dir, '..', 'converting_pvalues_in_ci_and_back');
% add utility function path
addpath(folder_to_add);

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

% Perform linear fit and get correlations ------------------------------
[output_rho, output_p, output_opt_b, output_opt_b_ci, output_ypred, output_ypred_ci, output_xpred]...
    = compute_fit_and_correlation(input_distr, input_axislims);

% plot results --------------------------------------------------------
fh = plot_scatter_with_fits(input_distr, input_labels, input_colors, input_varnames, input_titlestring, output_rho, output_p, output_opt_b, output_opt_b_ci, output_ypred, output_ypred_ci, output_xpred, input_axislims);

% print as a jpg
saveas(fh,['inspecting_correlation_of_distributions','.jpg']) 
% print in Illustrator friendly vector format
print(fh,'-depsc','-painters',['inspecting_correlation_of_distributions','.eps']) %#ok<PRTPT>