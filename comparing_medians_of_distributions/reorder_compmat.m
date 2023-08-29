function [reordered_matrix,reordered_labels,reordering_permutation,tree] = reorder_compmat(original_matrix,original_labels,clustmethod,clustmetric)

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

