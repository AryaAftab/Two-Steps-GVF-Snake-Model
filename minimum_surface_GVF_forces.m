function F_ext = minimum_surface_GVF_forces(I, k, F_ext , Iterations, Sigma)
    % Calculating the final external force field without normalization
    %
    % inputs:
    %   I : The Image
    %   k : parameter determines the balance between field smoothness and gradient conformity
    %   F_ext : initial external force field
    %   Iterations : number of iteration
    %   Sigma : gaussian sigma parameter
    % output:
    %   F_ext : final external force

    Nu = F_ext;
    F_x  = F_ext(:, :, 1);
    F_y= F_ext(:, :, 2);
    edgemap = F_ext;

    u = F_x;
    v = F_y;
    delta_t = 0.5;

    for counter = 1:Iterations
      Nu_x = ImageDerivation(Nu, Sigma, 'x');
      Nu_y = ImageDerivation(Nu, Sigma, 'y');
      Nu_xx = ImageDerivation(Nu, Sigma, 'xx');
      Nu_yy = ImageDerivation(Nu, Sigma, 'yy');
      Nu_xy = ImageDerivation(Nu, Sigma, 'xy');

      min_surface_GVF_formula = (((1 + Nu_y.^2) .* Nu_xx) + ((1 + Nu_x.^2) .* Nu_yy) - (2 .* Nu_x .* Nu_y .* Nu_xy)) ./ (1 + Nu_x.^2 + Nu_y.^2);
      [g, h] = g_and_h_minsurfaceGVF(edgemap, k);

      d_Nu = delta_t .* (g .* min_surface_GVF_formula - h .* (Nu - edgemap));
      Nu = Nu + d_Nu;
    end

    F_ext = Nu;