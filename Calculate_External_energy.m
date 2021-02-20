function E_ext = Calculate_External_energy(I, Sigma)
    % Calculate the External Energy
    %
    % inputs: 
    %   I : The image
    %   Sigma : Sigma used to calculated image derivatives 
    % output:
    %   E_ext : external energy

    Ix = ImageDerivation(I, Sigma, 'x');
    Iy = ImageDerivation(I, Sigma, 'y');
    Ixx = ImageDerivation(I, Sigma, 'xx');
    Ixy = ImageDerivation(I, Sigma, 'xy');
    Iyy = ImageDerivation(I, Sigma, 'yy');


    Eedge = sqrt(Ix.^2 + Iy.^2); 

    E_ext= -2 * Eedge;