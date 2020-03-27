function out = turnoverSimulator5(initN,dt,totalT,iFrame,vivoCDF,strainRate)
% turnoverSimulator5 explores 200 random parameter pairs in the parameter space for differential turnover model. 
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
%   strainRate: contraction rate measured in vivo.
%
%Output:
%   out: the result of the simulation in the following format:
%
%       minDeath = minimum turnover rate
%
%       maxDeath = maximum turnover rate
%
%       k = threshold for the Hill function
%
%       kdgree = degree of the Hill function
%
%       aveDeath2 = average turnover rate from 60 - 90 seconds
%
%       asy = asymmetry value
%
%       filamentDis = filament distribution from filamentsRotate2v3
%
%       Int = intensity from filamentsRotate2v3

out = struct('minDeath',0,'maxDeath',0,'k',0,'aveDeath2',0,'asy',0,'filamentDis',0,'Int',0);

% run simulation for specific choice of parameters 10 times and average the
% results.
for i = 1:200
    deathRateMin = rand(1)*0.2+0.0001;
    deathRateMax = deathRateMin+(0.5-deathRateMin)*rand(1);
    k = round(rand(1)*89)+1;
    kdgree = round(rand(1)*9+1);

    [res,Int] = filamentsRotate2v3(initN, dt, totalT, iFrame,vivoCDF, strainRate, deathRateMin, deathRateMax,k,kdgree);
    
    high = res(:,17:18);
    low = res(:,1:2);
    high = mean(high,2);
    low = mean(low,2);
    asy = high./low;
    
    %calculate true mean deathRate for last 30 seconds
    angle = linspace(0,90,18);
    deathRate = angle.^kdgree*(deathRateMin-deathRateMax)./(k^kdgree+angle.^kdgree)+deathRateMax;
    filamentCount=sum(res(61:90,:));
    aveDeath2 = sum(filamentCount.*deathRate)/sum(filamentCount);
    
    %calculate true mean deathRate for first 30 seconds
    %filamentCount=sum(res(1:30,:));
    %aveDeath1 = sum(filamentCount.*deathRate)/sum(filamentCount);
    
    %record what have calculated
    out(i).minDeath = deathRateMin;
    out(i).maxDeath = deathRateMax;
    out(i).k = k;
    out(i).kdgree=kdgree;
    %out(i).aveDeath1 = aveDeath1;
    out(i).aveDeath2 = aveDeath2;
    out(i).asy = asy;
    out(i).filamentDis = res;
    out(i).Int = Int;
   
end
end
