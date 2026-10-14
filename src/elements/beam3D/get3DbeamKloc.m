function K = get3DbeamKloc(L, prop, C)

% Compute local 6x6 stiffness matrix of 3D beam element
%
% Basic forces Q = [N Mz1 Mz2 My1 My2 T]', work-conjugate to the deformations
% q = B*u of get3DbeamB.
%
% Optional C (6 x r): member end releases, C'*Q = 0 (see get3DbeamReleaseMatrix).
% The basic forces are then Q = N*s, the columns of N spanning the null space of
% C', and the released end rotations lam are free: q = A*Q + C*lam. Since
% N'*C = 0, N'*q = (N'*A*N)*s, so the reduced flexibility is N'*A*N and
% K = N*inv(N'*A*N)*N'. This is the upper-left block of inv([A C; C' 0]); it is
% singular (rank 6 - r) because released deformations cost no energy.

A = get3DbeamFloc(L, prop);

if nargin < 3 || isempty(C)
    K = inv(A);
    return
end

if all(sum(C ~= 0, 1) == 1)
    % releases of single basic forces: select the unreleased ones (exact zeros)
    I = eye(6);
    N = I(:, ~any(C, 2));
else
    N = null(C');
end
K = N*((N'*A*N)\N');
