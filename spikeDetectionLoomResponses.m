 %% Spike detection script

 
fileName =  '/Volumes/nsb/NSB_2019/03_Drosophila/Patching_team/2019_07_11_0017_cell5_cycle1';
fullFileName = [ fileName '.mat'];
load( fullFileName )
 
dVdT_SPIKE_THRESHOLD = 0.1;  % change this value until the spikes are well detected, but other fluctuations are not
spikeData = struct;

close all
for i =  1: length( dataLoomResp ) 


  % detect spikes
  [spikeData(i).spikeRaster, spikeData(i).spikeIndex, spikeData(i).spikeTimes] = detectSpikeTimes( dataLoomResp (i).voltageResp , dataLoomResp(i).timeArray , dVdT_SPIKE_THRESHOLD );
  
end

%% Save spikeTiming
spikeTimingFileName = [ fileName '_spikeTimes.mat' ];
save( spikeTimingFileName ,  'spikeData' );
