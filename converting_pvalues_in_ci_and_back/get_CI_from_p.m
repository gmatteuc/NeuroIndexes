function [CI_width,est_val,est_lCI,est_uCI] = get_CI_from_p(input_pval,input_value,target_confidence,test_type)
% [CI_width,est_val,est_lCI,est_uCI] = get_CI_from_p(input_pval,input_value,target_confidence,test_type)
% compute confidence interval (CI) width and bounds given a p-value, value, target confidence, and test type.
%   input_pval: p-value from the statistical test
%   input_value: value for which the CI is being computed
%   target_confidence: desired confidence level (e.g., 0.95 for 95% CI)
%   test_type: 'onesided' or 'twosided' for one-sided or two-sided tests
%   CI_width: width of the confidence interval
%   est_val: estimated value (same as input_value)
%   est_lCI: lower bound of the confidence interval
%   est_uCI: upper bound of the confidence interval
% --------------------------------
% Giulio Matteucci 2021

% get target alpha --------------------------------------------------------
target_alpha=1-target_confidence;

% get critical Z ----------------------------------------------------------
switch test_type
    case 'onesided'
        % get two sided desired confidence level
        desired_confidence=1-target_alpha;
    case 'twosided'
        % get one sided desired confidence level
        desired_confidence=1-target_alpha/2;
end
% get critical z correcponding to target confidence level
zvalvec=0:0.001:10;
[~,idx_critical_z]=min(abs(normcdf(zvalvec)-desired_confidence));
critical_z=zvalvec(idx_critical_z);

% get CI width ------------------------------------------------------------
switch test_type
    case 'onesided'
        % get one sided z value corresponding to input p value
        curr_z=norminv(input_pval);
    case 'twosided'
        % get one sided z value corresponding to input p value
        curr_z=norminv(input_pval/2);
end
% get standard error corresponding to
curr_se=input_value/curr_z;
% get  estmated confidence interval at target confidence level
CI_width=abs(2*critical_z*curr_se);
% get full confidence interval
est_val=input_value;
est_uCI=input_value+CI_width/2;
est_lCI=input_value-CI_width/2;

end