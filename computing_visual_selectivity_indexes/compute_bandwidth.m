function bandwidth = compute_bandwidth(tuning_curve, angles)
% bandwidth = compute_bandwidth(tuning_curve, angles)
% computes the bandwidth of a tuning curve
% by fitting a Gaussian and extracting its FWHM.
%   tuning_curve: 1D array representing the tuning curve
%   angles: 1D array representing the angles corresponding to the tuning curve
%   bandwidth: computed bandwidth (FWHM) of the tuning curve
% --------------------------------
% Giulio Matteucci 2021

% regularization parameters (you can adjust these based on your needs)
regpars = zeros(1, 4);
% set whether to include baseline parameter for the fit (you can adjust these based on your needs)
usebs = 1;
% fit a Gaussian to the tuning curve
[fitParamsCell, ~, ~] = get_gaussian_fit(tuning_curve, regpars, usebs, false);
% extract the best-fit parameters
best_fit_params = fitParamsCell{1};
% extract the standard deviation (sigma) from the best-fit parameters
sigma = best_fit_params(3);

% convert sigma to angle space
angle_step = mean(diff(angles));
sigma_angle = sigma * angle_step;

% compute the FWHM in angle space
bandwidth = 2 * sqrt(2 * log(2)) * sigma_angle;

end