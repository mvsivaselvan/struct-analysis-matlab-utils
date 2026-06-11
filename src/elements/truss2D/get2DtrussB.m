function Bmem = get2DtrussB(coord)

% Compute stiffness matrix of 2D truss member

x1 = coord(1,1);
y1 = coord(1,2);
x2 = coord(2,1);
y2 = coord(2,2);

L = sqrt( (x2-x1)^2 + (y2-y1)^2 );

theta = atan2(y2-y1,x2-x1);

Bmem = [-cos(theta) -sin(theta) cos(theta) sin(theta)];
