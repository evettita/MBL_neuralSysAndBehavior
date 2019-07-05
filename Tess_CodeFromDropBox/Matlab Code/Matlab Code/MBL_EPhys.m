function MBL_EPhys(dataPath,type)

% type is 'loom' or 'csChr'

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

switch type
    
    case 'loom'
        
    visStimCh = find(strcmp(h{1,1}.recChNames, 'ptDiode')); %'iPad_diode'
    MBL_LoomEPhys (d_All, si{1}, h, visStimCh)
    
    case 'csChr'
        
        pulseGenCh = find(strcmp(h{1,1}.recChNames, 'csChr'));
        My_csChrEPhys(d_All, si{1}, pulseGenCh)
        
end
    

