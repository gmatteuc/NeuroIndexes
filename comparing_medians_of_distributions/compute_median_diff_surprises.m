function surp_meddiff = compute_median_diff_surprises(input_distr)
% compute median surprise difference matrix
surp_meddiff = NaN(numel(input_distr), numel(input_distr));
for i = 1:numel(input_distr)
    for j = 1:numel(input_distr)
        curr_y1 = input_distr{i};
        curr_y2 = input_distr{j};
        [curr_p_val,~] = ranksum(curr_y1', curr_y2');
        surp_meddiff(i, j) = -log10(curr_p_val);
    end
end
end