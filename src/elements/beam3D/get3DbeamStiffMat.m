function Kmem = get3DbeamStiffMat(coord, prop)

% Compute stiffness matrix of 3D beam member
%
% Optional field prop.C: member end releases (see get3DbeamKloc,
% get3DbeamReleaseMatrix).

[B, L] = get3DbeamB(coord, prop);

if isfield(prop, 'C')
    K = get3DbeamKloc(L, prop, prop.C);
else
    K = get3DbeamKloc(L, prop);
end

Kmem = B'*K*B;
