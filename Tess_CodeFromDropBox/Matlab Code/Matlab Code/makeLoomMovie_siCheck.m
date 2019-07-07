function [F] = makeLoomMovie_siCheck (LoverV, sr, initStimSize, finalStimSize, initHold, finalHold, ISI, filePath)

% sr is sampling rate in Hz
% initStimSize and finalStimSize in deg
% initHold (currently just white screen) and finalHold is s

si = 1/sr * 1e6; %si in us for loomGen function

x = 0;
y = 0;
loomColor = 'k';
v = VideoWriter(sprintf([filePath 'LoverV%d_iStimSz%d_fStimSz%d_ISI%ds_si'],LoverV, initStimSize, finalStimSize, ISI),'MPEG-4');
v.FrameRate = sr;
v.Quality = 100;

open(v)
frameN = 0;

[stimThetaVector] = loomGen (LoverV, si, initStimSize, finalStimSize);

if initHold ~= 0
for aa = 1: round(sr*initHold)
    frameN = frameN+1;
    h = circle(x,y,stimThetaVector(1),'w');
    if rem(frameN,2) == 0
% if ismember(aa, [1 round(sr*initHold)])
        rectangle('Position',[-3.2 -3.2 0.9 0.9],'FaceColor',[1/3 1/3 1/3],'EdgeColor',[1/3 1/3 1/3])
    end
    F(frameN) = getframe;
end
end

for ii = 1:length(stimThetaVector)
    frameN = frameN+1;
    h = circle(x,y,stimThetaVector(ii),loomColor);
    if rem(frameN,2) == 0
% if ismember(ii, [frameN length(stimThetaVector)])
        rectangle('Position',[-3.2 -3.2 0.9 0.9],'FaceColor','k','EdgeColor','k')
    end
    F(frameN) = getframe;
end

if finalHold ~= 0
for bb = 1: round(sr*finalHold)
    frameN = frameN+1;
    h = circle(x,y,stimThetaVector(ii),loomColor);
    if rem(frameN,2) == 0
% if ismember(bb, [frameN round(sr*finalHold)])
        rectangle('Position',[-3.2 -3.2 0.9 0.9],'FaceColor',[1/3 1/3 1/3],'EdgeColor',[1/3 1/3 1/3])
    end
    F(frameN) = getframe;
end
end

if ISI ~= 0
for jj = 1: round (sr*ISI)
    frameN = frameN+1;
    h = plot(0,0,'.w');
    xlim([-3.2 3.2])
    ylim([-3.2 3.2])
    pbaspect([1 1 1])
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    set(gca,'xtick',[])
    set(gca,'ytick',[])
%     if rem(frameN,2) == 0
if ismember(jj, [frameN round(sr*ISI)])
end

        rectangle('Position',[-3.2 -3.2 0.9 0.9],'FaceColor',[2/3 2/3 2/3],'EdgeColor',[2/3 2/3 2/3])
    end
    
    F(frameN) = getframe;
end



writeVideo(v, F)
close(v)

end

function [J] = runTest()
    fprint('hello');
end