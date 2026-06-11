function [B, L] = get3DbeamB(coord)
% Compute "B" matrix for 3D beam element

% Compute rotation matrix
xtilde = (coord(2,:) - coord(1,:))';
L = norm(xtilde);
xtilde = xtilde/L;

ytilde = cross([1;0;0],xtilde);
ytilde = ytilde/norm(ytilde);

ztilde = cross(xtilde, ytilde);

R1 = [xtilde ytilde ztilde];

R2 = rodrigues(xtilde, prop.angle);

R = R2*R1;
R = blkdiag(R,R,R,R);

% Compute corot transformation
T = zeros(12,6);
T(1,1) = -1;
T(7,1) = 1;
T(2,2:3) = 1/L;
T(8,2:3) = -1/L;
T(3,4:5) = -1/L;
T(9,4:5) = 1/L;
T(4,6) = -1;
T(10,6) = 1;
T(5,4) = 1;
T(11,5) = 1;
T(6,2) = 1;
T(12,3) = 1;

B = T'*R';
