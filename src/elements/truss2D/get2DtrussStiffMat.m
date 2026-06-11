function Kmem = get2DtrussStiffMat(coord, E, area)

% Compute stiffness matrix of 2D truss member

x1 = coord(1,1);
y1 = coord(1,2);
x2 = coord(2,1);
y2 = coord(2,2);

L = sqrt( (x2-x1)^2 + (y2-y1)^2 );

B = [-(x2-x1)/L -(y2-y1)/L (x2-x1)/L (y2-y1)/L];

Kmem = B'*(E*area/L)*B;