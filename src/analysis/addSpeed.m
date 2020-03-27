function out = addSpeed(trk,b)
% addSpeed adds the instant speed of each trajectory at each given point. First it will take a trajectory, and using a moving average b to smooth the x and y position. After smoothing, it will calculate the distance between (xt,yt) and (x(t-1), y(t-1)), and record that as the instant speed at that given moment t.
% 
%Parameters:
%   trk: should be simple format;
%
%   b: the span to smooth the data;
% 
%Output:
%   out: the simple format trajectory database, with one extra structure, speed, which record the speed of each trajectory at every time point.

for i = 1:length(trk)
    x = trk(i).x;
    x = smooth(x,b);
    y = trk(i).y;
    y = smooth(y,b);
    x2 = [x(2:length(x));x(length(x)-1)];
    y2 = [y(2:length(y));y(length(x)-1)];
    dis = (x-x2).^2 + (y-y2).^2;
    dis = dis.^0.5;
    trk(i).speed = dis';
    trk(i).AveSpeed = mean(dis);
    
    x2 = [0;x];
    dx = x-x2(1:length(x));
    dx(1) = dx(2);
    trk(i).xDis = dx';
    
    y2 = [0;y];
    dy = y - y2(1:length(y));
    dy(1) = dy(2);
    trk(i).yDis = dy';
    
end
out = trk;
end
