function [ypred, ypred_ci, xpred, opt_b, opt_b_ci, lmodel] = get_lin_fit_with_ci(xtofit, ytofit, xpredlims)
% get_lin_fit_with_ci(xtofit, ytofit, xpredlims)
% fits a linear model to data and returns predictions and confidence intervals.
%   xtofit: x data to fit
%   ytofit: y data to fit
%   xpredlims: limits for x prediction
% --------------------------------
% Giulio Matteucci 2021

% initialize linear model
lmodel = @(b, x) b(2) * x + b(1);
% fit linear model
[opt_b, R, ~, COV, ~, ~] = nlinfit(xtofit, ytofit, lmodel, rand(2, 1));
% find confidence intervals for best fit parameters
opt_b_ci = nlparci(opt_b, R, 'covar', COV);
% find confidence intervals for prediction
xpred = linspace(min(xpredlims), max(xpredlims), 100);
[ypred, ypred_ci] = nlpredci(lmodel, xpred, opt_b, R, 'covar', COV);
% flip if result turns to be transposed in order to be the same as x input
if not(sum(size(ypred) == size(xpred)))
    ypred = ypred';
    ypred_ci = ypred_ci';
end

end

