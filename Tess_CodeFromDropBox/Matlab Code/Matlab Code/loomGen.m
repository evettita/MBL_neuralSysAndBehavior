
function [stimThetaVector] = loomGen (ellovervee, si, initStimSize, finalStimSize)

deg2rad = @(x) x*(pi/180);
rad2deg = @(x) x./(pi/180);
stimTimeStep = si*1e-6 / 1e-3; %si in us to ms
initStimSizeStr = initStimSize;

minTheta = deg2rad(initStimSize);
maxTheta = deg2rad(finalStimSize);
if minTheta <= 0
    error('make starting size greater than zero')
end
stimStartTime = ellovervee/tan(minTheta/2);
stimEndTime = ellovervee/tan(maxTheta/2);
stimTotalDuration = stimStartTime-stimEndTime;
stimTimeVector = fliplr(stimEndTime:stimTimeStep:stimStartTime);
stimThetaVector = 2 * atan(ellovervee./stimTimeVector);

