function [vectogran, vectoantigran,maxou,standev,cov,skew,kurt,energy, entropy,maxounorm,standevnorm,covnorm,skewnorm,kurtnorm,energynorm, entropynorm] = granularity(vol3d, numiter, maskreduit)

maskreversed255 = uint8(uint8(~maskreduit).*uint8(255));


vol3d = vol3d + maskreversed255; %for the fucking padding

tmpmasked = vol3d.*maskreduit;
vol3danti = tmpmasked;
baseVol = sum(sum(sum(tmpmasked)));
vectogran = 1;
vectoantigran = 1;

firstOrder = fOrderFeatCT(single(vol3d), single(maskreduit), [1, 1, 1]);

%minou = firstOrder(4);
maxou = firstOrder(5);
standev = firstOrder(7);
cov = firstOrder(8);
skew = firstOrder(9);
kurt = firstOrder(10);
energy = firstOrder(11);
entropy = firstOrder(12);





%sizetmp=size(tmpmasked)
%slice = vol3d(:,:,floor(sizetmp(3)/2));
%image(slice,'CDataMapping','scaled');
%figure(1)
for iIter = 1:numiter
    se = strel('sphere', iIter);
    tmp1 = imerode(vol3d, se); %opening is erosion + dilatation
    %tmp2 = tmp1
    tmp1 = tmp1.*maskreduit;
    tmp1 = imdilate(tmp1, se);
    tmp1 = tmp1.*maskreduit;
    %tmpmasked = tmp1.*maskreduit
    voltmp1 = sum(sum(sum(tmp1)));
    %sizetmp = size(tmp1);
    %slice = tmp1(:,:,floor(sizetmp(3)/2));
    %slice2 = tmp2(:,:,floor(sizetmp(3)/2));
    %image(slice,'CDataMapping','scaled')
    %figure(iIter + 1)
    %image(slice2,'CDataMapping','scaled')
    %figure(20 + iIter + 1)
    vectogran = [vectogran, voltmp1/ baseVol];
    antmp1 = imdilate(vol3danti, se);
    antmp1 = antmp1 + maskreversed255;
    antmp1 = imerode(antmp1, se);
    antmp1 = antmp1 .* maskreduit;
    volantmp1 = sum(sum(sum(antmp1)));
    vectoantigran = [vectoantigran, volantmp1/ baseVol];
    
    firstOrder = fOrderFeatCT(single(tmp1), single(maskreduit), [1, 1, 1]);
    
    %minou = [minou, firstOrder(4)];  
    maxou = [maxou, firstOrder(5)];
    standev = [standev, firstOrder(7)];
    cov = [cov, firstOrder(8)];
    skew = [skew, firstOrder(9)];
    kurt = [kurt, firstOrder(10)];
    energy = [energy, firstOrder(11)];
    entropy = [entropy, firstOrder(12)];
    
end
vectogran;
vectoantigran;



    %minounorm = minou./ minou(1); 
    maxounorm = maxou./ maxou(1); 
    standevnorm = standev./standev(1);  
    covnorm = cov./cov(1); 
    skewnorm = skew./skew(1); 
    kurtnorm = kurt./kurt(1);  
    energynorm = energy./energy(1); 
    entropynorm = entropy./entropy(1); 
    
    
    
    for iIter = 1:numiter
    se = strel('sphere', iIter);
    tmp1 = imerode(vol3d, se); %opening is erosion + dilatation
    %tmp2 = tmp1
    tmp1 = tmp1.*maskreduit;
    tmp1 = imdilate(tmp1, se);
    tmp1 = tmp1.*maskreduit;
    %tmpmasked = tmp1.*maskreduit
    voltmp1 = sum(sum(sum(tmp1)));
    %sizetmp = size(tmp1);
    %slice = tmp1(:,:,floor(sizetmp(3)/2));
    %slice2 = tmp2(:,:,floor(sizetmp(3)/2));
    %image(slice,'CDataMapping','scaled')
    %figure(iIter + 1)
    %image(slice2,'CDataMapping','scaled')
    %figure(20 + iIter + 1)
    vectogran = [vectogran, voltmp1/ baseVol];
    antmp1 = imdilate(vol3danti, se);
    antmp1 = antmp1 + maskreversed255;
    antmp1 = imerode(antmp1, se);
    antmp1 = antmp1 .* maskreduit;
    volantmp1 = sum(sum(sum(antmp1)));
    vectoantigran = [vectoantigran, volantmp1/ baseVol];
    
    firstOrder = fOrderFeatCT(single(tmp1), single(maskreduit), [1, 1, 1]);
    
    %minou = [minou, firstOrder(4)];  
    maxou = [maxou, firstOrder(5)];
    standev = [standev, firstOrder(7)];
    cov = [cov, firstOrder(8)];
    skew = [skew, firstOrder(9)];
    kurt = [kurt, firstOrder(10)];
    energy = [energy, firstOrder(11)];
    entropy = [entropy, firstOrder(12)];
    
end
    

end


