function [surprise,CV,surpmask_high,CVmask_high,surpmask_low,CVmask_low] = get_surprise_cv_and_masks_BN2p...
    (input_trials,...
    signifthreshold_high,...
    CVthreshold_high,....
    min_sig_seq_length_sig_high,...
    min_sig_seq_length_CV_high,...
    signifthreshold_low,...
    CVthreshold_low,....
    min_sig_seq_length_sig_low,...
    min_sig_seq_length_CV_low,...
    testmode...
    )
% [surprise,CV,surpmask_high,CVmask_high,surpmask_low,CVmask_low] = get_surprise_cv_and_masks_BN2p...
%     (input_trials,...
%     signifthreshold_high,...
%     CVthreshold_high,....
%     min_sig_seq_length_sig_high,...
%     min_sig_seq_length_CV_high,...
%     signifthreshold_low,...
%     CVthreshold_low,....
%     min_sig_seq_length_sig_low,...
%     min_sig_seq_length_CV_low,...
%     testmode...
%     )
% Get surprise and CV with relative masks.

%% --- compute response surprise ---

% perform z tests
ptests=nan(1,size(input_trials,1));
% loop over samples
for k=1:size(input_trials,1)
    
    % perform test over trilas
    switch testmode
        case 'medians'
            ptests(k) = signrank(squeeze(input_trials(k,:)));
        case 'means'
            [~, ptests(k)] = ztest(squeeze(input_trials(k,:)),0,1,'tail','right');
    end
    
    % avoid nand and infinities
    if ptests(k)==0
        ptests(k) = 10^-320;
    elseif isnan(ptests(k))
        ptests(k) = 1;
    else
    end
    
end

% get surprises from p vaues
surprise=-log10(ptests);

%% --- get responsivity mask ---

% threshold surprise to get surpmask - high
surpmask_high=surprise>=signifthreshold_high;
% apply continuity constraint
[ surpmask_high ] = apply_continuity_constraint_BN2p(surpmask_high,min_sig_seq_length_sig_high);

% threshold surprise to get surpmask - low
surpmask_low=surprise>=signifthreshold_low;
% apply continuity constraint
[ surpmask_low ] = apply_continuity_constraint_BN2p(surpmask_low,min_sig_seq_length_sig_low);

%% --- compute coeficient of variation ---

% initialize outputs
CV = zeros(1,size(input_trials,1));

% loop over samples
for k=1:size(input_trials,1)
    % compute coefficient of variation for each bin
    CV(k) = abs( ( nanstd(squeeze(input_trials(k,:))) )/( nanmean(squeeze(input_trials(k,:))) ) ); %#ok<NANMEAN,NANSTD>
end

%% --- get reliability mask ---

% initialize outputs
CVmask_high =zeros(1,size(input_trials,1));
CVmask_low =zeros(1,size(input_trials,1));

% threshold coefficient of variation to get CVmask - high
CVmask_high(CV<=CVthreshold_high)=1;
% apply continuity constraint
[ CVmask_high ] = apply_continuity_constraint_BN2p(CVmask_high,min_sig_seq_length_CV_high);

% threshold coefficient of variation to get CVmask - low
CVmask_low(CV<=CVthreshold_low)=1;
% apply continuity constraint
[ CVmask_low ] = apply_continuity_constraint_BN2p(CVmask_low,min_sig_seq_length_CV_low);

end

