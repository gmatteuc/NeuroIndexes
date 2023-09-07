function bsi = compute_bsi(response, angles)
% bsi = compute_bsi(response, angles)
% compute_bsi Calculates Cadieu's Bimodal Selectivity Index (BSI) using
% findpeaks to gain more noise robustness in detecting bimodality.
%   response: array containing the average responses to different angles
%   angles: array containing the angles corresponding to the responses
%   bsi: BSI
% --------------------------------
% Giulio Matteucci 2021

% build the orientation response curve from the direction response curve
orientation_angles = mod(angles, 180);
orientation_response = accumarray(orientation_angles'+1, response', [], @mean);
% find peaks in the orientation response curve
[pks, locs] = findpeaks(orientation_response);
% if less than two peaks are found, set BSI to zero (no bimodality at all)
if length(pks) < 2
    bsi = 0;
    return;
end
% sort peaks and get the two highest ones
[sorted_pks, sort_idx] = sort(pks, 'descend');
pref1 = sorted_pks(1);
pref2 = sorted_pks(2);
% get the corresponding locations (angles) for the two highest peaks
loc1 = locs(sort_idx(1));
loc2 = locs(sort_idx(2));
% find the minimum response between the two peaks
min_idx_range = min(loc1, loc2):max(loc1, loc2);
min_resp = min(orientation_response(min_idx_range));
% calculate BSI
bsi = (pref1 + pref2 - 2 * min_resp) / (pref1 + pref2);

end