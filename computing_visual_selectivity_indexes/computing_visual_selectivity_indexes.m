close all
clear all
clc

% -------------------------------------------------------------------------
% README: This script generates synthetic tuning curves for ideal "oriented"
% (i.e. responding to both direction of motion of a grating along the same line)
% and "directional" cells (i.e. responding to only one) or "corner" selective
% (i.e. responding to two close to orthogonal directions). Then the code...
% computes the orientation and direction selectivity indexes, tuning bandwidth,...
% and Cadieu's bimodal selectivity index.
% -------------------------------------------------------------------------

% add to path utility function --------------------------------------------

% get utility function path
current_script_fullpath = mfilename('fullpath');
[current_script_dir, ~, ~] = fileparts(current_script_fullpath);
folder_to_add = fullfile(current_script_dir, '..',...
    'inspecting_correlation_of_distributions');
% add utility function path
addpath(folder_to_add);

% generate synthetic data -------------------------------------------------

% set parameters
n_points = 12; % number of points in the tuning curve
n_trials = 40; % number of sampled trials
random_center = 165; % randi([0, 360]); % randomly select a center direction
std_dev = 30; % standard deviation for the Gaussian
corner_angle = 75; % angle distance of the second peak from the main

% generate tuning curves
angles = linspace(0, 360, n_points+1);
angles = angles(1:end-1);
directional_curve = exp(-(angles - random_center).^2 / (2 * std_dev^2));
oriented_curve = directional_curve + 0.8 .* exp(-(angles - random_center + 180).^2 / (2 * std_dev^2));
corner_curve = oriented_curve ...
    + 0.8 .* exp(-(angles -...
    random_center + corner_angle)...
    .^2 / (2 * std_dev^2)) ...
    + 0.6 .* exp(-(angles -...
    random_center + corner_angle +180)...
    .^2 / (2 * std_dev^2));

% generate poisson trials
poisson_trials_oriented = poissrnd(repmat(oriented_curve, n_trials, 1));
poisson_trials_directional = poissrnd(repmat(directional_curve, n_trials, 1));
poisson_trials_corner = poissrnd(repmat(corner_curve, n_trials, 1));

% compute tuning curve average and standard error -------------------------

% get avg and se across trials
oriented_avg = mean(poisson_trials_oriented, 1);
oriented_se = std(poisson_trials_oriented, [], 1) / sqrt(n_trials);
directional_avg = mean(poisson_trials_directional, 1);
directional_se = std(poisson_trials_directional, [], 1) / sqrt(n_trials);
corner_avg = mean(poisson_trials_corner, 1);
corner_se = std(poisson_trials_corner, [], 1) / sqrt(n_trials);


% compute selectivity indeces ---------------------------------------------

% TODO: write up computation functions

% ----- compute OSI -----
osi(1) = compute_osi(oriented_avg', angles');
osi(2) = compute_osi(directional_avg', angles');
osi(3) = compute_osi(corner_avg', angles');

% ----- compute DSI -----
dsi(1) = compute_dsi(oriented_avg', angles');
dsi(2) = compute_dsi(directional_avg', angles');
dsi(3) = compute_dsi(corner_avg', angles');

% ----- compute BW -----
bandwidth(1) = compute_bandwidth(oriented_avg', angles');
bandwidth(2) = compute_bandwidth(directional_avg', angles');
bandwidth(3) = compute_bandwidth(corner_avg', angles');

% ----- compute BSI -----
bsi(1) = compute_bsi(oriented_avg, angles);
bsi(2) = compute_bsi(directional_avg, angles);
bsi(3) = compute_bsi(corner_avg, angles);

% visualize the results ---------------------------------------------------

% initialize figure
fh = figure('units','normalized','outerposition',[0 0 1 1]);

% plot "oriented" tuning curves
subplot(2, 3, 1);
hold on;
plot(angles, oriented_avg, 'LineWidth', 2);
plot_shaded_mu_std(gca, angles, oriented_avg, oriented_se, [0.5, 0.5, 1], 0.15);
title(['OSI = ', num2str(round(osi(1), 2)),...
    'DSI = ', num2str(round(dsi(1), 2)),...
    'BW = ', num2str(round(bandwidth(1), 2)),...
    'BSI = ', num2str(round(bsi(1), 2))]);
xlabel('direction (°)');
ylabel('response');
axis square;

% plot "directional" tuning curves
subplot(2, 3, 2);
hold on;
plot(angles, directional_avg, 'LineWidth', 2);
plot_shaded_mu_std(gca, angles, directional_avg, directional_se, [0, 0, 0.95], 0.15);
title(['OSI = ', num2str(round(osi(2), 2)),...
    'DSI = ', num2str(round(dsi(2), 2)),...
    'BW = ', num2str(round(bandwidth(2), 2)),...
    'BSI = ', num2str(round(bsi(2), 2))]);
xlabel('direction (°)');
ylabel('response');
axis square;

% plot "corner" tuning curves
subplot(2, 3, 3);
hold on;
plot(angles, corner_avg, 'LineWidth', 2);
plot_shaded_mu_std(gca, angles, corner_avg, corner_se, [0.2, 0, 0.45], 0.15);
title(['OSI = ', num2str(round(osi(3), 2)),...
    'DSI = ', num2str(round(osi(3), 2)),...
    'BW = ', num2str(round(bandwidth(3), 2)),...
    'BSI = ', num2str(round(bsi(3), 2))]);
xlabel('direction (°)');
ylabel('response');
axis square;

% print as a jpg
saveas(fh, ['computing_visual_selectivity_indexes', '.jpg']);
% print in Illustrator friendly vector format
print(fh, '-depsc', '-painters', ['computing_visual_selectivity_indexes', '.eps']); %#ok<PRTPT>

% TODO: add heatmap plotting, improve corner neuron example, add "ensure is
% column" like control at the beginning of each function, check general
% behavior