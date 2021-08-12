function [out] = addAsymmetry(trks)
%addAsymmetry adds asymmetry values to each trajectory. The asymmetry value is calculated as S=-ln(1-((v1-v2)^2)/(v1+v2)^2)), where v1 and v2 are the eigenvalues v1 and v2 of the variance-covariance matrix of the trajectory positions over time.
%   
%Parameters:
%
%   trks: tracks that's in the simple format
%
%Output:
%   out: trajecoties in simple format with Asymmetry field.

a = length(trks);
for i=1:a
    temp= trks(i);
    c = cov(temp.x,temp.y);
    v = eigs(c,2);
    v1 = v(1);
    v2 = v(2);
    S=-log(1-((v1-v2)^2)/(v1+v2)^2);
    trks(i).asymmetry = S;
end
out = trks;
end