function P = Moving_Snake(B, P, Fext, Delta_T, kappa, delta)
    % Move the snake toward the force field
    %
    % inputs:
    %   B : Internal force (smoothness) matrix
    %   P : The contour points N x 2;
    %   Fext : External vector field (from image)
    %   gamma : Time step
    %   kappa : External (image) field weight
    %   delta : Balloon Force weight
    % output:
    %   P : The (moved) contour points N x 2;

    % Clamp contour to boundary
    P(:, 1) = min(max(P(:, 1), 1), size(Fext, 1));
    P(:, 2) = min(max(P(:, 2), 1), size(Fext, 2));

    % Get image force on the contour points
    Fext1(:, 1) = kappa * interp2(Fext(:, :, 1), P(:, 2), P(:, 1));
    Fext1(:, 2) = kappa * interp2(Fext(:, :, 2), P(:, 2), P(:, 1));

    % Interp2, can give nan's if contour close to border
    Fext1(isnan(Fext1)) = 0;

    % Calculate the baloon force on the contour points
    N = Contour_Normal(P);
    Fext2 = delta * N;

    % Update contour positions
    ssx = Delta_T * P(:, 1) + Fext1(:, 1) + Fext2(:, 1);
    ssy = Delta_T * P(:, 2) + Fext1(:, 2) + Fext2(:, 2);
    P(:, 1) = B * ssx;
    P(:, 2) = B * ssy;

    % Clamp contour to boundary
    P(:, 1) = min(max(P(:, 1),1), size(Fext, 1));
    P(:, 2) = min(max(P(:, 2),1), size(Fext, 2));