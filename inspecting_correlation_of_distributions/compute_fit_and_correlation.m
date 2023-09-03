function [output_rho, output_p, output_opt_b, output_opt_b_ci, output_ypred, output_ypred_ci, output_xpred] = compute_fit_and_correlation(input_distr, input_axislims)
% compute_fit_and_correlation(input_distr, xlimstouse)
% compute the best-fit lines and correlations for a set of bivariate distributions.
%   input_distr: cell array of input distributions
%   input_axislims: x-axis (and y-axis) limits for scatter plot (range of fit prediction)
% --------------------------------
% Giulio Matteucci 2021

% initialize storage variables
output_rho = cell(1,numel(input_distr));
output_p = cell(1,numel(input_distr));
output_opt_b = cell(1,numel(input_distr));
output_opt_b_ci = cell(1,numel(input_distr));
output_ypred = cell(1,numel(input_distr));
output_ypred_ci = cell(1,numel(input_distr));
output_xpred = cell(1,numel(input_distr));
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
% loop through each distribution
for i = 1:numel(input_distr)
    % get data to compute fit and correlation
    xtofit = input_distr{i}(:,1);
    ytofit = input_distr{i}(:,2);
    % get best fit line with confidence interval
    xpredlims = xlimstouse;
    [curr_ypred, curr_ypred_ci, curr_xpred, curr_opt_b, curr_opt_b_ci, ~] = get_lin_fit_with_ci(xtofit, ytofit, xpredlims);
    % get correlation
    [curr_rho, curr_p] = corr(xtofit, ytofit);
    % store output
    output_rho{i} = curr_rho;
    output_p{i} = curr_p;
    output_opt_b{i} = curr_opt_b;
    output_opt_b_ci{i} = curr_opt_b_ci;
    output_ypred{i} = curr_ypred;
    output_ypred_ci{i} = curr_ypred_ci;
    output_xpred{i} = curr_xpred;
end

end