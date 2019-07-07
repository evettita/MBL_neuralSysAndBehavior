% iPad parameters
iPad_pixels_per_inch = 264; 
pixpermeter = iPad_pixels_per_inch / .0254; % for 2.54 cm/inch
iPad_x_res = 2388;
iPad_y_res = 1668;
screenToFlyDist = 8 *0.0254; %8 inches to m
frameRate = 120;

% Virtual object parameters
objectRadius = 0.01;
LoverV = 0.04;
startDistance = 0.15;

missDegrees = 2; % 0
missAngle = missDegrees * pi/ 180;

% Calculate projected object sizes
[X_C, X_L, X_R, alpha_c, alpha_L, alpha_R] = loomGen_thetaForVideoCreator(objectRadius, LoverV, startDistance, missAngle, screenToFlyDist, frameRate, pixpermeter );

% Clip non-linearities when object bigger than x resolution of screen
% ind_clip = find(X_C > (iPad_x_res/2));
% if ~isempty(ind_clip)
%     X_C(ind_clip:end) = iPad_x_res/2;
% end
% ind_clip = find(X_C < (-iPad_x_res/2));
% if ~isempty(ind_clip)
%     X_C(ind_clip:end) = -iPad_x_res/2;
% end
% 
% ind_clip = find(X_L > (iPad_x_res/2));
% if ~isempty(ind_clip)
%     X_L(ind_clip:end) = iPad_x_res/2;
% end
% ind_clip = find(X_L < (-iPad_x_res/2));
% if ~isempty(ind_clip)
%     X_L(ind_clip:end) = -iPad_x_res/2;
% end
% 
% ind_clip = find(X_R > (iPad_x_res/2));
% if ~isempty(ind_clip)
%     X_R(ind_clip:end) = iPad_x_res/2;
% end
% ind_clip = find(X_R < (-iPad_x_res/2));
% if ~isempty(ind_clip)
%     X_R(ind_clip:end) = -iPad_x_res/2;
% end


video_file = sprintf('loom_%d_degrees', missDegrees);
createLoom(X_L, X_C, X_R, video_file)



% see if it's working
% figure
% plot(X_C)
% hold on
% plot(X_L, 'g')
% plot(X_R, 'r')
% %ylim([-100 100])
% 
% figure
% plot(alpha_c*180/pi)
