function [hmu, hstd] = plot_shaded_mu_stdul(ax, xvals, mu, stdu, stdl, color, alpha)
% plot_shaded_mu_stdul(ax, xvals, mu, stdu, stdl, color, alpha)
% plot a shaded area around a mean curve with different upper and lower "standard deviations".
%   ax: axis handle
%   xvals: x-axis values
%   mu: mean values
%   stdu: upper standard deviation
%   stdl: lower standard deviation
%   color: RGB color for the plot
%   alpha: transparency level for the shaded area
% --------------------------------
% Giulio Matteucci 2021

% test if correct size and transpose if necessary
if size(mu, 1) ~= 1
    mu = mu';
end
if size(stdu, 1) ~= 1
    stdu = stdu';
end
if size(stdl, 1) ~= 1
    stdl = stdl';
end
% initialize x values
if isempty(xvals)
    x = 1:length(mu);
else
    x = xvals;
end
% remove points with mean NaN
nanidx = find(isnan(mu));
mu(nanidx) = [];
stdu(nanidx) = [];
stdl(nanidx) = [];
x(nanidx) = [];
% replace std NaN with zeros
stdu(isnan(stdu)) = 0;
stdl(isnan(stdl)) = 0;
% plot patch
hmu = plot(ax, x, mu, '-', 'Color', color);
uE = mu + stdu;
lE = mu - stdl;
yP = [lE, fliplr(uE)];
xP = [x, fliplr(x)];
hstd = patch(ax, xP, yP, 1, 'facecolor', color, 'edgecolor', 'none', 'facealpha', alpha);

end