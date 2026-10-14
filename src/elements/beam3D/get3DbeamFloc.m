function A = get3DbeamFloc(L, prop)

% Compute local 6x6 flexibility matrix of 3D beam element (q = A*Q), including
% shear deformation. Basic forces Q = [N Mz1 Mz2 My1 My2 T]'.

% flexibility matrix for bending in the XY plane (moments about Z axis)
a1 = L/(3*prop.EIZZ)+1/(prop.GAY*L);
a2 = -L/(6*prop.EIZZ)+1/(prop.GAY*L);
AXY = [a1 a2; a2 a1];

% flexibility matrix for bending in the XZ plane (moments about Y axis)
a1 = L/(3*prop.EIYY)+1/(prop.GAZ*L);
a2 = -L/(6*prop.EIYY)+1/(prop.GAZ*L);
AXZ = [a1 a2; a2 a1];

A = zeros(6);
A(1,1) = L/prop.EAX;
A(2:3,2:3) = AXY;
A(4:5,4:5) = AXZ;
A(6,6) = L/prop.GJ;
