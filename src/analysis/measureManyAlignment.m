function out = measureManyAlignment(in,ROI,center,angle,threshold)
%measureManyAlignment takes in a raw movie, and measure alignment degree of filament orientation for each frame.
%
%Parameters:
%   in: raw movie
%
%   ROI: region of interest in [xmin,xmax,ymin,ymax] format
%
%   center: center of the movie, for rotation. See Rotation.mat for more infomation
%
%   angle: for Rotation. See Rotation.mat for more information
%
%   threshold: minimum pixel intensity to be considered as signal
%
%Output:
%   out: The direction distribution of pixels in ROI  from -pi/2 to pi/2 in 45 bins


num = length(in(1,1,:));
out(num) = struct('frame',0,'direction',0);

for i = 1:num
    temp = in(:,:,i);
    final = measureOneAlignment(temp,center,angle,threshold);
    
    temp = final(final(:,1)>=ROI(1),:);
    temp = temp(temp(:,1)<=ROI(2),:);
    temp = temp(temp(:,2)>=ROI(3),:);
    temp = temp(temp(:,2)<=ROI(4),:);
    
    a = temp(:,4);
    a = floor((a+90)/2);
    
    direc = zeros(90,1);
    for ii = 0:89
        direc(ii+1) = sum(temp(a==ii,5));
    end
    direc = direc./sum(direc);
    a = flip(direc);
    direc = a+direc;
    direc = direc(1:45);
    direc = flip(direc);
    out(i).frame = i;
    out(i).direction = direc;
end
