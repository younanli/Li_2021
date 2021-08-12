function out = EstimateOrientationV2(CDF, nBorn)
%EstimateOrientationV2 generate the orientation of new filaments based on
%the orientation of existing filaments
%
%Parameters:
%   CDF:accumulative distribution function for existing filaments
%
%   nBorn: the number of new filaments.
%
%Output:
%   out: the orientation of new filaments

x = CDF(:,1);
f = CDF(:,2);

newfil = rand(nBorn,1);
out = zeros(nBorn,1);
for i = 1:nBorn
    orien = newfil(i);
    if sum(f==orien)==1
        out(i)=x(f==orien);
    else
        x1 = x(f>orien);
        x1 = x1(1);
        y1 = f(f>orien);
        y1 = y1(1);
        x2 = x(f<orien);
        x2 = x2(end);
        y2 = f(f<orien);
        y2 = y2(end);
        
        coefficients = polyfit([y1,y2],[x1,x2],1);
        a = coefficients(1);
        b = coefficients(2);
        out(i) = a*orien+b;
    end
end
out = out./180*pi;
end