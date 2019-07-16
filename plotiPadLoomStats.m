%plotiPadLoomStat

frameRate = 120;

%plot loom stats
for j = 1: length( loomStats )
  figure('color', 'w' );
  

  % calculate time array in seconds
  timeArraySec = [];% intialize timearray
  timeArraySec = (1: length( loomStats(j).objectSize_degrees )) / frameRate;
  
  %plot object size
  subplot(3, 1, 1)

  
  plot( timeArraySec, loomStats(j).objectSize_degrees );
  ylabel('object Size (deg)');
  xlabel('frame');
  box off; niceaxes
  title( ['object size over time, approachAngle: ' num2str(loomStats(j).approachAngle) ', lv: ' num2str( loomStats(j).lv ) ]);  

    
  %plot object postion in degrees
  subplot(3, 1, 2)
  plot( timeArraySec, loomStats(j).objectPositionFromMidline_degrees );
  ylabel('object position (deg)');
  xlabel('frame');
  box off; niceaxes
  title( ['object position over time, approachAngle: ' num2str(loomStats(j).approachAngle) ', lv: ' num2str( loomStats(j).lv ) ]);  

    %plot object distance over time in meters (?) 
  subplot(3, 1, 3)
  plot( timeArraySec,  loomStats(j).objectDistanceFromFly );
  ylabel('object distance (meters?)');
  xlabel('frame');
  box off; niceaxes
  title( ['object distance over time, approachAngle: ' num2str(loomStats(j).approachAngle) ', lv: ' num2str( loomStats(j).lv ) ]);  
  
end