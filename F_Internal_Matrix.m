function B = F_Internal_Matrix(point_num, alpha, beta, Delta_T)
% Calculating "A" matrix to solve snake moving iteratively (the basic snake)
%
% inputs:
%   point_num : The number of snake contour points
%   alpha : weighting parameters that control the snake’s tension
%   beta : weighting parameters that control the snake’s rigidity
%   Delta_T : Step Size (Time)
% output:
%   B : internal force matrix

b(1) = beta;
b(2) = - (alpha + 4 * beta);
b(3) = (2 * alpha + 6 * beta);
b(4) = b(2);
b(5) = b(1);

% matrix (for every contour point)

A = b(1) * circshift(eye(point_num), 2);
A = A + b(2) * circshift(eye(point_num), 1);
A = A + b(3) * circshift(eye(point_num), 0);
A = A + b(4) * circshift(eye(point_num), -1);
A = A + b(5) * circshift(eye(point_num), -2);

% Calculate the inverse Matrix
B = inv(A + Delta_T .* eye(point_num));