function dsi = compute_dsi(response, angles)
% dsi = compute_dsi(response, angles)
% calculates the Direction Selectivity Index (DSI)
%   response: array containing the average responses to different angles
%   angles: array containing the angles corresponding to the responses
%   dsi: Direction Selectivity Index
% --------------------------------
% Giulio Matteucci 2021


% find the index of the maximum response
[~, max_idx] = max(response);
% get the preferred angle
pref_angle = angles(max_idx);
% get the null angle
null_angle = mod(pref_angle + 180, 360);
null_idx = find(angles == null_angle);
% calculate DSI
dsi = (response(max_idx) - response(null_idx)) / (response(max_idx) + response(null_idx));

end