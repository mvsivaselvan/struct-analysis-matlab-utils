function [Kmem,Pmem] = getTriangleStiffMatAndLoadVector(coord, p, S)

M = [ones(3,1) coord];

% area
A = det(M)/2;

% centroid
Xc = mean(coord(:,1));
Yc = mean(coord(:,2));

B = [0 1 0; 0 0 1]/M;
Kmem = B'*(S*A)*B;

Q = (M'\[1; Xc; Yc])*A; % ones(3,1)*A/3
Pmem = Q*p;
