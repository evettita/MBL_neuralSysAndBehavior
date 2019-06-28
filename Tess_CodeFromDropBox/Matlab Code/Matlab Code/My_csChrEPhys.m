
function My_csChrEPhys(d, si, pulseGenCh, NIDAQCh)

sf = 1000/si; %samples per ms
% pulseIntenProtocol = [1.0 0.75 0.50 0.25 0.10 0.05 0.01 1.0]*5;

pulseIntenProtocol = 5;
dataStart = 500;
dataEnd = 1500;

% if sum(d(:,NIDAQCh) > 0.2) ~= 0
%     My_csChrEPhysFiber(d, sf, NIDAQCh, pulseIntenProtocol, dataStart, dataEnd)
% end

if sum(d(:,pulseGenCh) > 1) ~= 0
    My_csChrEPhysObjective(d, sf, pulseGenCh, dataStart, dataEnd)
end






