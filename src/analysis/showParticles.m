function [ ] = showParticles( stk, trks )
%ShowParticles generates TIFF images that have tracking results overlayed
%on top of the raw image.
%
%Parameters:
%   stk: stacks of raw movie.
%
%   trks: trajectories in simple format.
%
%Output:
%   TIFF images that have tracking results overlayed on top of the raw
%   image.

mkdir 'tmp';
nTrks = length(trks);
xaxis = size(stk,1);%
yaxis = size(stk,2);%
for i = 1:size(stk,3)
    clf;
    %axes('Position',[0 0 1 1]);
    imshow(stk(:,:,i),[1 5000]); %
    axis image;
    hold on;
    for iTrk = 1:nTrks
        if trks(iTrk).first == i
            text(trks(iTrk).x(1),trks(iTrk).y(1),num2str(iTrk),'HorizontalAlignment','left','Color','red','FontSize',10);
        end
        if i>trks(iTrk).first &&  i<=trks(iTrk).last
            plot(trks(iTrk).x(i-trks(iTrk).first+1),trks(iTrk).y(i-trks(iTrk).first+1),'ro','MarkerSize',5);
            
        end            
    end
    pause(0.1);
    f = getframe;
    f.cdata = f.cdata(1:xaxis,1:yaxis,:);%
    [im,map] = frame2im(f);
    fs = sprintf('tmp/fov1_%04d.tif',i);
    imwrite(im,fs,'tif');
    hold off;

end

