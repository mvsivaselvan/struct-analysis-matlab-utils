function [K, M, jtDofNum, memDofNum] = getStiffAndMassMatrices(coord, connect, bcs, props, mass)
numJts = size(coord,1); % Total number of joints in the model
% The following is an example of an integrity check on the input data,
% however, no more such checks are done in the following. It is assumed
% that the input data is consistent.
if (numJts ~= size(bcs,1))
    fprintf('Error: number of coord must equal number of boundary cond\n')
    return
end

numMem = size(connect,1); % Total number of members in the model

numDofPerJt = size(bcs,2); % Number of DOF per node.

numJtsPerMem = size(connect,2); % Number of nodes per element

numDofPerMem = numJtsPerMem * numDofPerJt; % Number of DOF associated with
                                           % an element

% Count and number DOF
numFreeDof = 0;
jtDofNum = zeros(size(bcs)); % an array to hold the joint DOF numbers
for m = 1:numJts
    for n = 1:numDofPerJt
        if (bcs(m,n) == 0) % i.e. a free DOF
            numFreeDof = numFreeDof + 1;
            jtDofNum(m,n) = numFreeDof;
        end
    end
end

% Construct local-global DOF map
memDofNum = zeros(numMem, numDofPerMem); % an array to hold DOF numbers 
                                         % associated with elements
for m = 1:numMem
    for n = 1:numJtsPerMem
        memDofNum(m,(n-1)*numDofPerJt+1:n*numDofPerJt) = ...
                                               jtDofNum(connect(m,n),:);
    end
end

% Assembly
% Stiffness matrix and element-wise parts of load vector
K = zeros(numFreeDof); 
M = zeros(numFreeDof);
for m = 1:numMem
    % Element-specific code
    if m == 1
        % keyboard
    end
    Kmem = get3DbeamStiffMat(coord(connect(m,:),:), props(m));
    if any(any(isnan(Kmem)))
        keyboard
    end
    Mmem = get3DbeamMassMat(coord(connect(m,:),:), props(m));
    
    % plug it into the right place in the stiffness matrix K
    maskActiveDof = memDofNum(m,:) > 0;
    indexActiveDof = memDofNum(m,maskActiveDof);
    
    K(indexActiveDof,indexActiveDof) = K(indexActiveDof,indexActiveDof)+...
        Kmem(maskActiveDof,maskActiveDof);
    M(indexActiveDof,indexActiveDof) = M(indexActiveDof,indexActiveDof)+...
        Mmem(maskActiveDof,maskActiveDof);
end

% Add joint mass contribution to mass matrix
for n = 1:numJts
    for ndof = 1:3
        dofnum = jtDofNum(n,ndof);
        if dofnum > 0
            M(dofnum,dofnum) = M(dofnum,dofnum) + mass(n, ndof);
        end
    end
end
