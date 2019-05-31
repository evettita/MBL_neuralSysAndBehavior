%% loadAndAnalizePclampData

% build path for the file to open
folderDirectory = '/Users/evettita/Desktop/Data/';
cellFolderName = '20180710-cell2-starved-UASmCD8GFPcyoDh44Tm2';
exptDate = '2018_07_10';
trialNum = '0009';

% file name to load into matlab
filename = [ folderDirectory cellFolderName '/' exptDate '_' trialNum '.abf' ];

%% Import data into matlab from .abf format
% import data
[data, sampInterval_us, header] = abf2load( filename );

% channel number for voltage and current for current clamp recordings
VOLTAGE_CHANNEL = 1;
CURRENT_CHANNEL = 2;
MIRCO_SECONDS_PER_SECONDS = 1e6; % 1e6 micro seconds per second
sampRate = MIRCO_SECONDS_PER_SECONDS / ( sampInterval_us ); % Hz, should likely be 10kHz

% extract, Vm and I and reduce to 2D matrix
voltage = squeeze ( abfData(: , VOLTAGE_CHANNEL , :) );
current = squeeze ( abfData(: , CURRENT_CHANNEL, :) );
timeArray = ( 1: length ( voltage(:,1) ) ) / sampRate;

%%  Find when the spikes occured using spike detection function

% obtain voltage trace/region of trace to detect spikes in
currentVoltageTrace = voltage(: , 1);

% threshold for spike detection
dVdT_SPIKE_THRESHOLD = 0.4;  % change this value until the spikes are well detected, but other fluctuations are not

% detect spikes
[spikeRaster, spikeIndex, spikeTimes] = detectSpikeTimes( currentVoltageTrace, timeArray , dVdT_SPIKE_THRESHOLD );


%% Possibly things TODO: 
% - thickness of fat spikes,  before /after Cd . (histogram?)
% - interspike interval (histogram, to look at clustering)
% - thickness of thin/short spikes
% ...


