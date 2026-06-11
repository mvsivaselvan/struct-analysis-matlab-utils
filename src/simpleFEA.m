%% A simple code for linear finite element analysis

%% Input data
% Call the appropriate script containing input data
TwoDTrussInput;

%% Setup
% Code from this point onward does not depend on number of DOF per joint,
% number of joints per member, type of member etc. specific to input data,
% except a call to a function to compute the element stiffness matrix

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

%% Count and number DOF
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

%% Construct local-global DOF map
memDofNum = zeros(numMem, numDofPerMem); % an array to hold DOF numbers 
                                         % associated with elements
for m = 1:numMem
    for n = 1:numJtsPerMem
        memDofNum(m,(n-1)*numDofPerJt+1:n*numDofPerJt) = ...
                                               jtDofNum(connect(m,n),:);
    end
end

%% Load vector
% load vector at the free DOF (is there a better way ??)
Pfree = zeros(numFreeDof,1);
for m = 1:numJts
    for n = 1:numDofPerJt
        if (jtDofNum(m,n) > 0)
            Pfree(jtDofNum(m,n)) = P(m,n);
        end
    end
end

%% Assembly
% Stiffness matrix and element-wise parts of load vector
K = zeros(numFreeDof); 
for m = 1:numMem
    % Element-specific code
    Kmem = get2DtrussStiffMat(coord(connect(m,:),:), E, area(m));
    
    % plug it into the right place in the stiffness matrix K
    maskActiveDof = memDofNum(m,:) > 0;
    indexActiveDof = memDofNum(m,maskActiveDof);
    
    K(indexActiveDof,indexActiveDof) = K(indexActiveDof,indexActiveDof)+...
        Kmem(maskActiveDof,maskActiveDof);
end

%% Solve
ufree = K\Pfree;

%% Post-processing
% all displacements
u = zeros(size(bcs));
for m = 1:numJts
    for n = 1:numDofPerJt
        if (jtDofNum(m,n) > 0)
            u(m,n) = ufree(jtDofNum(m,n));
        end
    end
end

% all element internal forces
F = zeros(numMem,1);
for m = 1:numMem
    maskActiveDof = memDofNum(m,:) > 0;
    indexActiveDof = memDofNum(m,maskActiveDof);
    
    umem = zeros(numDofPerMem,1);
    umem(maskActiveDof) = ufree(indexActiveDof);
    
    % Element-specific code
    F(m) = get2DtrussMemberForce(coord(connect(m,:),:), E, area(m), umem);
end