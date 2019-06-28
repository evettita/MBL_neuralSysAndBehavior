
function [loomISI, loomFirstInBout, iBoutStart] = isiID(iStartLoom, iEndLoom, LoomHold, si)

sr = 1000000/si; %sampling rate in s, si is us per sample

dStLoom = diff(iStartLoom);
% iBoutStart = find(dStLoom > Bout_Thresh) + 1;

loomFirstInBout = zeros(1,length(iStartLoom));


for ii = 1:length(iStartLoom)-1
    
    loomISI(ii) = floor((iStartLoom(ii+1) - iEndLoom(ii)-LoomHold)/sr);
    
end

loomISI(length(iStartLoom)) = loomISI(length(iStartLoom)-1);
boutStart = 0;

for kk = 2:length(iStartLoom)-1
    if loomISI(kk) ~= loomISI(kk-1) && loomISI(kk) ~= loomISI(kk + 1)
        
        loomISI(kk) = loomISI(kk-1);
        boutStart(kk) = 1;
        
    end
end

if sum(boutStart(1:end-1)) == 0 && length(iStartLoom) ~= 0
    
    iBoutStart = find(boutStart) + 1;
    iBoutStart = [1 iBoutStart];
    
elseif sum(boutStart(1:end-1)) ~= 0 && length(iStartLoom) ~= 0
    
    iBoutStart = find(boutStart) + 1;
    iBoutStart = [1 iBoutStart];
    
elseif sum(boutStart) == 0 && length(iStartLoom) == 0
    iBoutStart = 0;
    loomFirstInBout = 0;
end

for jj = 1:length(iBoutStart)
    loomFirstInBout(iBoutStart(jj):iBoutStart(jj)+4) = iStartLoom(iBoutStart(jj));
end


end



