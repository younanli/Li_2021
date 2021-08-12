function out = AsymmetryRiseSlope(in)
% AsymmetryRiseSlope fit a straight line to the Asymmetry data from 61 - 90 seconds to measure asymmetry slope during that period.
%
%Parameters:
%   in: the result of the simulation from either turnoverSimulator5 or FGFA modeling.
%
%Output:
%   in with an additional field "asySlope" to record asymmetry slope.


l = length(in);
for i = 1:l
    asy = in(i).asy;
    asy = smooth(asy,3);
    %asy = asy - asy(1);
    %asy = asy./max(asy);
    asy = asy(61:90);
    time = 61:1:90;
    time = time';
    p = polyfit(time,asy,1);
    in(i).asySlope =p(1);
    out = in;
end
end