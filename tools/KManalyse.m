
function [chi2, pVal] = KManalyse(data, times, cens)
    ind0 = find(~data);
    ind1 = find(data);

    dc0 = zeros(size(times));
    dc0(ind0) = 1;
    dc1 = zeros(size(times));
    dc1(ind1) = 1;

    n0 = zeros(size(times));
    n0(1) = size(ind0,1);

    n1 = zeros(size(times));
    n1(1) = size(ind1,1);

    for j=2:size(n0,1)
        n0(j) = n0(j-1)-dc0(j-1);
        n1(j) = n1(j-1)-dc1(j-1);
    end

    ni = n0+n1;
    di = dc0+dc1;
      
    truc0 = n0.*di./ni;
    truc1 = n1.*di./ni;    
        
    chi2 = ((sum(dc0(~cens))-sum(truc0(~cens)))^2)/sum(truc0(~cens))+ ...
        ((sum(dc1(~cens))-sum(truc1(~cens)))^2)/sum(truc1(~cens));
    
    pVal = 1 - cdf('Chisquare', chi2, 1);
end