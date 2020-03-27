function [out] = uTrack_to_simple_traj(tracks)
% uTrack_to_simple_Traj transforms track data from the tracksFinal format into a form that is suitable for further analysis.
%
%Parameters:
%   tracks: the tracksFinal structure output by ScriptTrackGeneral.
%
%Output: 
%   out: an array of structures, one for each track, whose fields are defined as follows:
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



%% Set up some basics
tracks = filterCmpdTrks(tracks);
numTracks = size(tracks,1);
trkLengths = trkLength(tracks);
out(numTracks) = struct('first',0,'last',0,'lifetime',0,'x',0,'y',0,'I',0);


%f=statusbar('reformatting...');

cnt = 1;
for i=1:numTracks
    coords=tracks(i,1).tracksCoordAmpCG;
    if size(coords,1)<=1
        events = tracks(i,1).seqOfEvents;
        x = zeros(1,trkLengths(i));
        y = zeros(1,trkLengths(i));
        I = zeros(1,trkLengths(i));
 
        for j=1:trkLengths(i)
            x(j)=coords(1,8*j-7);
            y(j)=coords(1,8*j-6);
            I(j) = coords(1,8*j-4);
        end
        
        
        out(cnt).first = 1 + events(1,1) - 1;
        out(cnt).last = 1 + events(2,1) - 1;
        out(cnt).lifetime = trkLengths(i);
        out(cnt).x = x;
        out(cnt).y = y;
        out(cnt).I = I;
        cnt=cnt+1;
    end
%    if isempty(statusbar(i/numTracks,f))
%        break;
%    end   
end

out(cnt:numTracks)=[];

%if ishandle(f)
%    delete(f);
%end
        