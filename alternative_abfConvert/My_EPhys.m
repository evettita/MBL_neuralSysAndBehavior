function My_EPhys(dataPath)

d = importdata([dataPath '\d.mat']);
si = importdata([dataPath '\si.mat']);
h = importdata([dataPath '\h.mat']);
nCh = size(d{1},2);

d_All = d{1};
d_All(1:length(d{1}),nCh+1) = ones(length(d{1}),1);

for jj = 2:length(d)
    d{jj}(1:length(d{jj}),nCh+1) = jj*ones(length(d{jj}),1);
    d_All = vertcat(d_All, d{jj});
end

if strcmp(h{1,1}.recChNames(1,1),'Primary')
    visStimCh = find(strcmp(h{1,1}.recChNames, 'ptdiode_rt'));
pulseGenCh = find(strcmp(h{1,1}.recChNames, 'cam_trig'));
else
    
visStimCh = find(strcmp(h{1,1}.recChNames, 'VisStimL'));
pulseGenCh = find(strcmp(h{1,1}.recChNames, 'PulseGen'));
NIDAQCh = find(strcmp(h{1,1}.recChNames, 'NIDAQ'));
end

My_LoomEPhys (d_All, si{1}, h, visStimCh)
% My_csChrEPhys (d_All, si{1}, pulseGenCh, NIDAQCh)
% My_csChrEPhys (d_All, si{1}, pulseGenCh)