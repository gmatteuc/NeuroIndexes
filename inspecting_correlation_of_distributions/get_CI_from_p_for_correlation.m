function [r_lCI, r_uCI] = get_CI_from_p_for_correlation(p_value, r_value, sample_size, alpha_level)
% get_CI_from_p_for_correlation(p_value, r_value, sample_size, alpha_level)
% compute the confidence interval for a correlation coefficient using Fisher's Z-transformation.
%   p_value: p-value of the correlation
%   r_value: correlation coefficient
%   sample_size: number of samples
%   alpha_level: significance level for the confidence interval
% --------------------------------
% Giulio Matteucci 2021

% fisher's Z-transformation
z_value = 0.5 * log((1 + r_value) / (1 - r_value));
% standard error of z
se = 1 / sqrt(sample_size - 3);
% critical z-value for the given alpha level
z_critical = norminv(1 - alpha_level / 2);
% confidence interval for z
z_lCI = z_value - z_critical * se;
z_uCI = z_value + z_critical * se;
% inverse Fisher's Z-transformation
r_lCI = (exp(2 * z_lCI) - 1) / (exp(2 * z_lCI) + 1);
r_uCI = (exp(2 * z_uCI) - 1) / (exp(2 * z_uCI) + 1);

end