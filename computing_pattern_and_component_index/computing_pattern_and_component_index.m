close all
clear all
clc

% -------------------------------------------------------------------------
% README: This script generates synthetic tuning curves for ideal "pattern" and
% "component" cells. It then computes the pattern and component indexes
% and uses the provided functions to visualizes the results.
% -------------------------------------------------------------------------

% add to path utility function --------------------------------------------

% get utility function path
current_script_fullpath = mfilename('fullpath');
[current_script_dir, ~, ~] = fileparts(current_script_fullpath);
folder_to_add = fullfile(current_script_dir, '..', 'inspecting_correlation_of_distributions');
% add utility function path
addpath(folder_to_add);

% generate synthetic data -------------------------------------------------

% set parameters
n_points = 12; % number of points in the tuning curve
n_trials = 40; % number of sampled trials
random_center = 165; % randi([0, 360]); % randomly select a center direction
std_dev = 30; % Standard deviation for the Gaussian
plaid_half_angle = 60; % half angle for the plaid
% generate "pattern" tuning curves
angles = linspace(0, 360, n_points+1);
angles = angles(1:end-1);
angles_step = mode(diff(angles));
pattern_grating = exp(-(angles - random_center).^2 / (2 * std_dev^2));
pattern_plaid = pattern_grating;
% generate "component" tuning curves
component_grating = exp(-(angles - (random_center)).^2 / (2 * std_dev^2));
component_plaid = exp(-( angles - (random_center - plaid_half_angle) ).^2 / (2 * std_dev^2)) + ...
    exp(-( angles - (random_center + plaid_half_angle) ).^2 / (2 * std_dev^2));
% preallocate arrays for Poisson trials - "component"
poisson_trials_component_grating = zeros(length(angles), n_trials);
poisson_trials_component_plaid = zeros(length(angles), n_trials);
% preallocate arrays for Poisson trials - "pattern"
poisson_trials_pattern_grating = zeros(length(angles), n_trials);
poisson_trials_pattern_plaid = zeros(length(angles), n_trials);
% generate poisson trials - "component"
for i = 1:length(angles)
    poisson_trials_component_grating(i, :) = poissrnd(component_grating(i), [1, n_trials]);
    poisson_trials_component_plaid(i, :) = poissrnd(component_plaid(i), [1, n_trials]);
end
% generate poisson trials - "pattern"
for i = 1:length(angles)
    poisson_trials_pattern_grating(i, :) = poissrnd(pattern_grating(i), [1, n_trials]);
    poisson_trials_pattern_plaid(i, :) = poissrnd(pattern_plaid(i), [1, n_trials]);
end
% set "pattern" and "component" grating and plaid colors
patt_comp_colors = {[0.5, 0.5, 1], [0, 0, 0.95]; [0.5, 0.5, 1].*0.75, [0, 0, 0.95].*0.75};

% compute tuning curve average and standard error -------------------------

% get avg and se across trials "component"
component_grating_avg=nanmean(poisson_trials_component_grating,2); %#ok<*NANMEAN>
component_grating_se=nanstd(poisson_trials_component_grating,[],2)./(sqrt(n_trials)); %#ok<*NANSTD>
component_plaid_avg=nanmean(poisson_trials_component_plaid,2);
component_plaid_se=nanstd(poisson_trials_component_plaid,[],2)./(sqrt(n_trials));
% get avg and se across trials "pattern"
pattern_grating_avg=nanmean(poisson_trials_pattern_grating,2);
pattern_grating_se=nanstd(poisson_trials_pattern_grating,[],2)./(sqrt(n_trials));
pattern_plaid_avg=nanmean(poisson_trials_pattern_plaid,2);
pattern_plaid_se=nanstd(poisson_trials_pattern_plaid,[],2)./(sqrt(n_trials));

% compute pattern and component indexes -----------------------------------

% get index "component" 
[component_p_index, component_z_p, component_z_c, component_r_p, component_r_c,...
    component_cds_pred, component_pds_pred] = get_pattern_index(...
    component_grating_avg, component_plaid_avg, plaid_half_angle, angles_step);
