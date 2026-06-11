function R = rodrigues(u, thet)

% Rotation matrix corresponding to a rotation of thet about unit vector u
% Compute expm(thet*hat(u)) using Rodrigues' formula

hatu = hat(u);
R = eye(3) + sin(thet)*hatu + (1-cos(thet))*hatu^2;
