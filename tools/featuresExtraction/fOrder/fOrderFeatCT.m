% Mesure les caract�ristiques du 1er ordre:
% Volume en voxel, Volume en cm3, Somme des SUV, SUVmin, SUVmax, SUVmean,  
% Ecart-type, SUVpeak, COV, TLG, Skewness, Kurtosis, Sph�ricit�, Energie, 
% Entropie, D�riv�s de l'IVH (I10, I90, I1090, V10, V90, V1090)

function [statsOutput] = fOrderFeatCT(ct_red, roi_red, spacing)    
    
    % FIRST ORDER FEATURES
    roiVoxIdx = find(roi_red); % coordonn�es voxels de la ROI  
    roiVoxint = ct_red(roiVoxIdx); % intensit�s voxels de la ROI
    volVox = length(roiVoxIdx); % volume in voxel %useless for gran 1
    volML = volVox  * prod(spacing) / 1e3; % volume in mL %useless for gran 2
    sumInt = sum(roiVoxint); % intensity sum %this is volume 3
    mini = min(roiVoxint); % intensity minimum %can be used 4
    maxi = max(roiVoxint); % intensity maximum %can be used 5
    mu = mean(roiVoxint); % intensity average %this is effectively normalized volume 6
    omega = std(roiVoxint); % intensity standard deviation %usefull ! can be normalized or noot 7
    COV = omega/mu; % covariance % can be usefulll 8
    skew = skewness(roiVoxint); % skewness %can be usefull 9
    kurt = kurtosis(roiVoxint); % Kurtosys % can be usefull 10
    
    % probabilities law
    pbb_law = unique(roiVoxint);
    pbb_law = sort(pbb_law);

    p = []; 
    for j=1:size(pbb_law,1)
        int = pbb_law(j);    
        tmp = size(find(roiVoxint==int),1)/size(roiVoxint,1);
        p = [p; tmp];
    end

    entrop = 0; energ = 0;
    for i = 1:size(pbb_law,1)
        energ = energ + p(i).^2;  % usefull ! 11
        if p(i)~=0
            entrop = entrop  + p(i) * log2(p(i));
        end
    end
    entrop = -entrop; % usefull 12
    
    % SHAPE FEATURES
    % Sphericity % usefull
    [~, S] = surf_perso(ct_red~=0);   
    V = size(find(ct_red~=0),1);
    H = (1\(36*pi)) * (S^3\V^2);
    ASP = (H)^(1/3) - 1;
    spheri = 1 / (1 + ASP); %not usefull 13

    statsOutput = [volVox, volML, sumInt, mini, maxi, mu, omega, COV, skew, kurt, energ, entrop, spheri];
end