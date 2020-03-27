function out = alignmentSimulator4(VivoCDF, initN, dt, totalT, iFrame, strainRate, deathRate)
% alignmentSimulator4 explores 50 random lamda value for FGFA model
%
%Parameters:
%   initN: initial number of filaments
%
%   dt: delta time for stepwise estimate
%
%   totalT: total length of time to simulate
%
%   iFrame: period of time to record simulated results
%
%   vivoCDF: accumulative distribution function for the orientation of
%   filaments distribution measured in vivo.
%
%   strainRate: measured contraction rate in vivo.
%
%   deathRate: measured turnover rate in vivo.
%
%Output:
%   first column: lamda
%
%   second column: asymmetry value

prange = linspace(0,1,50);

out = zeros(50,2);

progressbar

for i = 1:50
    p = prange(i);
    asy = 0;
    count = 1;
    while count<11
        [a,b] = filamentsRotate4(VivoCDF, initN,dt,totalT,iFrame,strainRate,deathRate,p);
        m = a(90,:);
        a = fitAsymmetryValue(m);
        asy = asy+a;
        count = count+1;
    end
    asy = asy/10;
    
    out(i,1) = p;
    out(i,2) = asy;
    
    progressbar(i/50)
end
end
