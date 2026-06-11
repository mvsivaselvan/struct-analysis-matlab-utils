% Load geometry from file exported from ABAQUS
coord = load('coord.dat');
connect = load('connectivity.dat') + 1;

% plot mesh
figure,
    patch('faces',connect(:,[1 2 3 1]),'vertices',coord,'facecolor','r')
axis equal

% identify boundary nodes
inbnd = sqrt(sum(coord.^2,2)) < 0.501; % inner bndry: radius = 0.5
outbnd = (coord(:,1) < -0.999) | (coord(:,1) > 0.999) ...
       | (coord(:,2) < -0.999) | (coord(:,2) > 0.999); % outer bndry

% assign boundary conditions (fix outer and inner boundaries)   
bcs = zeros(size(coord,1),1);
bcs(inbnd | outbnd) = 1;

% pressure and tension
pPress = 2; % p = 2*theta, and set theta = 1
STens = 1; % S = 1/G, and set G = 1
