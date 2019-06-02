
function My_LoomsEPhys(d, si, h, visStimCh)

sr = 1000000/si; %sampling rate in s, si is us per sample

dataStart = 10000;
dataEnd = 30000;
baseline = 5000;

LoverV = [10 40 70 100 130];
% LoverV = [10];
startStimSize = 5;
endStimSize = 90;
LoomHold = 20115;

loomHiThresh = 1.6; %1.6
loomLoThresh = 1.275; %1.15

holdHiThresh = 1.01; %1.01
holdLoThresh = 0.98; %0.98

ILI_Thresh = 45000; % Inter-Loom Interval
LoomDur_Thresh = 30000;
HoldDur_Thresh = 18000;
StimDur_Thresh = 48000;
HoldMean_Thresh = 1.5;

iLoomOn = find (d(:,visStimCh) > loomLoThresh);
diLoomOn = diff(iLoomOn);
iStartLoom = iLoomOn([1 (find(diLoomOn > ILI_Thresh)+1)']);
iStartLoom = iStartLoom(1:end-1);

% iLoomOff = find (d(:,visStimCh) > loomLoThresh & d(:,visStimCh) < loomHiThresh);
% diLoomOff = diff(iLoomOff);
iEndLoom = iLoomOn(diLoomOn > ILI_Thresh);

iHoldOff = find (d(:,visStimCh) > holdLoThresh & d(:,visStimCh) < holdHiThresh);
diHoldOff = diff(iHoldOff);
iEndHold = iHoldOff(find(diHoldOff > ILI_Thresh));

loomDur = (iEndLoom-iStartLoom);
% notLoom = find(loomDur > LoomDur_Thresh);
% loomDur(notLoom) = [];
% iStartLoom(notLoom) = [];

for tt = 1:length(iStartLoom)
    if iEndLoom(tt) - LoomHold > 0
        HoldMeans(tt) = mean(d(iEndLoom(tt)-LoomHold:iEndLoom(tt),visStimCh));
    else
        HoldMeans(tt) = mean(d(1:iEndLoom(tt)));
    end
    
    NotLooms = find(HoldMeans > HoldMean_Thresh);
end

iStartLoom(NotLooms) = [];
iEndLoom(NotLooms) = [];
iEndHold(NotLooms) = [];
loomDur(NotLooms) = [];

[lv] = loomID (LoverV, loomDur, startStimSize, endStimSize);

[loomISI, loomFirstInBout, iBoutStart] = isiID(iStartLoom, iEndLoom, LoomHold, si);

% stimDur = (iEndHold-iStartLoom);
% notStim = find(loomDur > StimDur_Thresh);
% stimDur(notStim) = [];

% holdDur = (iEndHold-iEndLoom);
% notHold = find (holdDur < 19000);
% holdDur(notHold) = [];

% LoomHold = ceil(mean(holdDur));

if sum(loomFirstInBout) ~= 0
    
    for ii = 1:length(LoverV)
        
        ePhysData{ii}.data = nan(sum(lv == LoverV(ii)), dataStart+dataEnd);
        ePhysData{ii}.count = 0;
        
        
        for jj = 1:length(lv)
            
            if lv(jj) == LoverV(ii)
                ePhysData{ii}.count = ePhysData{ii}.count+1;
                ePhysData{ii}.data(ePhysData{ii}.count,:) = d(iStartLoom(jj)-dataStart:iStartLoom(jj)+dataEnd-1,1);
                ePhysData{ii}.loom(ePhysData{ii}.count, :) = d(iStartLoom(jj)-dataStart:iStartLoom(jj)+dataEnd-1,visStimCh);
                ePhysData{ii}.loomOn(ePhysData{ii}.count) = iStartLoom(jj);
                ePhysData{ii}.loomISI(ePhysData{ii}.count) = loomISI(jj);
                ePhysData{ii}.block(ePhysData{ii}.count) = d(iStartLoom(jj), size(d,2));
                ePhysData{ii}.loomFirstInBout(ePhysData{ii}.count) = loomFirstInBout(jj);
                ePhysData{ii}.bslnAvg(ePhysData{ii}.count) = mean(d(iStartLoom(jj)-baseline:iStartLoom(jj)-1,1));
%                 ePhysData{ii}.maxDepol(ePhysData{ii}.count) = max(d(iStartLoom(jj):iEndLoom(jj)+1000,1));
ePhysData{ii}.maxDepol(ePhysData{ii}.count) = max(d(iEndLoom(jj)-1000:iEndLoom(jj)+1000,1));
                
                
            end
            
        end
        
        for ss = 2:length(ePhysData{ii}.loomFirstInBout)
            if ePhysData{ii}.loomFirstInBout(ss) ~= 0 && ePhysData{ii}.loomFirstInBout (ss-1) ~= 0
                ePhysData{ii}.loomFirstInBout(ss) = NaN;
            end
        end
        ePhysData{1}.loomFirstInBout(isnan(ePhysData{1}.loomFirstInBout)) = 0;
        
        voltMax (ii) = max(ePhysData{ii}.data(:));
        voltMin (ii) = min(ePhysData{ii}.data(:));
        
        voltMeanMax (ii) = max(mean(ePhysData{ii}.data));
        voltMeanMin (ii) = min(mean(ePhysData{ii}.data));
        
    end
    
    Looms = nan(length(LoverV), dataStart+dataEnd);
    loomBlocks = nan(length(LoverV), dataStart+dataEnd);
    
    for kk = 1:length(LoverV)
        LoomTrace {kk} = loomGen (LoverV(kk), si, startStimSize, endStimSize);
        
        if length(LoomTrace {kk}) + LoomHold < dataEnd
            Looms (kk,:) = [zeros(1, dataStart) rad2deg(LoomTrace{kk}) 90*ones(1, LoomHold) zeros(1,(dataEnd-LoomHold-length(LoomTrace{kk})))];
            
        else
            Looms (kk,:) = [zeros(1, dataStart) rad2deg(LoomTrace{kk}) 90*ones(1, dataEnd-1 - ceil(length(LoomTrace{kk}))) 0];
        end
        
        loomBlocks (kk,:) = [zeros(1, dataStart) 90*ones(1,length(LoomTrace{kk})) zeros(1,(dataEnd-length(LoomTrace{kk})))];
        
    end
    
    x_axis = (-1*dataStart:dataEnd-1)/10000;
    colorPal = [172 234 35; 179 72 21; 116 49 169; 74 120 219; 46 168 204];
    yRange = [round(min(voltMeanMin),1)-0.1 round(max(voltMeanMax),1)+0.1];
    
    % yRangeMulti = [-60 100];
    
    Looms_Plot = (Looms./((endStimSize)/(yRange(2)-yRange(1)))) + yRange(1);
    
    
    figure
    
    for ll =1:length (LoverV)
        
        subplot (length(LoverV),1,ll)
        
        fill(x_axis, Looms_Plot(ll,:), [200 200 200]./255, 'LineStyle', 'none')
        hold on
        plot(x_axis,mean(ePhysData{ll}.data,1), 'color', colorPal(ll,:)./255, 'LineWidth',1.5)
        axis tight
        ylim (yRange)
        ylabel ('V_m (mV)')
        box off
        
        
    end
    
    xlabel('Time (s)')
    set(gcf, 'color', 'w','pos',[10 10 1200 600])
    
    
    % figure
    %
    % for mm = 1:length(LoverV)
    %
    %     subplot (length(LoverV)+1,1,mm)
    %
    %     plot (x_axis, ePhysData{mm}.data((randi([1, size(ePhysData{mm}.data,1)],1, 10)),:), 'color', [234 234 234]./255)
    % % plot (x_axis, ePhysData{mm}.data, 'color', [234 234 234]./255)
    %     hold on
    %     plot(x_axis,mean(ePhysData{mm}.data,1), 'color', colorPal(mm,:)./255, 'LineWidth', 2)
    %    axis tight
    %    ylabel ('V_m (mV)')
    %
    % end
    %
    % subplot (6,1,6)
    % for ll = 1:length(LoverV)
    % plot (x_axis, Looms(ll,:), 'color', colorPal(ll,:)./256,'LineWidth',2)
    % hold on
    % end
    % axis tight
    % xlabel('Time (ms)')
    % ylabel ('Stim Size (deg)')
    %
    % set(gcf, 'color', 'w','pos',[10 10 1200 600])
    %
    % for mm = 1:length (LoverV)
    % figure
    %    for nn = 1:size (ePhysData{mm}.loom,1)
    %    plot (x_axis, ePhysData{mm}.loom(nn,:)+ 2*(nn-1), 'color', [234 234 234]./255)
    %    hold on
    %    end
    % end
    
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
            
            if ismember(ePhysData{mm}.loomISI(nn),[5 15 30])
                if ePhysData{mm}.loomISI(nn) == 5
                    c = [236 166 0]./255;
                elseif ePhysData{mm}.loomISI(nn) == 15
                    c = [17 159 112]./255;
                elseif ePhysData{mm}.loomISI(nn) == 30
                    %                c = [25 70 191]./255;
                    c = 'k';
                end
                %        else error('Tess, new ISI')
            end
            %          if ePhysData{1,1}.loomFirstInBout(nn) == 1
            %              lw = 2.5;
            %          else lw = 1;
            %          end
            plot (x_axis, ePhysData{mm}.data(nn,:)+ 10*(nn-1), 'color', c,'LineWidth',1)
            hold on
            
            if ePhysData{1,mm}.loomFirstInBout(nn) ~= 0
                txt = sprintf('New Block: %d min from start', round(((h{ePhysData{mm}.block(nn)}.uFileStartTimeMS-h{ePhysData{1}.block(1)}.uFileStartTimeMS)/(1000*60))));
                text (min(x_axis),ePhysData{mm}.data(nn,1)+ 10*(nn-1)-2,txt,'FontSize',12,'FontWeight','bold')
            end
        end
        ylim (yRangeMulti)
        xlabel('Time (s)')
        ylabel ('Membrane Potential (mV)')
        
        colorChoice = colorPal(mm,:)./255;
% colorChoice = 'k';
    
    x_axis_scatter = (1:length(ePhysData{mm}.maxDepol))/2;
    figure(100); scatter(x_axis_scatter,ePhysData{mm}.bslnAvg,[], colorChoice, 'filled')
    hold on
    xlabel('Time (min)')
    ylabel('Baseline (mV)')
    figure(101); scatter(x_axis_scatter,ePhysData{mm}.maxDepol - ePhysData{mm}.bslnAvg,[], colorChoice, 'filled')
    hold on
    xlabel('Time (min)')
    ylabel('Peak (mV)')
    figure(102); scatter(ePhysData{mm}.bslnAvg,ePhysData{mm}.maxDepol-ePhysData{mm}.bslnAvg,[], colorChoice, 'filled')
    hold on
    xlabel('Baseline (mV)')
    ylabel('Peak (mV)')
    end
    
    
end










