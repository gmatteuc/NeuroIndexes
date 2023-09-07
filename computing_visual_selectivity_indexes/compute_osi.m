function osi = compute_osi(response, angles)
% osi = compute_osi(response, angles)
% calculates the Orientation Selectivity Index (OSI)
%   response: array containing the average responses to different angles
%   angles: array containing the angles corresponding to the responses
%   osi: Orientation Selectivity Index
% --------------------------------
% Giulio Matteucci 2021

% find the index of the maximum response
[~, max_idx] = max(response);
% get the preferred angle
pref_angle = angles(max_idx);
% get the orthogonal angle
ortho_angle = mod(pref_angle + 90, 360);
ortho_idx = find(angles == ortho_angle);
% calculate OSI
osi = (response(max_idx) - response(ortho_idx)) / (response(max_idx) + response(ortho_idx));

end