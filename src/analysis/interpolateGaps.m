function [ out ] = interpolateGaps( in )
%Given an array of trajectories in simple fomrat, interpolateGaps finds gaps in each trajectory represented by NaN and fills x, y and I values by linear interpolation.
%
%Parameters:
%   in: array of trajectories in simple format:
%       'first' =   the first movie frame in which this track appears
%   
%       'last' =    the last movie frame in which this track appears.
%   
%       'lifetime' = the length of the track in frames.
%   
%       'x' = an array containing the sequence of x positions.
%   
%       'y' = an array containing the sequence of y positions.
%   
%       'I' = an array containing the intensity values.
%
%Output:
%   out: same array with interpolated values



    numTracks = size(in,2);
    b = true(1,numTracks);
    
    for i = 1:numTracks;
        a = sum(~isnan(in(i).I));
        if a < 2 
            b(i)=0;
        end
    end
    in = in(b);
    
    numTracks = size(in,2);
    for i = 1:numTracks;
        in(i).x = naninterp(in(i).x);
        in(i).y = naninterp(in(i).y);
        in(i).I = naninterp(in(i).I);
    end
    out = in;       
end

