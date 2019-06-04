%clear; clc;
%warning('off','all');

% Parameters
path_scan = '/home/eizanprime/Documents/NEW_TFE/DATA/OneDrive_1_5-19-2019/DOI3/'; % To change  //folder with the .mats
HU_range = [-1024, 1024]; % Hounsfield unit limit for normalization
spacing = [1, 1, 1];
bit_req = 32;
offset = [1 0 0; 0 1 0; 1 1 0; 1 -1 0; 0 0 1; 0 1 1; 0 -1 1; -1 0 1; ...
    1 0 1; 1 1 1; 1 -1 1; 1 -1 -1; 1 1 -1]; % direction for texture matrices %shit is also usefull for the mathematical covariance meme, thanks dr Paul
distance = 1;

% Labels
fOrder_labels = fOrder_label();  
glcm_labels = GLCM_label(1);
gldm_labels = GLDM_label();
glrlm_labels = GLRLM_label(1);
glszm_labels = GLSZM_label();
xLabels = cat(2, fOrder_labels, glcm_labels, gldm_labels, glrlm_labels, glszm_labels);

x_feat = []; %x_feat contains all the features
x_feat_utile = []; %x feat utile only contains the ones that have the tumour volutem above 10cm3
patients_list = dir(path_scan); 
patients_list = patients_list(3:end);

x_feat_patientNaymes = []; %the patient names corresponding to each line
x_feat_utile_patientNaymes = [];

morpholabels = {}; %yes I finally make those labels lol

