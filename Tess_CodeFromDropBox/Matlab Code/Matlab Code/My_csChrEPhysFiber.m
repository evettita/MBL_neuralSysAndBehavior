
function My_csChrEPhysFiber(d, sf, NIDAQCh, pulseIntenProtocol, dataStart, dataEnd)

roundPulseSig = round(d(:,NIDAQCh),1);
pulseIntensities = unique(roundPulseSig);
pulseIntensities = pulseIntensities(2:end);
roundPulseIntenPro = round (pulseIntenProtocol,1);

for nn = 1:length(pulseIntensities)
    if  ismember(pulseIntensities(nn), roundPulseIntenPro)
        pulseIntensitiesGood(nn) = pulseIntensities(nn);
    else pulseIntensitiesGood (nn) = NaN;
    end
end

pulseIntensitiesGood (isnan(pulseIntensitiesGood)) = [];

for kk = 1:length(pulseIntensitiesGood)
    pulseOn{kk,:} = find(roundPulseSig == pulseIntensitiesGood(kk));
    pulseStart{kk,:} = find(diff(pulseOn{kk,1}) > 5)' + 1;
    pulseStart{kk,:} = [1 pulseStart{kk,1}];
    for ii = 1:length(pulseStart{kk})
        if roundPulseSig(pulseOn{kk}(pulseStart{kk}(ii))+1) ~= roundPulseSig(pulseOn{kk}(pulseStart{kk}(ii)))
            pulseStartBad{kk}(ii) = 1;
        else pulseStartBad{kk}(ii) = NaN;
        end
    end
    %     pulseStartBad{kk} = find(2250000 > diff(pulseOnNIDAQ{kk}(pulseStartNIDAQ{kk,:})) & diff(pulseOnNIDAQ{kk}(pulseStartNIDAQ{kk,:})) > 300100);
    pulseStart{kk}(find(~isnan(pulseStartBad{kk}))+1) = [];
    pulseLength{kk} = unique(round(diff(pulseStart{kk}),-1)); %rounds to nearest ms - may need to change later
    pulseLengthsPulse{kk} = round(diff(pulseStart {kk}),-1);
    pulseLengthsPulse{kk} = [pulseLengthsPulse{kk} pulseLengthsPulse{kk}(end)];


for mm = 1:length(pulseLength{kk})
   
    iPulseLength{kk}{mm} = find(pulseLength{kk} (mm) == pulseLengthsPulse{kk});
    dataPulse{kk}{mm} = nan(length(iPulseLength{kk}{mm}),dataStart+dataEnd);
    dataPulseNorm{kk}{mm} = nan(length(iPulseLength{kk}{mm}),dataStart+dataEnd);
    pulseShape{kk}{mm} = nan(length(iPulseLength{kk}{mm}),dataStart+dataEnd);
    
    count = 0;
    
    for ii = 1:length(pulseLengthsPulse{kk})
       
        if pulseLength{kk} (mm) == pulseLengthsPulse{kk}(ii)
            count = count +1;
            dataPulse{kk}{mm}(count,:) = d((pulseOn{kk}(pulseStart{kk}(ii))-dataStart):(pulseOn{kk}(pulseStart{kk}(ii))+dataEnd)-1,1);
            baseline{kk}{mm}(count) = mean(d((pulseOn{kk}(pulseStart{kk}(ii))-dataStart):(pulseOn{kk}(pulseStart{kk}(ii))-1),1));
            dataPulseNorm{kk}{mm}(count,:) = dataPulse{kk}{mm}(count,:)-baseline{kk}{mm}(count);
            pulseShape{kk}{mm}(count,:) = d((pulseOn{kk}(pulseStart{kk}(ii))-dataStart):(pulseOn{kk}(pulseStart{kk}(ii))+dataEnd)-1,NIDAQCh);
        end
    end
    
    stdPulseNorm{kk}{mm} = std(dataPulseNorm{kk}{mm});
    x_axis = ((1:length(dataPulse{kk}{mm}))-dataStart)/sf;
    x_laser = ([dataStart dataStart+pulseLength{kk}(mm) dataStart+pulseLength{kk}(mm) dataStart]-dataStart)./sf;
%     y_lim = [-2 ceil(max(max(dataPulseNorm{kk}{mm})) + 2)];
y_lim = [-2 15];
    y_laser = [y_lim(1) y_lim(1) y_lim(2) y_lim(2)];
    y_laser_All = [y_lim(1) y_lim(1) size(dataPulse{kk}{mm},1)*y_lim(2) size(dataPulse{kk}{mm},1)*y_lim(2)];

    % pulseNorm48 = load ('Z:\Tess\EPhysData\20181008\OL0048B\dataPulseNorm_48B.mat');
    % stdPulseNorm48 = load ('Z:\Tess\EPhysData\20181008\OL0048B\stdPulseNorm_48B.mat');
    
   
%     figure (pulseLength{kk}(mm) + 1)
%     subplot(length(pulseIntensitiesGood),1, kk)
%     fill(x_laser,y_laser,[255/255, 216/255, 101/255],'LineStyle','none')
%     hold on
%     % My_errorbar(x_axis,mean(pulseNorm48.dataPulseNorm,1),stdPulseNorm48.stdPulseNorm,3)
%     My_errorbar(x_axis, mean(dataPulseNorm{kk}{mm},1),stdPulseNorm{kk}{mm},3)
%     ylim([y_lim(1) max(stdPulseNorm{kk}{mm} + ceil((mean(dataPulseNorm{kk}{mm})))+1)])
%     xlabel('Time (ms)')
%     ylabel('Membrane Potential (mV)')
    % axis tight
    
    figure (pulseLength{kk}(mm) + 2)
    subplot(length(pulseIntensitiesGood),1, kk)
%     fill(x_laser,y_laser,[255/255, 216/255, 101/255],'LineStyle','none')
    hold on
%     plot(x_axis,dataPulseNorm{kk}{mm}','color',[250/255, 193/255, 195/255]) %red
%     plot(x_axis,dataPulseNorm{kk}{mm}','color',[200/255, 200/255, 200/255])
plot(x_axis,dataPulseNorm{kk}{mm}','color',[103/255, 103/255, 183/255])
    hold on
%     plot (x_axis,mean(dataPulseNorm{kk}{mm},1),'color',[225/255, 22/255, 40/255],'LineWidth',2.5)
%     plot (x_axis,mean(dataPulseNorm{kk}{mm},1),'color','k','LineWidth',2.5)
plot (x_axis,mean(dataPulseNorm{kk}{mm},1),'color',[51/255, 51/255, 188/255],'LineWidth',2.5)
    ylim(y_lim)
    xlabel('Time (ms)')
    ylabel('Membrane Potential (mV)')
    % axis tight
    
%     figure
%     fill(x_laser,y_laser_All,[255/255, 216/255, 101/255],'LineStyle','none')
%     hold on
%     for jj = 1:size(dataPulse{kk}{mm},1)
%         plot(x_axis, dataPulseNorm{kk}{mm}(jj,:)+y_lim(2)*(jj-1), 'k')
%     end
%     xlabel('Time (ms)')
%     ylabel('Membrane Potential (mV)')
%     axis tight
    
end
end