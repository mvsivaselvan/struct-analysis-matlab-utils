function [B, L] = get3DbeamB(coord, prop)
% Compute "B" matrix for 3D beam element

% Compute rotation matrix
xtilde = (coord(2,:) - coord(1,:))';
L = norm(xtilde);
xtilde = xtilde/L;

if (1-abs(xtilde'*[0;0;1])>1e-8) 
    % member not vertical - orientation angle is from global Z axis
    ytilde = cross([0;0;1],xtilde);
    ytilde = ytilde/norm(ytilde);

    ztilde = cross(xtilde, ytilde);

    R1 = [xtilde ytilde ztilde];
    R2 = rodrigues(xtilde, prop.angle);
    R = R2*R1;
else 
    % member vertical - orientation angle is from global X axis
    s = sin(prop.angle);
    c = cos(prop.angle);
    R = [0 s -c; 0 c s; 1 0 0];
end

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