for iPat = 1:size(patients_list, 1) % Patients iteration
    tic;
    %% Path Management
    patient_name = patients_list(iPat).name;
    load([path_scan, '/', patient_name]); % ct and roi   //to change te '\' if you are on windows
    disp(patient_name);

    % CT normalization between -1024 et 1024 HU
    ct_norm = (ct - HU_range(1))/(HU_range(2)-HU_range(1)); 
    ct_norm(ct_norm>1) = 1;
    ct_norm(ct_norm<0) = 0;
                
    % FIRST ORDER FEATURES
    fOrder_feats = fOrderFeatCT(ct, roi, spacing); % Compute first order features

    exam3DPos = ct_norm*255;   %before doing mathematical morphology we normalize to 0 to 255 in order for it to work better with the mathematical morphology implementation of matlab
    %exam3DMasked = exam3DPos .* roi_red;
    %exam3DMaskedReduit = boiteMin3D(exam3DMasked, roi_red);
    exam3Duint8 = uint8(exam3DPos);
    %exam3DMaskeduint8 = uint8(exam3DMasked);
    %[exam3Dreduit, maskreduit] = boiteMin3D(exam3DPos, roi_red);
    %exam3Duint8reduit = ct_norm
    maskreduituint = uint8(roi);
    
    [vectogran, vectoantigran, N300, N030, N003, maxounorm,standevnorm,covnorm,skewnorm,kurtnorm,energynorm, entropynorm] = granularity(exam3Duint8, 9, maskreduituint); %granularity function made by nicolas
    
    [covolume,covN300, covN030, covN003,maxounorm,standevnorm,covnorm,skewnorm,kurtnorm,energynorm, entropynorm] = morphcovariance(exam3Duint8, 9, maskreduituint, offset);
    %computes the granularity as presented in the paper, as well as
    %antigranularity and granular moments, both in absolute scale and
    %normalized ! 
    mygrantableau = [vectogran;vectoantigran;N300; N030;N003;maxounorm;standevnorm;covnorm;skewnorm;kurtnorm;energynorm;entropynorm;covolume;covN300;covN030;covN003;maxounorm;standevnorm;covnorm;skewnorm;kurtnorm;energynorm; entropynorm];
    mygranconcattableau = mygrantableau(:);
    [width, height ]= size(mygrantableau);
    
    
    % TEXTURE INDICES   %Higher order texture analysis by Dr Paul ! 
    % Check if the tumor volume is > 10cm3, or textures are non-sense
    if fOrder_feats(2) > 10       
        % Resample ct intensities into a limit number of value 
        ct_resamp = zeros(size(ct));
        
        intNew = 1/bit_req:1/bit_req:1;
        for iInt = 1:size(intNew,2)
            ct_resamp(ct_norm >= intNew(iInt)) = iInt;
        end
        
        % COOCCURRENCE MATRIX FEATURES
        GLCMatrices = GLCM_compute(ct_resamp, distance, offset);   
        GLCMatrices = GLCMatrices(:,:,14);  % Keep only the mean matrix (correlations)
        GLCMfeat = GLCM_features(GLCMatrices,2);
        GLCMfeat2 = GLCMfeat'; GLCMfeat2 = GLCMfeat2(:)';

        % GRAY LEVEL DIFFERENCE MATRIX FEATURES
        GLDMatrice = GLDM_compute(ct_resamp);
        GLDMfeat = GLDM_features(GLDMatrice);

        % GRAY LEVEL RUN LENGTH MATRIX FEATURES
        GLRLMatrices = GLRLM_compute(ct_resamp, distance, offset);
        GLRLMatrices = GLRLMatrices(:,:,14);  % Keep only the mean matrix (correlations)
        GLRLMfeat = GLRLM_features(GLRLMatrices, 2);
        GLRLMfeat2 = GLRLMfeat'; GLRLMfeat2 = GLRLMfeat2(:)';

        % GRAY LEVEL SIZE ZONE MATRIX FEATURES
        GLSZMatrice = GLSZM_compute(ct_resamp);
        GLSZMfeat = GLSZM_features(GLSZMatrice);
        
        x_feat = [x_feat; fOrder_feats, GLCMfeat2, GLDMfeat, GLRLMfeat2, GLSZMfeat, mygranconcattableau(:)']; 
        x_feat_utile = [x_feat_utile; fOrder_feats, GLCMfeat2, GLDMfeat, GLRLMfeat2, GLSZMfeat, mygranconcattableau(:)'];
        
        
        x_feat_patientNaymes = [x_feat_patientNaymes; patient_name]
        x_feat_utile_patientNaymes = [x_feat_utile_patientNaymes; patient_name]
        
        %ad the morphological labels
        
        if(isempty(morpholabels)) 
            iteratoor = 1;
            cellofarrays = {vectogran; vectoantigran;N300;N030;N003; maxounorm; standevnorm; covnorm; skewnorm; kurtnorm; energynorm; entropynorm; covolume; covN300; covN030; covN003;covmaxounorm;covstandevnorm;covcovnorm;covskewnorm;covkurtnorm;covenergynorm; coventropynorm};
            cellofstrings = {'vectogran'; 'vectoantigran'; 'N300';'N030';'N003'; 'maxounorm'; 'standevnorm'; 'covnorm'; 'skewnorm'; 'kurtnorm'; 'energynorm'; 'entropynorm'; 'covolume'; 'covN300'; 'covN030'; 'covN003' ;'covmaxounorm';'covstandevnorm';'covcovnorm';'covskewnorm';'covkurtnorm';'covenergynorm'; 'coventropynorm'};
            for type=1: size(cellofstrings, 1)
                for iterangle =1:size(cellofarrays{type,1}, 1)
                    for iteriter = 1:size(cellofarrays{type,1}, 2)
                        morpholabels{iteratoor} = char([cellofstrings{type,1}, '_', num2str(iterangle), '_', num2str(iteriter)]);
                        iteratoor = iteratoor + 1;
                    end
                end
            end
            xLabelsMorph = [xLabels, morpholabels];
            
        end
        
        
    else
        % sinon les textures sont NaN
         x_feat = [x_feat; fOrder_feats, zeros([1,37 + size(mygranconcattableau(:),1)])/0];  %37 longueur totale des vecteurs + 20
        x_feat_patientNaymes = [x_feat_patientNaymes; patient_name]
    end
    toc;
end