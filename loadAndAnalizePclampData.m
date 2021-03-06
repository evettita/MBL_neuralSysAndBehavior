%% loadAndAnalizePclampData




%IMPORTANT: To use this code first replace the directory string varibles below to
%match your code's working directory (codeDirectory) and the directory
%where the data is stored ( folderDirectory )
clear all

% add code Directory to matlab path
codeDirectory = 'C:\Users\Wilson\Documents\GitHub\MBL_neuralSysAndBehavior\';
addpath ( genpath( codeDirectory ) )

% build path for the file to open
folderDirectory = 'C:\Users\Wilson\Documents\GitHub\MBL_neuralSysAndBehavior\';
cellFolderName = 'pClampDataSample';
exptDate = '2018_07_10';
trialNum = '0005';

% file name to load into matlab
filename = [ folderDirectory cellFolderName '\' exptDate '_' trialNum '.abf' ];


%% Import data into matlab from .abf format

% import data, different extra variables specify the formate of the data
% and which channels:
%[abfData, sampInterval_us, header] = abf2load( filename );
[abfData, sampInterval_us, header] = abf2load( filename ,'channels', 'a' );% all channels
%[abfData, sampInterval_us, header] = abf2load( filename , 'channels','a','start',0,'stop', 'e');



% channel number for voltage and current for current clamp recordings
VOLTAGE_CHANNEL = 1;
CURRENT_CHANNEL = 2;
MIRCO_SECONDS_PER_SECONDS = 1e6; % 1e6 micro seconds per second
sampRate = MIRCO_SECONDS_PER_SECONDS / ( sampInterval_us ); % Hz, should likely be 10kHz

% extract, Vm and I 
if( header.nOperationMode == 3) % Gap free recording mode    
data.voltage = abfData(: , VOLTAGE_CHANNEL);
data.current = abfData(: , CURRENT_CHANNEL);
data.timeArray = (( 1: length ( data.voltage(:,1) ) ) / sampRate)';
elseif( header.nOperationMode == 2)    % event-driven fixed-length mode
% Reduce Vm and I to 2D matrix
data.voltage = squeeze ( abfData(: , VOLTAGE_CHANNEL , :) );
data.current = squeeze ( abfData(: , CURRENT_CHANNEL, :) );
data.timeArray = (( 1: length ( data.voltage(:,1) ) ) / sampRate)';
    
elseif( header.nOperationMode == 5) % waveform fixed-length mode
% Reduce Vm and I to 2D matrix
data.voltage = squeeze ( abfData(: , VOLTAGE_CHANNEL , :) );
data.current = squeeze ( abfData(: , CURRENT_CHANNEL, :) );
data.timeArray = (( 1: length ( data.voltage(:,1) ) ) / sampRate)';

else
    error('ERROR: header.nOPerationMode is different than expected (3 or 5) please amend code to correctly process this data collection mode') 
end

%% Plot triall voltage and current
% TODO YVETTE  write nice plotting functionality here!
plot( data.timeArray, data.voltage)




%%  Find when the spikes occured using spike detection function

% obtain voltage trace/region of trace to detect spikes in
currentVoltageTrace = data.voltage(: ,3);

% threshold for spike detection
dVdT_SPIKE_THRESHOLD = 0.4;  % change this value until the spikes are well detected, but other fluctuations are not

% detect spikes
[spikeRaster, spikeIndex, spikeTimes] = detectSpikeTimes( currentVoltageTrace, data.timeArray , dVdT_SPIKE_THRESHOLD );




