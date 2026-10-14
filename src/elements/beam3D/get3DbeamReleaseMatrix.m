function C = get3DbeamReleaseMatrix(end1, end2)

% Release matrix C (6 x r) for get3DbeamKloc: one unit column per released
% basic force of Q = [N Mz1 Mz2 My1 My2 T]'.
%
% end1, end2: cell arrays of released components at member end 1 and end 2,
% any of 'My', 'Mz', 'T' (local member axes), e.g.
%     C = get3DbeamReleaseMatrix({'My','Mz','T'}, {})   % hinge at end 1
% Returns [] if nothing is released.
%
% If every member end at a joint is a full hinge, the joint rotations are
% coupled to nothing: restrain them (bcs) to keep the stiffness matrix
% nonsingular.

idx = [];
comps = {end1, end2};
for e = 1:2
    for k = 1:numel(comps{e})
        switch comps{e}{k}
            case 'Mz'
                idx(end+1) = 1 + e;     % Mz1 = 2, Mz2 = 3
            case 'My'
                idx(end+1) = 3 + e;     % My1 = 4, My2 = 5
            case 'T'
                idx(end+1) = 6;
            otherwise
                error('get3DbeamReleaseMatrix: unknown component %s', comps{e}{k});
        end
    end
end
idx = unique(idx);
if isempty(idx)
    C = [];
else
    I = eye(6);
    C = I(:, idx);
end
