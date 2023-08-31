clear all
close all
clc

% -------------------------------------------------------------------------
% README: This script tests the functions "get_CI_from_p" and "get_p_from_CI" 
% by converting p-values to confidence intervals (CIs) and back verifying 
%vconsistency within a given tolerance. Note that this approach for converting
% p-values to CIs and vice versa assumes that the underlying data distribution
% is normal. The approach also assumes that the sample size is sufficiently 
% large for the Central Limit Theorem to apply. Make sure these assumptions
% hold in your specific case before using these functions!
% -------------------------------------------------------------------------

% initialize variables for testing ----------------------------------------
test_values = [10, 20, 30, 40, 50];
test_pvals = [0.01, 0.05, 0.1];
target_confidences = [0.9, 0.95, 0.99];
test_types = {'onesided', 'twosided'};

% initialize tolerance for equality check ---------------------------------
tolerance = 1e-6;

% loop through each combination of inputs  --------------------------------
for val = test_values
    for pval = test_pvals
        for conf = target_confidences
            for t = 1:length(test_types)
                test_type = test_types{t};
                % convert p-value to CI
                [CI_width, ~, ~, ~] = get_CI_from_p(pval, val, conf, test_type);
                % convert CI back to p-value
                pval_back = get_p_from_CI(CI_width, val, conf, test_type);
                % check if the returned p-value is close to the original p-value
                if abs(pval_back - pval) > tolerance
                    % display test result
                    fprintf('Test failed for value = %f, p-value = %f, confidence = %f, test_type = %s\n', val, pval, conf, test_type);
                else
                    % display test result
                    fprintf('Test passed for value = %f, p-value = %f, confidence = %f, test_type = %s\n', val, pval, conf, test_type);
                end
            end
        end
    end
end