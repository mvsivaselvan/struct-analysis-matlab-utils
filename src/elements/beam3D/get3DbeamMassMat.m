function Mmem = get3DbeamMassMat(~, prop)

% Diagonal mass matrix of 3D beam element

Mmem = diag([1 1 1 0 0 0 1 1 1 0 0 0])*prop.memMass/2;