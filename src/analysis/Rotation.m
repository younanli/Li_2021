function [out] = Rotation(tracks,center,angle)
%Rotation rotates the x,y coordinates of trajectories around the center of the movie.
%Parameters:
%   tracks: tracks in Kilfoil format 
%
%   center: center of the movie in [x;y] format
%
%   angle: rotation angle
%
%Output:
%   out: the same set of trajectories with new x,y coordinates.
a = length(tracks(1,:));
v = tracks(:,1:2)';
center=repmat(center,1,length(tracks(:,1)));
angle = angle/180*pi;
R = [cos(angle) -sin(angle);sin(angle) cos(angle)];
s = v-center;
so = R*s;
vo=so + center;
out = [vo',tracks(:,3:a)];
