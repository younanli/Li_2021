function out = filamentIntensityplateau(in)
%filamentIntensityplatueau fit a straight line to the intensity data from
%41 - 90 seconds to measure intensity slope during that period.
%
%Parameters:
%   in: the result of the simulation from either turnoverSimulator5 or FGFA modeling.
%
%Output:
%   in with an additional field "plateau" to record intensity slope.

l = length(in);
for i = 1:l
    int = in(i).Int;
    int = int - int(1);
    int = int./max(int);
    int = int(41:90);
    %int = int./min(int);
    time = 41:1:90;
    time = time';
    p = polyfit(time,int,1);
    in(i).plateau = p(1);
    out = in;
end  