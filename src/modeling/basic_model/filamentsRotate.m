function [res,density] = filamentsRotate(initN, dt, totalT, iFrame, vivoCDF, strainRate, deathRate)
%filamentsRotate simulates the distribution of filament orientation with given contraction rate and death rate (turnover rate) assuming that filaments assemble at random orientations, cortex contracts with a constant contraction rate, and filaments in all directions have are equally likely to turnover.
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
%   strainRate: contraction rate
%
%   deathRate: turnover rate
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
    
    BRate = 2*initN*deathRate;
    
    
    %initialize size
    w = 1;
    

    filaments = EstimateOrientationV2(vivoCDF,initN);    
        
    nFrames = totalT/iFrame;
    nextFrame = 0;
    count = 1;
    contraction = strainRate(1);
    
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
        nBorn = poissrnd(BRate*w*dt);
        %nBorn = poissrnd(BRate*dt);
        filaments = vertcat(filaments, pi/2*rand(nBorn,1));
        
        %rotate
        filaments = filaments + dt*contraction*sin(filaments).*cos(filaments);        
        
        
        %domain size change
        w = w*(1-contraction*dt);
       
    end
          
        
end

