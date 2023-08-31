function [inputadata, inputpars]=prepare_plot_violinplot_inputs(input_distr, input_labels, input_colors, input_titlestring, input_ax)
% [inputadata, inputpars] = prepare_plot_violinplot_inputs(input_distr, input_labels, input_colors, input_titlestring, input_ax)
% prepare the input data and parameters for the plot_violinplot function.
%   input_distr: cell array of distributions to plot
%   input_labels: cell array of labels for the distributions
%   input_colors: cell array of RGB colors for the distributions
%   input_titlestring: title for the plot
%   input_ax: axis handle for the plot
%   inputadata: struct containing prepared distributions
%   inputpars: struct containing prepared parameters for plotting
% --------------------------------
% Giulio Matteucci 2021

% get data range
yrange = [min(cell2mat(input_distr)), max(cell2mat(input_distr))];
% set input pars
inputpars.boxplotwidth = 0.4;
inputpars.boxplotlinewidth = 2;
inputpars.densityplotwidth = 0.4;
inputpars.scatterjitter = inputpars.boxplotlinewidth * 0.1;
inputpars.scatteralpha = 0.33;
inputpars.scattersize = 40;
inputpars.distralpha = 0.5;
inputpars.boolscatteron = 1;
inputpars.yimtouse = yrange+[-0.2*diff(yrange),+0.2*diff(yrange)];
inputpars.ks_bandwidth = diff(yrange) * 0.1;
inputpars.xlabelstring = [];
inputpars.ylabelstring = 'feature value';
inputpars.inputaxh = input_ax;
inputpars.titlestring = input_titlestring;
inputpars.n_distribs = numel(input_distr);
inputpars.dirstrcenters = 1:inputpars.n_distribs;
inputpars.xlimtouse = [-0, inputpars.n_distribs + 1];
inputpars.xtickslabelvector = input_labels;
inputpars.distrcolors = input_colors;
% set input data
inputadata.inputdistrs = input_distr;

end