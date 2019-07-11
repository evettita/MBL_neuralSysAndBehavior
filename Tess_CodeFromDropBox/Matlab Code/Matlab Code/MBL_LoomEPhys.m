
function MBL_LoomsEPhys(d, si, h, visStimCh)

sr = 1000000/si; %sampling rate in s, si is us per sample
LoverV = [10 20 40 80];
ILI = 10; % approx interloom interval in s

dataStart = 25000;
dataEnd = 50000;
baseline = 5000;

startStimSize = 10;
endStimSize = 180;

eventThresh = 0.34;
ILI_Thresh = sr*ILI;
diEventThresh = 1000; 

iEvent = find (d(:,visStimCh) < eventThresh);
diEvent = diff(iEvent);
iEventStart = iEvent(find(diEvent > diEventThresh)+1);
iEventEnd = iEvent(find(diEvent > diEventThresh));
diEventStart = diff(iEventStart);
diEventEnd = diff(iEventEnd);
iStartSwitch = iEventStart([(find(diEventStart > ILI_Thresh)+1)']);
iStartLoom = iEventEnd([(find(diEventEnd > ILI_Thresh)+2)']);
iEndLoom = iEventEnd ([(find(diEventEnd > ILI_Thresh)+3)']);
loomDur = (iEndLoom-iStartLoom);

[lv] = loomID (LoverV, loomDur, startStimSize, endStimSize,sr);



for ii = 1:length(LoverV)
    
    ePhysData{ii}.data = nan(sum(lv == LoverV(ii)), dataStart+dataEnd);
    ePhysData{ii}.count = 0;
    
    
    for jj = 1:length(lv)
        
        if lv(jj) == LoverV(ii)
            ePhysData{ii}.count = ePhysData{ii}.count+1;
            ePhysData{ii}.data(ePhysData{ii}.count,:) = d(iStartLoom(jj)-dataStart:iStartLoom(jj)+dataEnd-1,1);
            ePhysData{ii}.loom(ePhysData{ii}.count, :) = d(iStartLoom(jj)-dataStart:iStartLoom(jj)+dataEnd-1,visStimCh);
            ePhysData{ii}.loomOn(ePhysData{ii}.count) = iStartLoom(jj);
            
            ePhysData{ii}.block(ePhysData{ii}.count) = d(iStartLoom(jj), size(d,2));
            
            ePhysData{ii}.bslnAvg(ePhysData{ii}.count) = mean(d(iStartLoom(jj)-baseline:iStartLoom(jj)-1,1));
            %                 ePhysData{ii}.maxDepol(ePhysData{ii}.count) = max(d(iStartLoom(jj):iEndLoom(jj)+1000,1));
            ePhysData{ii}.maxDepol(ePhysData{ii}.count) = max(d(iEndLoom(jj)-1000:iEndLoom(jj)+1000,1));
            
            
        end
        
        
        Looms = nan(length(LoverV), dataStart+dataEnd);
        loomBlocks = nan(length(LoverV), dataStart+dataEnd);
        
        voltMax (ii) = max(ePhysData{ii}.data(:));
        voltMin (ii) = min(ePhysData{ii}.data(:));
        
        voltMeanMax (ii) = max(mean(ePhysData{ii}.data));
        voltMeanMin (ii) = min(mean(ePhysData{ii}.data));
        
    end
end

 
x_axis = (-1*dataStart:dataEnd-1)/sr;
yRange = [round(min(voltMeanMin),1)-0.1 round(max(voltMeanMax),1)+0.1];


Looms_Plot = (Looms./((endStimSize)/(yRange(2)-yRange(1)))) + yRange(1);



figure

for ll =1:length (LoverV)
    
    subplot (length(LoverV),1,ll)
    
    fill(x_axis, Looms_Plot(ll,:), [200 200 200]./255, 'LineStyle', 'none')
    hold on
    plot(x_axis,mean(ePhysData{ll}.data,1), 'color', 'k', 'LineWidth',1.5)
    axis tight
    ylim (yRange)
    ylabel ('V_m (mV)')
    box off
    
    
end




xlabel('Time (s)')
set(gcf, 'color', 'w','pos',[10 10 1200 600])


for mm = 1:length (LoverV)
    
    yRangeMulti = [min(round(min(voltMin)))-0.1 max(round(min(voltMin,1)))+10*size(ePhysData{mm}.loom,1)+3];
    Looms_Plot_Multi = (Looms./((endStimSize)/(yRangeMulti(2)-yRangeMulti(1)))) + yRangeMulti(1);
    LoomBlocks_Plot_Multi = (loomBlocks./((endStimSize)/(yRangeMulti(2)-yRangeMulti(1)))) + yRangeMulti(1);
    
    figure
    fill(x_axis, LoomBlocks_Plot_Multi(mm,:), [200 200 200]./255, 'LineStyle', 'none')
    hold on
    fill(x_axis, Looms_Plot_Multi(mm,:), [155 155 155]./255,'facealpha', 0.7,'LineStyle', 'none')
    hold on
    axis tight
    
    for nn = 1:size (ePhysData{mm}.data,1)
        plot (x_axis, ePhysData{mm}.data(nn,:)+ 10*(nn-1), 'color', 'k','LineWidth',1)
        hold on
        
    end

    ylim (yRangeMulti)
    xlabel('Time (s)')
    ylabel ('Membrane Potential (mV)')
    
end


end










