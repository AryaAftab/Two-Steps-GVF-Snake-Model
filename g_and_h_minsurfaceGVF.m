function [g, h] = g_and_h_minsurfaceGVF(edgemap, k)
    % Calculate h and g from the minimum surface GVF formula
    %
    % inputs: 
    %   edgemap : image edgemap
    %   k : arameter determines the balance between field smoothness and gradient conformity
    % output:
    %   g : g of the minimum surface GVF formula
    %   h : h of the minimum surface GVF formula

    [d_edgemap_x, d_edgemap_y] = gradient(edgemap);
    g = exp(( - sqrt(d_edgemap_x.^2 + d_edgemap_y.^2)) ./ k);
    h = 1-g;