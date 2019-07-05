

function  My_csChrEPhysObjective(d, sf, pulseGenCh, dataStart, dataEnd)


pulseOn = find(d(:,pulseGenCh) > 2);
pulseStart = find(diff(pulseOn)>5)'+1;
pulseStart = [1 pulseStart];
pulseLength = round(unique(diff(pulseStart)),-2); % Tess fix this!
pulseLengthsPulse = diff(pulseStart);
pulseLengthsPulse = [pulseLengthsPulse pulseLengthsPulse(end)];

for mm = 1:length(pulseLength)
    iPulseLength{mm} = find(pulseLength (mm) == pulseLengthsPulse);
    dataPulse{mm} = nan(length(iPulseLength{mm}),dataStart+dataEnd);
    dataPulseNorm{mm} = nan(length(iPulseLength{mm}),dataStart+dataEnd);
    pulseShape{mm} = nan(length(iPulseLength{mm}),dataStart+dataEnd);
    
    count = 0;
    
    for ii = 1:length(pulseLengthsPulse)
        if pulseLength (mm) == pulseLengthsPulse(ii)
            count = count +1;
            dataPulse{mm}(count,:) = d((pulseOn(pulseStart(ii))-dataStart):(pulseOn(pulseStart(ii))+dataEnd)-1,1);
            baseline{mm}(count) = mean(d((pulseOn(pulseStart(ii))-dataStart):(pulseOn(pulseStart(ii))-1),1));
            dataPulseNorm{mm}(count,:) = dataPulse{mm}(count,:)-baseline{mm}(count);
            pulseShape{mm}(count,:) = d((pulseOn(pulseStart(ii))-dataStart):(pulseOn(pulseStart(ii))+dataEnd)-1,pulseGenCh);
        end
    end
    
    stdPulseNorm{mm} = std(dataPulseNorm{mm});
    x_axis = ((1:length(dataPulse{mm}))-dataStart)/sf;
    x_laser = ([dataStart dataStart+pulseLength(mm) dataStart+pulseLength(mm) dataStart]-dataStart)./sf;
    y_lim = [-2 ceil(max(max(dataPulseNorm{mm})) + 2)];
    y_lim = [-2 15];
    y_laser = [y_lim(1) y_lim(1) y_lim(2) y_lim(2)];
    y_laser_All = [y_lim(1) y_lim(1) size(dataPulse{mm},1)*y_lim(2) size(dataPulse{mm},1)*y_lim(2)];
    
    % pulseNorm48 = load ('Z:\Tess\EPhysData\20181008\OL0048B\dataPulseNorm_48B.mat');
    % stdPulseNorm48 = load ('Z:\Tess\EPhysData\20181008\OL0048B\stdPulseNorm_48B.mat');
    
%     figure
%     fill(x_laser,y_laser,[255/255, 216/255, 101/255],'LineStyle','none')
%     hold on
%     % My_errorbar(x_axis,mean(pulseNorm48.dataPulseNorm,1),stdPulseNorm48.stdPulseNorm,3)
%     My_errorbar(x_axis, mean(dataPulseNorm{mm},1),stdPulseNorm{mm},3)
%     ylim([y_lim(1) max(stdPulseNorm{mm} + ceil((mean(dataPulseNorm{mm})))+1)])
%     xlabel('Time (ms)')
%     ylabel('Membrane Potential (mV)')
    % axis tight
    
    figure (100 + pulseLength(mm) + 2)
    set(gcf, 'Color', 'w');
    
%     fill(x_laser,y_laser,[255/255, 216/255, 101/255],'LineStyle','none')
    hold on
%     plot(x_axis,dataPulseNorm{mm}','color',[250/255, 193/255, 195/255])
    plot(x_axis,dataPulseNorm{mm}','color',[200/255, 200/255, 200/255])
% plot(x_axis,dataPulseNorm{mm}','color',[103/255, 103/255, 183/255])
    hold on
%     plot (x_axis,mean(dataPulseNorm{mm},1),'color',[225/255, 22/255, 40/255],'LineWidth',2.5)
    plot (x_axis,mean(dataPulseNorm{mm},1),'color','k','LineWidth',2.5)
% plot (x_axis,mean(dataPulseNorm{mm},1),'color',[51/255, 51/255, 188/255],'LineWidth',2.5)
    ylim(y_lim)
    xlabel('Time (ms)')
    ylabel('Membrane Potential (mV)')
    axis tight
    box off
    
    figure
     set(gcf, 'Color', 'w');
   
    fill(x_laser,y_laser_All,[255/255, 216/255, 101/255],'LineStyle','none')
    hold on
    for jj = 1:size(dataPulse{mm},1)
        plot(x_axis, dataPulseNorm{mm}(jj,:)+y_lim(2)*(jj-1), 'k')
    end
    xlabel('Time (ms)')
    ylabel('Membrane Potential (mV)')
    axis tight
     box off
    
end