
clear all

% loop over to create the videos
missDegrees_list = [ 1.5, 3, 5, 10, 20];
%lv_list = [ 0.02, 0.02, 0.02, 0.02, 0.02, 0.04, 0.04, 0.04, 0.04];


%
for i = 1: length ( missDegrees_list )
  
% iPad and movie timing parameters
iPad_pixels_per_inch = 264; 
pixelsPerMeter = iPad_pixels_per_inch / .0254; % for 2.54 cm/inch
iPad_x_res = 2388;
iPad_y_res = 1668;

METERS_PER_INCH = 0.0254;
screenToFlyDist = 4.5 * METERS_PER_INCH; %8 inches converted to m

timeBeforeLoomStarts = 1;% sec
timeAfterLoomEnds = 1;% sec
frameRate = 120;

% Virtual object parameters
objectRadius = 0.01; % meters
LoverV = 0.01%lv_list(i);%0.04; % 
startDistance = 0.25; % meters

missDegrees = missDegrees_list(i); %0; % 0
missAngle = missDegrees * pi/ 180;

% Calculate projected object sizes
[X_C, X_L, X_R, alpha_c, alpha_L, alpha_R] = loomGen_thetaForVideoCreator(objectRadius, LoverV, startDistance, missAngle, screenToFlyDist, frameRate, pixelsPerMeter );

photoDiodeOn = zeros( 1, length( X_C ) );
photoDiodeOn(1) = 1;
photoDiodeOn(end) = 1;


XmaxAllowed = iPad_x_res;

%Add start period with initial object and end period with final object
X_C = addPaddingPeriodBeforeAndAfterLoom( X_C ,  timeBeforeLoomStarts , timeAfterLoomEnds , XmaxAllowed , frameRate );
X_L = addPaddingPeriodBeforeAndAfterLoom( X_L ,  timeBeforeLoomStarts , timeAfterLoomEnds , XmaxAllowed , frameRate );
X_R = addPaddingPeriodBeforeAndAfterLoom( X_R ,  timeBeforeLoomStarts , timeAfterLoomEnds , XmaxAllowed , frameRate );

% X_C = [ X_C(1)*ones( 1,  timeBeforeLoomStarts * frameRate ) X_C  X_C(end)*ones( 1,  timeAfterLoomEnds * frameRate ) ]; 
% X_L = [ X_L(1)*ones( 1,  timeBeforeLoomStarts * frameRate ) X_L  X_L(end)*ones( 1,  timeAfterLoomEnds * frameRate ) ]; 
% X_R = [ X_R(1)*ones( 1,  timeBeforeLoomStarts * frameRate ) X_R  X_R(end)*ones( 1,  timeAfterLoomEnds * frameRate ) ]; 
photoDiodeOn = [ zeros( 1,  timeBeforeLoomStarts * frameRate ) photoDiodeOn  zeros( 1,  timeAfterLoomEnds * frameRate ) ]; 
%
video_file = sprintf('nearMissLoom_%d_degrees_lv_%d', round(missDegrees) , LoverV );

%
createLoom(X_L, X_C, X_R, photoDiodeOn,   iPad_x_res, iPad_y_res,  video_file)

end

%% see if it's working
figure
plot(X_C)
hold on
plot(X_L, 'g')
plot(X_R, 'r')
%ylim([-100 100])

figure
plot(alpha_c*180/pi)

%%

function [ X_out ] = addPaddingPeriodBeforeAndAfterLoom ( X , timeBeforeLoomStarts , timeAfterLoomEnds , XmaxAllowed , frameRate)
%addPaddingPeriodBeforeAndAfterLoom  adds hold period with the same image
%at start and end of loom, also clips X values that are large than the max
%allowed

% add temporal padding
X = [ X(1)*ones( 1,  timeBeforeLoomStarts * frameRate ) X  X(end)*ones( 1,  timeAfterLoomEnds * frameRate ) ]; 


% make sure X does not exced +/-Xmax
X_out = X;
X_out(X_out > XmaxAllowed) = XmaxAllowed;
X_out(X_out < -XmaxAllowed) = -XmaxAllowed;
  

end

