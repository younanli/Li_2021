function [out] = BreakDownTraj(in,b)
%BreakDownTraj takes in trajectories and break them down to shorter
%fragments.
%
%Parameters:
%   in: trajectories in simple format
%
%   b: length of the short fragment
%
%Output:
%   out: trajectories with length b. 
%
%Note: for each trajectory, if the tail is longer than 5 frames, then keep
%the tail.
l = length(in);
out=struct('first',0,'last',0,'lifetime',0,'x',0,'y',0,'I',0,'id',0);
temp = struct('first',0,'last',0,'lifetime',0,'x',0,'y',0,'I',0,'id',0);

for i = 1:l
   x = in(i).x;
   y = in(i).y;
   I = in(i).I;
   count = 1;
   while length(x)>=b
       temp.first = in(i).first+(count-1)*(b-1);
       temp.last = in(i).first+count*(b-1);
       temp.lifetime = b;
       temp.x = x(1:b);
       temp.y = y(1:b);
       temp.I = I(1:b);
       temp.id = i;
       x= x(b:end);
       y=y(b:end);
       I=I(b:end);
       count = count+1;
       out(end+1)=temp;
   end
   
   if length(x)>=5
       temp.x = x;
       temp.y = y;
       temp.I = I;
       temp.lifetime = length(x);
       temp.first = in(i).first+(count-1)*(b-1);
       temp.last = in(i).last;
       temp.id = i;
       out(end+1)=temp;
   end
end
end

