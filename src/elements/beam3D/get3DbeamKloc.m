function K = get3DbeamKloc(L, prop)

% Compute local 6x6 stiffness matrix of 3D beam element

% flexibility matrix for bending in the XY plane (moments about Z axis)
a1 = L/(3*prop.EIZZ)+1/(prop.GAY*L);
a2 = -L/(6*prop.EIZZ)+1/(prop.GAY*L);
AXY = [a1 a2; a2 a1];

% flexibility matrix for bending in the XZ plane (moments about Y axis)
a1 = L/(3*prop.EIYY)+1/(prop.GAZ*L);
a2 = -L/(6*prop.EIYY)+1/(prop.GAZ*L);
AXZ = [a1 a2; a2 a1];

K = zeros(6); % local 6x6 stiffness matrix
K(1,1) = prop.EAX/L;
K(2:3,2:3) = inv(AXY);
K(4:5,4:5) = inv(AXZ);
K(6,6) = prop.GJ/L;
