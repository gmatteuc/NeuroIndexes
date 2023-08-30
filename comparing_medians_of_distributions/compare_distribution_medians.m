close all
clear all
clc

% -------------------------------------------------------------------------
% README: this test function creates six dummy distributions with
% different spereads and median values to demonstrate the plotting function
% "plot_violinplot" as well as to show how to build a comparison matrix and
% reorder itr with hierarchical clustering
% -------------------------------------------------------------------------

% generate synthetic data --------------------------------------------------
input_distr = {randn(1, 100), 1.2 * randn(1, 100) + 4, 3 * randn(1, 100) - 3,...
    randn(1, 100), 1.2 * randn(1, 100) + 4, 3 * randn(1, 100) - 3,};
input_labels = {'distribution 1a', 'distribution 2a', 'distribution 3a',...
    'distribution 1b', 'distribution 2b', 'distribution 3b'};
input_colors = {[0.5, 0.5, 1], [0, 0, 0.95], [0.2, 0, 0.45], ...
    1*[0.5, 0.5, 1], 1*[0, 0, 0.95], 1*[0.2, 0, 0.45]};

% compute and median difference surprise matrix ----------------------------
surp_meddiff = compute_median_diff_surprises(input_distr);

% reorder median difference surprise matrix ----------------------------
clustmetric = 'cosine';
clustmethod = 'average';
[reordered_matrix, reordered_labels,reordering_permutation,tree] = ...
    reorder_compmat(surp_meddiff, input_labels, clustmethod, clustmetric);
reordered_colors=input_colors(reordering_permutation);

% initialize the figure ---------------------------------------------------
figure('units', 'normalized', 'outerposition', [0 0 1 1]);

% plot violin plot --------------------------------------------------------
currax_violin = subplot(2, 3, [1, 2, 4, 5]);
[inputadata, inputpars] = prepare_plot_violinplot_inputs(...
    input_distr, input_labels, input_colors, ...
    'example violin plot comparing 6 distributions', currax_violin);
plot_violinplot(inputadata, inputpars); hold on;
plot(inputpars.inputaxh,inputpars.xlimtouse,[0,0],'--','linewidth',2,'color',[0.5,0.5,0.5])

% plot reordered surprise matrix ------------------------------------------
currax_surprise = subplot(2, 3, 3);
plot_surprise_matrix(reordered_matrix, reordered_labels, reordered_colors, ...
    'distribution median comparison surprise', currax_surprise);

% plot reordered dendrogram -----------------------------------------------
currax_dendrogram = subplot(2, 3, 6);
plot_dendrogram(tree, reordered_labels, reordered_colors, reordering_permutation,...
    'hierarchical clustering dendrogram', currax_dendrogram);