
function My_Looms(d)

dataStart = 5000;
dataEnd = 45000;

iLoomOn = find (d(:,4) > 1);
diLoomOn = diff(iLoomOn);
iStartLoom = iLoomOn([1 (find(diLoomOn > 20000)+1)']);
iStartLoom = iStartLoom(1:end-1);

iLoomOff = find (d(:,4) > 1.15 & d(:,4) < 1.6);
diLoomOff = diff(iLoomOff);
iEndLoom = iLoomOff(diLoomOff > 20000);

iHoldOff = find (d(:,4) > 0.97 & d(:,4) < 1.01);
diHoldOff = diff(iHoldOff);
iEndHold = iHoldOff(find(diHoldOff > 20000));

loomDur = (iEndLoom-iStartLoom)/100;

for ii = 1:length(iStartLoom)
    
    if loomDur(ii) > 21 && loomDur(ii) < 23
        lv (ii) = 10;
    elseif loomDur (ii) > 86.5 && loomDur(ii) < 88.5
        lv (ii) = 40;
    elseif loomDur (ii) > 152 && loomDur(ii) < 154
        lv (ii) = 70;
    elseif loomDur (ii) > 218 && loomDur(ii) < 220
        lv (ii) = 100;
    elseif loomDur (ii) > 283 && loomDur(ii) < 287
        lv (ii) = 130;
    else
        lv(ii) = nan;
        'Tess, check LVs'
    end
end

lv10 = nan(sum(lv == 10), dataStart+dataEnd);
lv40 = nan(sum(lv == 10), dataStart+dataEnd);
lv70 = nan(sum(lv == 10), dataStart+dataEnd);
lv100 = nan(sum(lv == 10), dataStart+dataEnd);
lv130 = nan(sum(lv == 10), dataStart+dataEnd);

countLV10 = 0;
countLV40 = 0;
countLV70 = 0;
countLV100= 0;
countLV130 = 0;


for jj = 1:length(iStartLoom)
    
    if lv(jj) == 10
        countLV10 = countLV10+1;
        lv10(countLV10,:) = d(iStartLoom(jj)-dataStart:iStartLoom(jj)+dataEnd-1,1);
    elseif lv(jj) == 40
        countLV40 = countLV40+1;
        lv40(countLV40,:) = d(iStartLoom(jj)-dataStart:iStartLoom(jj)+dataEnd-1,1);
    elseif lv(jj) == 70
        countLV70 = countLV70+1;
        lv70(countLV70,:) = d(iStartLoom(jj)-dataStart:iStartLoom(jj)+dataEnd-1,1);
    elseif lv(jj) == 100
        countLV100 = countLV100+1;
        lv100(countLV100,:) = d(iStartLoom(jj)-dataStart:iStartLoom(jj)+dataEnd-1,1);
    elseif lv(jj) == 130
        countLV130 = countLV130+1;
        lv130(countLV130,:) = d(iStartLoom(jj)-dataStart:iStartLoom(jj)+dataEnd-1,1);
    end
end

% Looms(1,:) = [zeros(1,dataStart) radtodeg(2*atan(10*linspace(0, pi/4, 2200))) 90*ones(1, dataEnd-2200)];
% Looms(2,:) = [zeros(1,dataStart) radtodeg(2*atan(40*linspace(0, pi/4, 8700))) 90*ones(1, dataEnd-8700)];
% Looms(3,:) = [zeros(1,dataStart) radtodeg(2*atan(70*linspace(0, pi/4, 15300))) 90*ones(1, dataEnd-15300)];
% Looms(4,:) = [zeros(1,dataStart) radtodeg(2*atan(100*linspace(0, pi/4, 21900))) 90*ones(1, dataEnd-21900)];
% Looms(5,:) = [zeros(1,dataStart) radtodeg(2*atan(130*linspace(0, pi/4, 28500))) 90*ones(1, dataEnd-28500)];

x_axis = (-1*dataStart:dataEnd-1)/10000;

figure

subplot (5,1,1)
plot(x_axis,mean(lv10,1))
axis tight
ylim ([-70 -68])

subplot (5,1,2)
plot(x_axis,mean(lv40,1))
axis tight
ylim ([-70 -68])

subplot (5,1,3)
plot(x_axis,mean(lv70,1))
axis tight
ylim ([-70 -68])

subplot (5,1,4)
plot(x_axis,mean(lv100,1))
axis tight
ylim ([-70 -68])

subplot (5,1,5)
plot(x_axis,mean(lv130,1))
axis tight
ylim ([-70 -68])

% subplot (6,1,6)
% plot (Looms)
% axis tight

stop








