function [res,density] = filamentsRotate4(VivoCDF, initN, dt, totalT, iFrame, strainRate, deathRate,p)
%filamentsRotate4 simulates the distribution of filament orientation with
%in vivo contraction rate and turnover rate, assuming that lamda portion of
%the new born filament inherent the orientation of an existing filament.
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
%   vivoCDF: accumulative distribution function for the orientation of filaments distribution measured in vivo
%
%   strainRate: in vivo measurement of contraction rate
%
%   deathRate: in vivo measurement of turnover rate
%
%   p: lamda
%
%Output:
%   res: the distribution of filament orientation in the following format:
%
%       rows = time evolution
%
%       columns = bins from 0 - 90 degrees
%
%       numbers = the number of filament within a bin of direction at a
%       given timepoint
%
%   density: total filament density


    deathThreshold = 1 - exp(-deathRate*dt);    
    BRate = 2*deathRate*initN;
    
    %initialize size
    w = 1;
    
    
    filaments = EstimateOrientationV2(VivoCDF,initN);
    nFrames = totalT/iFrame;
    nextFrame = 0;
    count = 1;
    contraction = strainRate(1);
    %contraction = strainRate;
    
    res = zeros(nFrames,18);
    density = zeros(nFrames,1);
    
    for time = 0:dt:totalT 
                
        %record distribution
        if time > nextFrame
            res(count,:) = hist(filaments,18);
            density(count) = length(filaments)/w;
            contraction = strainRate(count);
            count = count + 1;
            nextFrame = nextFrame + iFrame;
        end
        
        %die
        death = rand(length(filaments),1);
        filaments = filaments(death > deathThreshold);
        
        %birth
        nBorn = poissrnd(BRate*dt*w);       
        tmpBorn = round(nBorn*p);
        tmpBorn = EstimateOrientation(filaments,tmpBorn);
        rndBorn = round(nBorn*(1-p));
        rndBorn = pi/2*rand(rndBorn,1);
        filaments = vertcat(filaments,tmpBorn,rndBorn);
        
        %rotate
        filaments = filaments + dt*contraction*sin(filaments).*cos(filaments);
        
        %domain size change
        w = w*(1-contraction*dt);
        
    end
            
        
end
