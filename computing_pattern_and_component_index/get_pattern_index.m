function [pattern_index, z_pattern, z_component, r_pattern, r_component, cds_pred, pds_pred] = ...
    get_pattern_index(tuning_curve_grating, tuning_curve_plaid, plaid_half_angle, angle_step_orig)
% get_pattern_index(tuning_curve_grating, tuning_curve_plaid)
% Compute pattern and component predictions given two tuning curves.
%   tuning_curve_grating: tuning curve for grating stimuli
%   tuning_curve_plaid: tuning curve for plaid stimuli
%   plaid_half_angle: half plaid cross-angle (angular distance btw components)
%   angle_step_orig: angle step of tuning curves
% --------------------------------
% Giulio Matteucci 2021

    % add small random noise to ensure uniqueness
    tuning_grating = tuning_curve_grating' + 1e-7 * rand(size(tuning_curve_grating'));
    tuning_plaid = tuning_curve_plaid' + 1e-7 * rand(size(tuning_curve_plaid'));
    % ensure input tuning curves are vectors
    tuning_grating = ensure_is_column(tuning_grating)';
    tuning_plaid = ensure_is_column(tuning_plaid)';
    % define constants
    angle_shift = plaid_half_angle / angle_step_orig;
    % shift tuning curves to get component predictions
    resp_grating1 = circshift(tuning_grating', -angle_shift)';
    resp_grating2 = circshift(tuning_grating', angle_shift)';
    % set predictions
    cds_pred = (resp_grating1 + resp_grating2) / 2;
    pds_pred = tuning_grating;
    % calculate correlations
    r_component = corr(tuning_plaid', cds_pred');
    r_pattern = corr(tuning_plaid', pds_pred');
    r_cp = corr(pds_pred', cds_pred');
    % calculate partial correlations
    r_pattern = (r_pattern - r_component * r_cp) / sqrt((1 - r_component^2) * (1 - r_cp^2));
    r_component = (r_component - r_pattern * r_cp) / sqrt((1 - r_pattern^2) * (1 - r_cp^2));
    % fisher transform
    z_pattern = 0.5 * log((1 + r_pattern) / (1 - r_pattern)) / sqrt(1 / (12 - 3));
    z_component = 0.5 * log((1 + r_component) / (1 - r_component)) / sqrt(1 / (12 - 3));
    % compute pattern index
    pattern_index = z_pattern - z_component;

end
