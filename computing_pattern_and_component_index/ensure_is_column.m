function output_vector = ensure_is_column(input_vector)
% ensure_is_column(input_vector)
% ensure the input vector is a column vector.
%   input_vector: the vector to be checked
% --------------------------------
% Giulio Matteucci 2021

% check if the input is already a column vector
if size(input_vector, 1) >= size(input_vector, 2)
    output_vector = input_vector;
else
    output_vector = input_vector';
end

end
