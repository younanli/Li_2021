function [ out ] = simple_to_Kilfoil_traj( trks )
%simple_to_Kilfoil_traj: Transform the output of uTrack_to_simple_traj into the format produced by Kilfoil
%
%Parameters:
%   trks: a list of particle tracks which is assumed to be in the format output by the function uTrackToSimpleTraj:
%
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
%   out: output data in array format used by Kilfoil with columns: Xpos, Ypos, Int, frame#, trackID, xDis/yDis/d/SI/speed

numTracks = size(trks,2);

tot = 0;
for i = 1:numTracks
    tot = tot + trks(i).lifetime;
end

out = zeros(tot,6);
cnt = 1;
for i = 1:numTracks
    for j = 1:trks(i).lifetime
        %trks(i).d(trks(i).lifetime) = trks(i).d(trks(i).lifetime-1);
        out(cnt,1) = trks(i).x(j);
        out(cnt,2) = trks(i).y(j);
        out(cnt,3) = trks(i).I(j);
        out(cnt,4) = trks(i).first+j-1;
        out(cnt,5) = i;
        
        if isfield(trks,'d')
            out(cnt,6) = trks(i).d(j);
        end
        if isfield(trks,'smoothI')
            out(cnt,7) = trks(i).smoothI(j);
        end
        if isfield(trks,'xDis')
            out(cnt,8) = trks(i).xDis(j);
        end
        if isfield(trks,'yDis')
            out(cnt,9) = trks(i).yDis(j);
        end
        if isfield(trks,'speed')
            out(cnt,10) = trks(i).speed(j);
        end
        if isfield(trks,'curvature')
            out(cnt,11) = trks(i).curvature(j);
        end
               
        cnt = cnt+1;
    end
end

