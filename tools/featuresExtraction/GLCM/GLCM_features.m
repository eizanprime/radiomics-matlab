% Mesure les caractéristiques d'Haralick (GLCM)
% Energy, Entropy, Dissimilarity, Contrast, Homogeneity, IDM, 
% Variance, Cluster Shade, Cluster Tendendy, Correlation, 
% Mean,  Intensity, Variance Inverse

function [GLCMstats, GLCMlabels] = GLCM_features(GLCMatrices, option)

    GLCMstats = [];   
    for numDir = 1:size(GLCMatrices,3) % directions          
        % ------------------- Parameters ------------------- 
        GLCM = GLCMatrices(:,:,numDir);

        s = size(GLCM);
        [y, x] = meshgrid(1:s(1),1:s(2));
        x = x(:); 
        y = y(:);

        mux = (x-1) .* GLCM(:);
        mux = sum(mux);
        muy = (y-1) .* GLCM(:);
        muy = sum(muy);
        Sx = (x - 1 - mux).^2 .* GLCM(:); Sx = sum(Sx);
        Sy = (y - 1 - muy).^2 .* GLCM(:); Sy = sum(Sy);

        % ------------------- Energy (or ASM) -----------------
        tmpEnergy = GLCM.^2;
        energy = sum(tmpEnergy(:));

        % ------------------- Entropy -------------------------
        tmpEntrop = GLCM.*log10(GLCM);
        tmpEntrop(isnan(tmpEntrop)) = 0;
        entropy = - sum(tmpEntrop(:));

        % ------------------- Dissimilarity ------------------- 
        tmpDissi = abs(x - y) .* GLCM(:);
        dissimilarity = sum(tmpDissi);

        % ------------------- Constrast (Inertia) -------------
        tmpContr = ((x - y).^2) .* GLCM(:);
        contrast = sum(tmpContr);

        % ------------------- Homogeneity ---------------------
        tmpHomo = GLCM(:) ./ (1 + abs(x - y));
        homogeneity = sum(tmpHomo);

        % ------------------- Inverse Difference Moment  ------
        tmpIDM = GLCM(:) ./ (1 + (x - y).^2);
        IDM = sum(tmpIDM);

        % ------------------- Variance ------------------------
        tmpVar = ((x-mux).^2 + (y-muy).^2) .* GLCM(:);
        variance = sum(tmpVar);

        % ------------------- Cluster Shade ------------------- 
        tmpCS = (x + y - mux - muy).^3 .* GLCM(:);
        CS = sum(tmpCS);

        % ------------------- Cluster Tendency (Prominence) ---
        tmpCT = (x + y - mux - muy).^4 .* GLCM(:);
        CT = sum(tmpCT);

        % ------------------- Correlation ---------------------
        tmpCorr = (x - 1 - mux) .* (y - 1 - muy) .* GLCM(:);
        correlation = sum(tmpCorr) / sqrt(Sx * Sy);

%         % Intensity
%         tmpIntens = (x .* y) .* GLCMatrices(:);
%         intensity = sum(tmpIntens);

%         % Mean
%         tmpMean = (x+y) .* GLCM(:);
%     	  Mean = sum(tmpMean);

%         % Inverse Variance
%         tmpVI = (x-y).^2;
%         tmpVI(find(tmpVI==0)) = NaN;
%         tmpVI = GLCM(:) ./ tmpVI;
%         tmpVI(isnan(tmpVI)) = 0;
%         invVariance = sum(tmpVI);

        % ------------------- insert features ------------------
        tmpFeat = [energy, entropy, dissimilarity, contrast, ...
            homogeneity, IDM, variance, CS, CT, correlation];
               
        GLCMstats = [GLCMstats; tmpFeat];
    end
    
    GLCMlabels = GLCM_label(option);
return