function [res,density] = filamentsRotate2v3(initN, dt, totalT, iFrame, vivoCDF, strainRate, deathRateMin, deathRateMax,k,kdgree)
% filamentsRotate2v3 silulates the distribution of filament orientation with in vivo contraction rate and assume that the death rate depends on the orientation of filament governed by a Hill function.
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
%   deathRateMin: minimum turnover rate
%
%   deathRateMax: maximum turnover rate
%
%   k: threshold for the Hill function
%
%   kdgree: degree of the Hill function
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


    %calculate Deathrate based on orientation
    deathRate = zeros(90,2);
    deathRate(:,1) = linspace(0,90,90);
    deathRate(:,2) = deathRate(:,1).^kdgree*(deathRateMin-deathRateMax)./(k^kdgree+deathRate(:,1).^kdgree)+deathRateMax;
    
    %initialize size
    w=1;
    
    deathThreshold = 1 - exp(-deathRate(:,2).*dt);
    filaments = EstimateOrientationV2(vivoCDF,initN);
    
    %calculate initial average deathrate
    aveDeath = mean(deathRate(:,2));
    
    %calculate BRate
    BRate = 2*initN*aveDeath;
    
    
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
        deathMark = zeros(length(filaments),1);
        for i = 1:90
            index = floor(filaments/pi*180)+1;
            deathMark(index==i)=deathThreshold(i);
        end
        filaments = filaments(death>deathMark);
        
        %birth
        nBorn = poissrnd(BRate*dt*w);
        filaments = vertcat(filaments, pi/2*rand(nBorn,1));
        
        %rotate
        filaments = filaments + dt*contraction*sin(filaments).*cos(filaments);
        
        %domain size change
        w=w*(1-contraction*dt);
        
        
    end
        
end