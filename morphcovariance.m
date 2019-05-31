function [covolume,maxou,standev,cov,skew,kurt,energy, entropy,maxounorm,standevnorm,covnorm,skewnorm,kurtnorm,energynorm, entropynorm] = morphcovariance(vol3d, numiter, maskreduit, offset)

maskreversed255 = uint8(uint8(~maskreduit).*uint8(255));


vol3d = vol3d + maskreversed255; %for the fucking padding

tmpmasked = vol3d.*maskreduit;
vol3danti = tmpmasked;
baseVol = sum(sum(sum(tmpmasked)));

firstOrder = fOrderFeatCT(single(vol3d), single(maskreduit), [1, 1, 1]);

%minou = firstOrder(4);
covolume = ones(numiter+1, 1).';
maxou = firstOrder(5);
maxou = [maxou, ones(numiter, 1).'];
standev = firstOrder(7);
standev = [standev, ones(numiter, 1).'];
cov = firstOrder(8);
cov = [cov, ones(numiter, 1).'];
skew = firstOrder(9);
skew = [skew, ones(numiter, 1).'];
kurt = firstOrder(10);
kurt = [kurt, ones(numiter, 1).'];
energy = firstOrder(11);
energy = [energy, ones(numiter, 1).'];
entropy = firstOrder(12);
entropy = [entropy, ones(numiter, 1).'];



numDir = size(offset,1); % number of directions, currently 13
    
for iOff = 1:numDir
    currdirection = [offset(iOff,1); offset(iOff,2); offset(iOff,3)];
    covolumetemp = 1;
    maxoutemp = maxou(1);
    standevtemp = standev(1);
    covtemp = cov(1);
    skewtemp = skew(1);
    kurttemp = kurt(1);
    energytemp = energy(1);
    entropytemp = entropy(1);
    
    
    for iIter = 1:numiter
        
        mySE = zeros(1+2*iIter, 1+2*iIter, 1+2*iIter);
        mySE(iIter+1, iIter+1, iIter+1) = 1;
        mySE(iIter+1 + currdirection(1)*iIter, iIter+1 + currdirection(2)*iIter, iIter+1 + currdirection(3)*iIter) = 1;
        
        se = strel(mySE);
        
        tmp1 = imerode(vol3d, se); %opening is erosion + dilatation
        %tmp2 = tmp1
        tmp1 = tmp1.*maskreduit;;
        voltmp1 = sum(sum(sum(tmp1)));
        covolumetemp = [covolumetemp, voltmp1/ baseVol];

        firstOrder = fOrderFeatCT(single(tmp1), single(maskreduit), [1, 1, 1]);

        %minou = [minou, firstOrder(4)];  
        maxoutemp = [maxoutemp, firstOrder(5)];
        standevtemp = [standevtemp, firstOrder(7)];
        covtemp = [covtemp, firstOrder(8)];
        skewtemp = [skewtemp, firstOrder(9)];
        kurttemp = [kurttemp, firstOrder(10)];
        energytemp = [energytemp, firstOrder(11)];
        entropytemp = [entropytemp, firstOrder(12)];
        
    end
covolume = [covolume; covolumetemp];
maxou = [maxou; maxoutemp];
standev = [standev; standevtemp];
cov = [cov; covtemp ];
skew = [skew; skewtemp];
kurt = [kurt; kurttemp];
energy = [energy; energytemp];
entropy = [entropy; entropytemp];
    
end


covolume(1,:) = []
maxou(1,:) = []
standev(1,:) = []
cov(1,:) = []
skew(1,:) = []
kurt(1,:) = []
energy(1,:) = []
entropy(1,:) = []




    %minounorm = minou./ minou(1); 
    maxounorm = maxou./ maxou(1); 
    standevnorm = standev./standev(1);  
    covnorm = cov./cov(1); 
    skewnorm = skew./skew(1); 
    kurtnorm = kurt./kurt(1);  
    energynorm = energy./energy(1); 
    entropynorm = entropy./entropy(1); 
    

end


