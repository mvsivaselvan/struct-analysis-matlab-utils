function u = assignDisplacementsToJoints(uvec, jtDofNum)

% Assign displacements from a solution vector uvec to a (#jointsx3) matrix,
% u, corresponding to jtDofNum

numJts = size(jtDofNum,1); 
numDofPerJt = size(jtDofNum,2);
u = zeros(numJts, numDofPerJt);
for m = 1:numJts
    for n = 1:numDofPerJt
        if (jtDofNum(m,n) > 0)
            u(m,n) = uvec(jtDofNum(m,n));
        end
    end
end