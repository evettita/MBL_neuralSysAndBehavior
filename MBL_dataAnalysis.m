

% Process the data for a particular date folder that only contains loom
% stimuli
datadir = 'C:\Users\Administrator\NSandB_DrosophilaEphy_Data\';
addpath(genpath(datadir));

% construct file name from trial number and date to match pClamp formate
dateFolderName = '20190703_csChrTrials';

cd( [datadir '/' dateFolderName ] );
% check if processed data does not already exist
if( ~isfile('d.mat') )
% convert pClamp data into matlab variables
abfConvert( [datadir '/' dateFolderName ] );

end

%% Analize looms from matlab data in the loom folder

AnalysisMode = 'csChr'; % loom vs csChr

PHOTODIODE_THRESHOLD = 0.34;% Volts
MBL_EPhys(   [datadir '\' dateFolderName ] , AnalysisMode );




