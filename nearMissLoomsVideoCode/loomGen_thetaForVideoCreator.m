
function [X_C, X_L, X_R, alpha_c, alpha_L, alpha_R] = loomGen_thetaForVideoCreator (objectRadius, LoverV, startDistance, missAngle, screenToFlyDist, frameRate, pixpermeter );

D = startDistance;  % in meters
theta = missAngle;  % in radians
l = objectRadius;   % in meters
lv = LoverV;        % in seconds
Fr = frameRate;     % in frames/sec, Hz
dscreen = screenToFlyDist;  % in meters

X_max = D / cos(theta);
f_max = floor(X_max * lv * Fr / l); % take closest frame before reaching X_max

for f = 1:f_max
    
    X(f) = (l / lv)*(f / Fr); %distance traveled along path of virtual object movement
    
    numer = l * sin(theta) * f;
    denom = lv * Fr * D - (l * f * cos(theta)); 
       
    alpha_c(f) = atan2( numer , denom );
    
    numer = l * cos(alpha_c(f));
    denom = D - X(f) * cos(theta);
    
    alpha_L(f) = atan2 (numer , denom );
    alpha_R(f) = alpha_L(f);
    
%     [f, alpha_c(f), alpha_L(f), alpha_R(f)]
    
    x_c = dscreen * tan(alpha_c(f));
    x_l = dscreen * tan(alpha_c(f) - alpha_L(f));
    x_r = dscreen * tan(alpha_c(f) + alpha_R(f));
    
    if x_r < x_l
      continue
    end
    
    X_C(f) = x_c
    X_L(f) = x_l
    X_R(f) = x_r

end

X_C = X_C * pixpermeter;
X_L = X_L * pixpermeter;
X_R = X_R * pixpermeter;

