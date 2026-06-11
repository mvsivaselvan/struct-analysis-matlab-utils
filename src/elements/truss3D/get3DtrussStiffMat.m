function Kmem = get3DtrussStiffMat(coord, E, area)

% Compute stiffness matrix of 2D truss member

x1 = coord(1,1);
y1 = coord(1,2);
z1 = coord(1,3);
x2 = coord(2,1);
y2 = coord(2,2);
z2 = coord(2,3);

L = sqrt( (x2-x1)^2 + (y2-y1)^2 );

B = [-(x2-x1)/L -(y2-y1)/L -(z2-z1)/L (x2-x1)/L (y2-y1)/L];

Kmem = B'*(E*area/L)*B;