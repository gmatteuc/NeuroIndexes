function [reordered_matrix,reordered_labels,reordering_permutation,tree] = reorder_compmat(original_matrix,original_labels,clustmethod,clustmetric)
% [reordered_matrix,reordered_labels,reordering_permutation,tree] = reorder_compmat(original_matrix,original_labels,clustmethod,clustmetric)
% reorder a comparison matrix and its labels using hierarchical clustering.
%   original_matrix: initial 2D matrix
%   original_labels: initial labels for the matrix
%   clustmethod: clustering method
%   clustmetric: distance metric for clustering
%   reordered_matrix: reordered 2D matrix
%   reordered_labels: reordered labels
%   reordering_permutation: permutation used for reordering
%   tree: Hierarchical clustering tree
% --------------------------------
% Giulio Matteucci 2021

% find reordering with hierarchical clustering
tree = linkage(original_matrix,clustmethod,clustmetric);
% [~,~,reordering_permutation] = dendrogram(var_z);
var_d = pdist(original_matrix);
reordering_permutation = optimalleaforder(tree,var_d);
% reorder matrix and labels
reordered_matrix=original_matrix(reordering_permutation,:);
reordered_matrix=reordered_matrix(:,reordering_permutation);
reordered_labels=original_labels(reordering_permutation);

end

