function [] = plotTraj(trks)
%PlotTraj plots all the trajectories onto a same graph.
%
%Parameters:
%   trks: trajecotories in simple format
%
%Output:
%   plots of all trajectories on a same graph

trkNum = length(trks);
for i = 1:trkNum
    x = trks(i).x;
    y = trks(i).y;
    %c = ceil(([trks(i).lifetime]-11)/28.4);
    %if c ==0
        %c = 1;
    %end
    %if all_rotate(i).lifetime <=40
        line(x,y,'color','b'), hold on;
    %else
        %line(x,y,'color','r'), axis([100,500,0,400]), hold on;
    %end
end