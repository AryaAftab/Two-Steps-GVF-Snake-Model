clc; clear all; close all;


%% Load Image and make it double form

I = im2double(rgb2gray(imread('data/Ushape.png')));

%% Draw initial curve
% inputs
point_num = 80;

% Show an image
figure();
imshow(I);

% Select some points with the mouse
[y, x] = getpts;

% Make an array with the clicked coordinates
P=[x(:), y(:)];

% Interpolate inbetween the points
P = InterpolateContourPoints(P, point_num);

% Show the result
hold on
plot(P(:, 2), P(:, 1), 'b');

%% calculate external energy

%input: I=image, Sigma=Sigma used to calculated image derivatives 

Sigma = 4;
E_ext = Calculate_External_energy(I, Sigma);

%% Calculate external force (flow) field

Fx = ImageDerivation(E_ext, Sigma, 'x');
Fy = ImageDerivation(E_ext, Sigma, 'y');
F_ext(:, :, 1) = -Fx * 2 * Sigma^2;
F_ext(:, :, 2) = -Fy * 2 * Sigma^2;

%% Do the proposed model of Gradient vector flow, optimalization
% input: GVFiteration, Sigma, k

GVFiteration = 300;
k = 1.8;
F_ext = minimum_surface_GVF_forces(I, k, F_ext, GVFiteration, Sigma);

%% External force in step 1

for counter1 = 1:size(F_ext, 1)
    for counter2 = 1:size(F_ext, 2)
        U(counter1, counter2) = sign(F_ext(counter1, counter2, 1));
        V(counter1, counter2) = sign(F_ext(counter1, counter2, 2));
    end
end

Fext_step1(:, :, 1) = U;
Fext_step1(:, :, 2) = V;

%% External force in step 2

for counter1 = 1:size(F_ext, 1)
    for counter2 = 1:size(F_ext, 2)
        U(counter1, counter2) = F_ext(counter1, counter2, 1) / (sqrt((F_ext(counter1, counter2, 1))^2 + (F_ext(counter1, counter2, 2))^2));
        V(counter1, counter2) = F_ext(counter1, counter2, 2) / (sqrt((F_ext(counter1, counter2, 1))^2 + (F_ext(counter1, counter2, 2))^2));
        U(counter1, counter2) = U(counter1, counter2) * 1.5;
        V(counter1, counter2) = V(counter1, counter2) * 1.5;
    end
end

Fext_step2(:, :, 1) = U;
Fext_step2(:, :, 2) = V;

%% Draw Initial Condition

h = figure(); 
set(h, 'render', 'opengl')

subplot(2,2,1) 
imshow(I,[])
hold on
plot(P(:, 2), P(:, 1), 'b.')
hold on
title('The image with initial contour')

subplot(2,2,2)
[x, y] = ndgrid(1:10:size(Fext_step1, 1), 1:10:size(Fext_step1, 2));
imshow(I)
hold on
quiver(y, x, Fext_step1(1:10:end,1:10:end ,2), Fext_step1(1:10:end,1:10:end, 1));
title('The external force field ')

subplot(2,2,3) 
[x, y] = ndgrid(1:10:size(Fext_step2, 1), 1:10:size(Fext_step2, 2));
imshow(I)
hold on
quiver(y, x, Fext_step2(1:10:end,1:10:end, 2), Fext_step2(1:10:end,1:10:end, 1));
title('The external force field ')

subplot(2,2,4) 
imshow(I)
hold on
plot(P(:, 2), P(:, 1), 'b.') 
title('Snake movement ')
drawnow

%% Calculate initial Internal Force Matrix
% input : alpha & beta & Delta_T

alpha = 0.6;
beta = 0.0;
delta_t = 1;
S = F_Internal_Matrix(point_num, alpha, beta, delta_t);

%% Moving Snake and Plot the Output from step1

h=[];

% input : itr = number of iteration
itr = 200;
Kappa=4;
Delta = -0.05;

for counter = 1:itr
    P = Moving_Snake(S, P, Fext_step1, delta_t, Kappa, Delta);

    % Show current contour
    if(ishandle(h))
        delete(h)
    end

    h = plot(P(:, 2), P(:, 1), 'r.');
    c = counter / itr;
    plot([P(:, 2); P(1, 2)], [P(:, 1); P(1, 1)], '-', 'Color', [c, 1-c, 0]); 
    drawnow
end

figure()
imshow(I)
hold on
plot([P(:, 2); P(1, 2)], [P(:, 1); P(1, 1)], 'r-', 'LineWidth', 4);
title('final curve of step 1')

%% Moving Snake and Plot the Output from step1

h=[];

% input : itr = number of iteration
itr = 100;
Kappa=2;
Delta= -0.1;

for counter = 1:itr
    P = Moving_Snake(S, P, Fext_step2, delta_t, Kappa, Delta);

    % Show current contour
    if(ishandle(h))
        delete(h)
    end

    h = plot(P(:, 2), P(:, 1), 'r.');
    c = counter / itr;
    plot([P(:, 2); P(1, 2)], [P(:, 1); P(1, 1)], '-','Color', [c, 1-c, 0]); 
    drawnow
end

figure()
imshow(I)
hold on
plot([P(:, 2); P(1, 2)], [P(:, 1); P(1, 1)], 'r-', 'LineWidth', 4);
title('final curve')

%% draw the output picture

J = Draw_output(P, size(I));

%% Calculate F-measure
orgin = im2double(imread('data/Ushape_test.png'));
Calculate_fmeasure(orgin,J);