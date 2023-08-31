function pval = get_p_from_CI(input_CIwidth,input_value,target_confidence,test_type)
% pval = get_p_from_CI(input_CIwidth,input_value,target_confidence,test_type)
% compute p-value given a confidence interval (CI) width, value, target confidence, and test type.
%   input_CIwidth: width of the confidence interval
%   input_value: value for which the p-value is being computed
%   target_confidence: desired confidence level (e.g., 0.95 for 95% CI)
%   test_type: 'onesided' or 'twosided' for one-sided or two-sided tests
%   pval: computed p-value
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
        desired_confidence=1-target_alpha./2;
end
% get critical z correcponding to target confidence level
zvalvec=0:0.001:10;
[~,idx_critical_z]=min(abs(normcdf(zvalvec)-desired_confidence));
critical_z=zvalvec(idx_critical_z);

% get CI width-------------------------------------------------------------
% get standard error corresponding to confidence target interval
curr_se=(input_CIwidth./(critical_z)./2);
% get corresponding z value
curr_z=input_value./curr_se;
switch test_type
    case 'onesided'
        % get two sided p value
        pval=normcdf(-curr_z);
    case 'twosided'
        % get one sided p value
        pval=2*normcdf(-curr_z);
end

end