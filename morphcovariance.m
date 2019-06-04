function [covolume,covN300, covN030, covN003,covmaxounorm,covstandevnorm,covcovnorm,covskewnorm,covkurtnorm,covenergynorm, coventropynorm] = morphcovariance(vol3d, numiter, maskreduit, offset)
%maxou,standev,cov,skew,kurt,energy, entropy, 
%supprimé les nons norm
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

NOUT = cent_moment(single(vol3d), single(maskreduit), [3, 0,0; 0,3,0; 0,0,3]);

covN300 = NOUT(1, :);
covN300 = [covN300, ones(numiter, 1).'];
covN030 = NOUT(2, :);
covN030 = [covN030, ones(numiter, 1).'];
covN003 = NOUT(3, :);
covN003 = [covN003, ones(numiter, 1).'];


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
    covN300temp = covN300(1);
    covN030temp = covN030(1);
    covN003temp = covN003(1);
    
    for iIter = 1:numiter
        
        mySE = zeros(1+2*iIter, 1+2*iIter, 1+2*iIter);
        mySE(iIter+1, iIter+1, iIter+1) = 1; %center
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
        
        NOUT = cent_moment(single(tmp1), single(maskreduit), [3, 0,0; 0,3,0; 0,0,3]);
 
        covN300temp = [covN300temp, NOUT(1, :)];
        covN030temp = [covN030temp, NOUT(2, :)];
        covN003temp = [covN003temp, NOUT(3, :)];
        
    
        
    end
covolume = [covolume; covolumetemp];
maxou = [maxou; maxoutemp];
standev = [standev; standevtemp];
cov = [cov; covtemp ];
skew = [skew; skewtemp];
kurt = [kurt; kurttemp];
energy = [energy; energytemp];
entropy = [entropy; entropytemp];

covN300 = [covN300; covN300temp];
covN030 = [covN030; covN030temp];
covN003 = [covN003; covN003temp];

    
end


covolume(1,:) = [];
maxou(1,:) = [];
standev(1,:) = [];
cov(1,:) = [];
skew(1,:) = [];
kurt(1,:) = [];
energy(1,:) = [];
entropy(1,:) = [];

covN300(1,:) = [];
covN030(1,:) = [];
covN003(1,:) = [];




    %minounorm = minou./ minou(1); 
    covmaxounorm = maxou./ maxou(1); 
    covstandevnorm = standev./standev(1);  
    covcovnorm = cov./cov(1); 
    covskewnorm = skew./skew(1); 
    covkurtnorm = kurt./kurt(1);  
    covenergynorm = energy./energy(1); 
    coventropynorm = entropy./entropy(1); 
    

end


