function out = alignmentSimulator2(initN, dt, totalT, iFrame, vivoCDF, strainMin, strainMax, deathMin, deathMax)
%alignmentSimulator2 explores parameter space for the basic math model.
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
%   filaments distribution measured in vivo
%
%   strainMin: minimum contraction rate the system will explore
%
%   strainMax: maximum contraction rate the system will explore
%
%   deathMin: minimum death rate the system will explore
%
%   deathMax: maximum death rate the system will explore
%
%Output:
%   First column: Contraction rate
%
%   Second column: Death rate
%
%   Third column: Asymmetry value of the distribution of the filament orientation at the end.

%obtain strainRate and DeathRate pairs
a = strainMin:0.001:strainMax;
b = deathMin:0.005:deathMax;
[A,B] = meshgrid(a,b);
parameter=cat(2,A',B');
parameter=reshape(parameter,[],2);

l = size(parameter,1);

out = zeros(l,3);

out(:,1:2)=parameter;

progressbar

for i = 1:l
    strainRate = parameter(i,1);
    deathRate = parameter(i,2);
    count =1;
    res = zeros(90,18);
    while count <6
        [temp,dens] = filamentsRotate(initN, dt, totalT, iFrame, vivoCDF, strainRate, deathRate);
        res = res+temp;
        count = count+1;
    end
    res = res./5;
    temp = res(90,:);
    [asy,theta] = fitAsymmetryValueV2(temp);
    
    out(i,3)=asy;
    
    progressbar(i/l);
end
end

