% loomAnnotationScript
clear all

% Load data into matlab from Pclamp format

% add code Directory to matlab path
codeDirectory = '/Users/evettita/code/MBL_neuralSysAndBehavior/';
addpath ( genpath( codeDirectory ) )

% build path for the file to open
folderDirectory = '/Users/evettita/Dropbox (HMS)/MBL/PatchingData';
exptDate = '2019_07_11';
trialNum = '0017';

% MAC version file name to load into matlab MAC format
filename = [ folderDirectory '/' exptDate '_' trialNum '.abf' ];

% WINDOWS version file name to load into matlab MAC format
% filename = [ folderDirectory '\' exptDate '_' trialNum '.abf' ];


% Import data into matlab from .abf format
[abfData, sampInterval_us, header] = abf2load( filename ,'channels', 'a' );% all channels

% extract voltage channel
voltageTrace = abfData( : , 1);

%% copy in the data from excel sheet:


% data from excel sheet:
loomFrame1_ms = [10463.7304700000;32764.3808600000;55076.7617200000;77365.9531300000;99524.8515600000;121825.710900000;164160.390600000;186444.296900000;208728.718800000;231025.109400000;253305.265600000;275593.968800000]
loomFrame2_ms = [NaN;33239.7304700000;55552.9492200000;77841.2109400000;100000.109400000;122325.929700000;NaN;187407.265600000;209691.359400000;231983.281300000;254276.218800000;276601.343800000];
loomStimTypeNumber = [1:12];




%%

framePerSecond = (1/sampInterval_us)*1e6; % frames per second
framePerMiliSecond = (1/sampInterval_us)*1e3; % frames per ms


%define the important variables for this trial
loomFrame1 =  round ( loomFrame1_ms * framePerMiliSecond ); % in frames
loomFrame2 = round ( loomFrame2_ms * framePerMiliSecond );


PADDING_START_TIME = 1;% sec
paddingStartFrameNum = PADDING_START_TIME * framePerSecond;

PADDING_END_TIME =1;% sec
paddingEndFrameNum = PADDING_END_TIME * framePerSecond;
 
VIDEO_FRAMES_OF_ZERO_LOOM_Num1 = 60;% frames long loom
VIDEO_FRAMES_OF_ZERO_LOOM_Num7 = 120;% frames long loom
videoFrameRate = 120;
NUM_SAMPLES_ZERO_LOOM_Num1 = ( VIDEO_FRAMES_OF_ZERO_LOOM_Num1 / videoFrameRate ) * framePerSecond;
NUM_SAMPLES_ZERO_LOOM_Num7 = ( VIDEO_FRAMES_OF_ZERO_LOOM_Num7 / videoFrameRate ) * framePerSecond;

%%  loop over the whole pclamp trial extracting loom responses

dataLoomResp = struct;% initizlied the struct


for i = 1: length( loomFrame1 )
  dataLoomResp(i).loomNumber = loomStimTypeNumber(i);
  
  dataLoomResp(i).loomStartFrame = loomFrame1(i);
  
  
  % handle the cases where the is no end photodiode for zero looms
    if dataLoomResp(i).loomNumber == 1

       dataLoomResp(i).loomEndFrame = loomFrame1(i) + NUM_SAMPLES_ZERO_LOOM_Num1;  
    elseif dataLoomResp(i).loomNumber == 7

       dataLoomResp(i).loomEndFrame = loomFrame1(i) + NUM_SAMPLES_ZERO_LOOM_Num7;   
       
    else
      dataLoomResp(i).loomEndFrame = loomFrame2(i);  
    end
    

dataLoomResp(i).movieStartFrame = round ( dataLoomResp(i).loomStartFrame - paddingStartFrameNum );
dataLoomResp(i).movieEndFrame = round ( dataLoomResp(i).loomEndFrame + paddingEndFrameNum );

dataLoomResp(i).voltageResp = voltageTrace( dataLoomResp(i).movieStartFrame : dataLoomResp(i).movieEndFrame );
dataLoomResp(i).timeArray =  ( ( 1: length( dataLoomResp(i).voltageResp ))  - paddingStartFrameNum  )  / framePerSecond;  % todo move zero to start of the movie

dataLoomResp(i).loomRelativeStartTimeSec = 0;
dataLoomResp(i).loomRelativeEndTimeSec = ( dataLoomResp(i).loomEndFrame - dataLoomResp(i).loomStartFrame ) / framePerSecond ; 

end


%% Save struct
cycleString = '_cycle2';
fileName = [ '/Volumes/nsb/NSB_2019/03_Drosophila/Patching_team/' exptDate '_' trialNum cycleString '.mat' ];
save( fileName ,  'dataLoomResp' );




%% plotting testing  and finding spike rate
close all


for i =  1: length( dataLoomResp ) 
  
  figure('color', 'w');
  % pull out traces for all conditions where that loom was shown
  plot( dataLoomResp(i).timeArray,  dataLoomResp (i).voltageResp ); hold on;
  
  deltaVmResp(i) = findDeltaVmResponse(  dataLoomResp (i).voltageResp , dataLoomResp(i).timeArray  );
  
  TOP_OF_LINE_mV = -30;
  BOTTOM_OF_LINE_mV = -50;
  % Plot loom start and loom end
  plot(  [dataLoomResp(i).loomRelativeStartTimeSec, dataLoomResp(i).loomRelativeStartTimeSec], [BOTTOM_OF_LINE_mV, TOP_OF_LINE_mV]); 
  plot(  [dataLoomResp(i).loomRelativeEndTimeSec, dataLoomResp(i).loomRelativeEndTimeSec], [BOTTOM_OF_LINE_mV, TOP_OF_LINE_mV]); 

  niceaxes; box off
  title(['Loom type: ' num2str( dataLoomResp(i).loomNumber ) ]); 
  
end



 %% threshold for spike detection
fileName =  '/Volumes/nsb/NSB_2019/03_Drosophila/Patching_team/2019_07_11_0015_cell4_cycle1.mat';
load( fileName )
 
 dVdT_SPIKE_THRESHOLD = 0.1;  % change this value until the spikes are well detected, but other fluctuations are not
spikeData = struct;

for i =  1: length( dataLoomResp ) 


  % detect spikes
  [spikeData(i).spikeRaster, spikeData(i).spikeIndex, spikeData(i).spikeTimes] = detectSpikeTimes( dataLoomResp (i).voltageResp , dataLoomResp(i).timeArray , dVdT_SPIKE_THRESHOLD );
  
end

%% Save spikeTiming
spikeTimingFileName =  '/Volumes/nsb/NSB_2019/03_Drosophila/Patching_team/2019_07_11_0015_cell4_cycle1_spikeTimes.mat';
save( spikeTimingFileName ,  'spikeData' );



%% plot summary of delta Vm response
figure;
APPROACH_ANGLES = [ 0, 1.5, 3, 5, 10, 20, 0, 1.5, 3, 5, 10, 20 ];

scatter( APPROACH_ANGLES, deltaVmResp );


  
%%
function [ deltaVm ] = findDeltaVmResponse ( data , timeArray)

  baselineVoltage = mean( data( timeArray < 0)  ); % get baseline period
  
  peakVoltageResponse = max( data( timeArray > 0)  ); % get max voltage response
  
  deltaVm = peakVoltageResponse - baselineVoltage;
end








