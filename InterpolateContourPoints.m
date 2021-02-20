function K = InterpolateContourPoints2D(P, nPoints)
    % This function resamples a few points describing a countour , to a smooth
    % contour of uniform sampled points.
    %
    % input,
    %   P : Inpute Contour, size N x 2  (with N >= 4)
    %   nPoints : Number of Contour points as output
    % output:
    %   K : Uniform sampled Contour points, size nPoints x 2

    % Interpolate points in between
    O(:, 1) = interp([P(end-3:end, 1); P(:, 1); P(:, 1); P(1:4, 1)], 10);
    O(:, 2) = interp([P(end-3:end, 2); P(:, 2); P(:, 2); P(1:4, 2)], 10);
    O = O(41:end-39, :);

    % Calculate distance between points
    dis = [0; cumsum(sqrt(sum((O(2:end, :) - O(1:end-1, :)).^2, 2)))];

    % Resample to make uniform points
    K(:, 1) = interp1(dis, O(:, 1), linspace(0, dis(end), nPoints * 2));
    K(:, 2) = interp1(dis, O(:, 2), linspace(0, dis(end), nPoints * 2));
    K = K(round(end / 4):round(end / 4) + nPoints - 1, :);