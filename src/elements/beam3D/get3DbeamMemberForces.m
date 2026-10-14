function Q = get3DbeamMemberForces(coord, prop, u)

% Basic forces Q = [N Mz1 Mz2 My1 My2 T]' of a 3D beam member from its 12 end
% displacements u (released components, prop.C, are zero).

[B, L] = get3DbeamB(coord, prop);

if isfield(prop, 'C')
    K = get3DbeamKloc(L, prop, prop.C);
else
    K = get3DbeamKloc(L, prop);
end

Q = K*(B*u(:));
