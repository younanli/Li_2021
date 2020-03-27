function out = TrajDirection2(trks)
%TrajDirection2 calculate the direction of each trajectory. The way it
%measures the direction is to calculate the atan angle between the first
%and the last point.
%
%Parameters:
%   trks: trajectories in simple format.
%
%Output:
%   out: trajectories in simple format with direction field.

l = length(trks);
for i = 1:l
    x = trks(i).x;
    y = trks(i).y;
    x = smooth(x,3);
    y = smooth(y,3);
    l = x(end)-x(1);
    h = y(end)-y(1);
    A = atan2(h,l);
    D = [mean(x),mean(y),A];
    trks(i).direction = D;
end
out = trks;
end