% get index "pattern"
[pattern_p_index, pattern_z_p, pattern_z_c, pattern_r_p, pattern_r_c,...
    pattern_cds_pred, pattern_pds_pred] = get_pattern_index(...
    pattern_grating_avg, pattern_plaid_avg, plaid_half_angle, angles_step);

% visualize the results ---------------------------------------------------

% initialize figure
fh = figure('units','normalized','outerposition',[0 0 1 1]);

% plot "component" tuning curves
subplot(2, 3, 1);
hold on;
plot(angles, component_grating_avg, 'LineWidth',2,'Color',patt_comp_colors{1,1});
plot_shaded_mu_std(gca, angles, component_grating_avg, component_grating_se, patt_comp_colors{1,1}, 0.15)
plot(angles, component_plaid_avg, 'LineWidth',2,'Color',patt_comp_colors{2,1});
plot_shaded_mu_std(gca, angles, component_plaid_avg, component_plaid_se, patt_comp_colors{2,1}, 0.15)
title(['component cell - PI = ', num2str(round(component_p_index,2)),...
    ' Zp = ', num2str(round(component_z_p,2)),' Zc = ', num2str(round(component_z_c,2))]);
xlabel('direction (°)');
ylabel('response');
axis square
xlim([min(angles),max(angles)])
ylim([0,1.1*max([component_grating_avg;component_plaid_avg])])
set(gca,'fontsize',12)
subplot(2, 3, 2);
imagesc(poisson_trials_component_grating'); colormap(gca,'gray'); colorbar; axis square;
ylabel('trial');
xlabel('direction (°)');
title('grating trials','Color',patt_comp_colors{1,1})
set(gca,'fontsize',12)
subplot(2, 3, 3);
imagesc(poisson_trials_component_plaid'); colormap(gca,'gray'); colorbar; axis square;
ylabel('trial');
xlabel('direction (°)');
title('plaid trials','Color',patt_comp_colors{2,1})
set(gca,'fontsize',12)
% plot "pattern" tuning curves
subplot(2,3,4);
hold on;
plot(angles, pattern_grating_avg, 'LineWidth',2,'Color',patt_comp_colors{1,2});
plot_shaded_mu_std(gca, angles, pattern_grating_avg, pattern_grating_se, patt_comp_colors{1,2}, 0.15)
plot(angles, pattern_plaid_avg, 'LineWidth',2,'Color',patt_comp_colors{2,2});
plot_shaded_mu_std(gca, angles, pattern_plaid_avg, pattern_plaid_se, patt_comp_colors{2,2}, 0.15)
title(['pattern cell - PI = ', num2str(round(pattern_p_index,2)),...
    ' Zp = ', num2str(round(pattern_z_p,2)),' Zc = ', num2str(round(pattern_z_c,2))]);
xlabel('direction (°)');
ylabel('response');
axis square
xlim([min(angles),max(angles)])
ylim([0,1.1*max([pattern_grating_avg;pattern_plaid_avg])])
set(gca,'fontsize',12)
subplot(2, 3, 5);
imagesc(poisson_trials_pattern_grating'); colormap(gca,'gray'); colorbar; axis square;
ylabel('trial');
xlabel('direction (°)');
title('grating trials','Color',patt_comp_colors{1,2})
set(gca,'fontsize',12)
subplot(2, 3, 6);
imagesc(poisson_trials_pattern_plaid'); colormap(gca,'gray'); colorbar; axis square;
ylabel('trial');
xlabel('direction (°)');
title('plaid trials','Color',patt_comp_colors{2,2})
set(gca,'fontsize',12)
sgtitle('example component and pattern cell')

% print as a jpg
saveas(fh,['computing_pattern_and_component_index','.jpg'])
% print in Illustrator friendly vector format
print(fh,'-depsc','-painters',['computing_pattern_and_component_index','.eps']) %#ok<PRTPT>