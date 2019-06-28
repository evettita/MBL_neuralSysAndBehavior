function [loomIDs] = loomID (L_Vs, loomDurations, initStimSize, finalStimSize,sr)

minTheta = deg2rad(initStimSize);
maxTheta = deg2rad(finalStimSize);
loomDurs = loomDurations / (sr/1000); %in ms
loomIDThresh = 25; %ms loom can be off from theoretical

loomIDs = nan(size(loomDurs));
modelLoomDur = nan(size(L_Vs));

for ii = 1:length(L_Vs)
    
    modelLoomDur (ii) = L_Vs(ii)/tan(minTheta/2) - L_Vs(ii)/tan(maxTheta/2);
    
    loomIDs(abs(loomDurs - modelLoomDur (ii)) < loomIDThresh) = L_Vs(ii);
   
end



    