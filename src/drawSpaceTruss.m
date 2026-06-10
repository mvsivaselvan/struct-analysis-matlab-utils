function drawSpaceTruss(fignum, coord, connect, jtclr, memstyle, u, scale)
% Draw a space truss with interactive joint and member index display.
%
% INPUTS
%   fignum    - figure window number
%   coord     - [nJts x 3] joint coordinates (undeformed)
%   connect   - [nMem x 2] member connectivity (joint indices)
%   jtclr     - color for plotting joints (default: 'b')
%   memstyle  - line style for plotting members (default: 'b-')
%   u         - [nJts x 3] joint displacements (default: zeros)
%   scale     - displacement magnification scale (default: 1)
%
% INTERACTIVE FEATURES
%   Click any member line  -> shows "Member N" data tip at click point
%   Click any joint marker -> shows "Joint N"  data tip at that joint
%   (Uses MATLAB DataTipTemplate; requires R2019b or later)
%
% NOTES
%   The original function batched all members into one plot3 call using
%   linear indexing.  Interactive labeling requires each member and each
%   joint to be a separate graphics object, so members and joints are now
%   plotted in loops.  Visual output is otherwise identical.

% ── defaults ──────────────────────────────────────────────────────────────
if nargin <= 5                  % no displacements supplied
    if nargin == 3              % no formatting supplied either
        jtclr    = 'b';
        memstyle = 'b-';
    end
    u     = zeros(size(coord));
    scale = 1;
end

nJts = size(coord, 1);
nMem = size(connect, 1);

coorddef = coord + scale * u;   % deformed coordinates

% ── figure setup ──────────────────────────────────────────────────────────
figure(fignum);
clf;                            % clear so repeated calls don't accumulate
hold on;

% Enable the standard data-cursor mode so clicks register data tips
dcm = datacursormode(gcf);
set(dcm, 'Enable', 'on', 'DisplayStyle', 'datatip', ...
    'UpdateFcn', @dataTipCallback);

% ── plot members (one object each so each carries its own index) ───────────
hMem = gobjects(nMem, 1);
for m = 1 : nMem
    iA = connect(m, 1);
    iB = connect(m, 2);
    x  = [coorddef(iA, 1); coorddef(iB, 1)];
    y  = [coorddef(iA, 2); coorddef(iB, 2)];
    z  = [coorddef(iA, 3); coorddef(iB, 3)];

    hMem(m) = plot3(x, y, z, memstyle, 'LineWidth', 2);

    % Store the member index in UserData for retrieval by the callback
    hMem(m).UserData = struct('type', 'Member', 'index', m);
end

% ── plot joints (one object each) ─────────────────────────────────────────
hJt = gobjects(nJts, 1);
for j = 1 : nJts
    hJt(j) = plot3(coorddef(j,1), coorddef(j,2), coorddef(j,3), ...
                   'o', 'MarkerSize', 10, ...
                   'MarkerFaceColor', jtclr, ...
                   'MarkerEdgeColor', jtclr, ...
                   'LineStyle', 'none');

    hJt(j).UserData = struct('type', 'Joint', 'index', j);
end

hold off;

axis tight;
axis equal;
axis off;
view([-2 -1.5 1.5]);


end % drawSpaceTruss


% ── data-tip callback ──────────────────────────────────────────────────────
function txt = dataTipCallback(~, event)
% Called by datacursormode whenever the user clicks a graphics object.
% Returns the label shown in the data tip.

    h = event.Target;           % handle of the clicked object

    if isfield(h.UserData, 'type')
        txt = sprintf('%s: %d', h.UserData.type, h.UserData.index);
    else
        % Fallback: show raw coordinates for anything not tagged
        pos = event.Position;
        txt = sprintf('(%.3g, %.3g, %.3g)', pos(1), pos(2), pos(3));
    end
end
