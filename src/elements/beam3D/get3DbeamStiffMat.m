function Kmem = get3DbeamStiffMat(coord, prop)

% Compute stiffness matrix of 3D beam member

[B, L] = get3DbeamB(coord, prop);

K = get3DbeamKloc(L, prop);

Kmem = B'*K*B;
