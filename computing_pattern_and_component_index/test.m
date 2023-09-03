% -------------------------------------------------------------------------
% README: This script generates synthetic tuning curves for "pattern" and
% "component" cases. It then computes the pattern and component indexes
% using the provided functions and visualizes the results.
% -------------------------------------------------------------------------

% Generate synthetic data -------------------------------------------------

% Set parameters
n_points = 360; % Number of points in the tuning curve
random_center = randi([0, 359]); % Randomly select a center direction
std_dev = 30; % Standard deviation for the Gaussian
plaid_half_angle = 60; % Half angle for the plaid

% Generate "pattern" tuning curves
angles = linspace(0, 359, n_points);
pattern_grating = exp(-(angles - random_center).^2 / (2 * std_dev^2));
pattern_plaid = pattern_grating;

% Generate "component" tuning curves
component_grating = exp(-(angles - (random_center + plaid_half_angle / 2)).^2 / (2 * std_dev^2));
component_plaid = exp(-(angles - random_center).^2 / (2 * std_dev^2)) + ...
                  exp(-(angles - (random_center + plaid_half_angle)).^2 / (2 * std_dev^2));

% Compute pattern and component indexes -----------------------------------

% For "pattern" case
[PI_pattern, ~, ~, ~, ~, ~, ~] = get_pattern_index_bk(pattern_grating, pattern_plaid);

% For "component" case
[PI_component, ~, ~, ~, ~, ~, ~] = get_pattern_index_bk(component_grating, component_plaid);

% Visualize the results ---------------------------------------------------

% Initialize figure
figure;

% Plot "pattern" tuning curves
subplot(2, 2, 1);
plot(angles, pattern_grating, 'b', angles, pattern_plaid, 'r');
title(['Pattern Case: PI = ', num2str(PI_pattern)]);
legend('Grating', 'Plaid');
xlabel('Angle');
ylabel('Response');

% Plot "component" tuning curves
subplot(2, 2, 2);
plot(angles, component_grating, 'b', angles, component_plaid, 'r');
title(['Component Case: PI = ', num2str(PI_component)]);
legend('Grating', 'Plaid');
xlabel('Angle');
ylabel('Response');
