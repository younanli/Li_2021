function out = measureOneAlignment(ip,center,angle,threshold)
%this function uses two 3X3 kernel masks to calculate the direction of each pixel. Notice that the final product takes into consideration of both the sharpness of the boundary and the intensity of the pixel at that location.
%
%Parameters:
%   ip: the original movie frame
%
%   center: the center of that frame used to rotate the image. See
%   Rotation.mat for more infomation.
%
%   angle: Angle for rotation. see function Rotation.mat for more
%   infomation.
%
%   threshold: minimum intensity of each pixel to be considered
%
%output:
%   out: the orientation of each pixel in the following format:
%
%       1st column: x position
%
%       2nd column: y position
%
%       3nd column: intensity
%
%       4th column: angle
%
%       5th column: norm (used to plot angle distribution)

[x,y] = size(ip);
l = x*y;

%finding the boundary
ip = double(ip);
kx = [1,2,1;0,0,0;-1,-2,-1];
ky = [-1,0,1;-2,0,2;-1,0,1];
gx = imfilter(ip,kx);
gy = imfilter(ip,ky);
norm = sqrt(gx.^2 + gy.^2);
theta = atan(-gy./gx);

%reshape theta
a= theta./(pi/2)*90-angle;
a = reshape(a,l,1);
if angle>=0
    a(a<=-90)=a(a<=-90)+180;
else
    a(a>=90)=a(a>=90)-180;
end

%reshape raw image
y_index = repmat([1:1:x]',y,1);
x_index = repmat([1:1:y],x,1);
x_index = reshape(x_index,l,1);
ip_reshape = reshape(ip,l,1);

%reshape norm
norm_reshape = reshape(norm,l,1);

%rotate data
final = [x_index,y_index,ip_reshape,a,norm_reshape];
index = ip_reshape>=threshold;
final = final(index,:);
final = Rotation(final,center,angle);
out = final;
end

