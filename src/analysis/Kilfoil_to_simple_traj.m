function [ out ] = Kilfoil_to_simple_traj( in )
%Kilfoil_to_simple_traj: Transform the output of Kilfoil particle tracking into the format produced by uTrackToSimpleTraj.m
%
%Parameters:
%   in: output data in array format used by Kilfoil
%
%Output:
%   out: a list of particle tracks in the format output by the function uTrackToSimpleTraj:
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

numTracks = max(in(:,5));
out(numTracks) = struct('first',0,'last',0,'lifetime',0,'x',0,'y',0,'I',0);
if size(in,2) < 11
    in(:,size(in,2)+1:11) = 0;
end

for i = 1:numTracks
    trk = in([in(:,5)==i],:);
    a = min(trk(:,4));
    b = max(trk(:,4));
    out(i).first = a;
    out(i).last = b;
    out(i).lifetime = b-a+1;
    for ii = 1:out(i).lifetime
        index = ii+a-1;
        if sum(trk(:,4)==index) == 1
            out(i).x(ii) = trk(trk(:,4)==index,1);
            out(i).y(ii) = trk(trk(:,4)==index,2);
            out(i).I(ii) = trk(trk(:,4)==index,3);
            if sum(trk(:,6)) ~= 0
                out(i).d(ii) = trk(trk(:,4)==index,6);
            end
            if sum(trk(:,7)) ~= 0
                out(i).smoothI(ii) = trk(trk(:,4)==index,7);
            end
            if sum(trk(:,8)) ~= 0
                out(i).xDis(ii) = trk(trk(:,4)==index,8);
            end
            if sum(trk(:,9)) ~= 0
                out(i).yDis(ii) = trk(trk(:,4)==index,9);
            end
            if sum(trk(:,10)) ~= 0
                out(i).speed(ii) = trk(trk(:,4)==index,10);
            end
            if sum(trk(:,11)) ~= 0
                out(i).curvature(ii) = trk(trk(:,4)==index,11);
            end
                
        else
            out(i).x(ii) = NaN;
            out(i).y(ii) = NaN;
            out(i).I(ii) = NaN;
        end
    
end
end

