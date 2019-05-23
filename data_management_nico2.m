%clear; clc;
warning('off','all');

% Parameters
path_scan = '/home/eizanprime/Documents/NEW_TFE/DATA/OneDrive_1_5-19-2019/DOI3/'; % To change
spacing = [2, 2, 2];
bit_req = 32;
offset = [1 0 0; 0 1 0; 1 1 0; 1 -1 0; 0 0 1; 0 1 1; 0 -1 1; -1 0 1; ...
    1 0 1; 1 1 1; 1 -1 1; 1 -1 -1; 1 1 -1]; % direction for texture matrices
distance = 1;

% Labels
fOrder_labels = fOrder_label();
glcm_labels = GLCM_label(1);
gldm_labels = GLDM_label();
glrlm_labels = GLRLM_label(1);
glszm_labels = GLSZM_label();
xLabels = cat(2, fOrder_labels, glcm_labels, gldm_labels, glrlm_labels, glszm_labels);

x_feat = [];
x_feat_utile = [];
patients_list = dir(path_scan); 
patients_list = patients_list(3:end);
x_feat_patientNaymes = [];
x_feat_utile_patientNaymes = [];
for iPat = 1:size(patients_list, 1) % Patients iteration
    tic;
    %% Path Management
    patient_name = patients_list(iPat).name;
    load([path_scan, '/', patient_name]); % ct and roi
    disp(patient_name);
    
    % Minimal box around tumor (add margins ?)
    %tmp_ind = find(roi(:));        
    %[x, y, z] = ind2sub(size(roi), tmp_ind);
    %param = [min(x), max(x); min(y), max(y); min(z), max(z)];

    %param(:,1) = param(:,1);
    %param(:,2) = param(:,2);

    %roi_red = roi(param(1,1):param(1,2),...
    %    param(2,1):param(2,2),param(3,1):param(3,2));
    %ct_red = ct(param(1,1):param(1,2),...
    %    param(2,1):param(2,2),param(3,1):param(3,2));
    %ct_red = ct_red.*roi_red;
    
    ct_red = ct.*roi;
    roi_red = roi;
    
    %prout = min(min(min(ct_red)))
    
    %FIRST ORDER FEATURES
    fOrder_feats = fOrderFeatCT(ct_red, roi_red, spacing);
    
    
    % ADDED BY NICOLAS (like not lot lol)
    
    exam3DPos = ((ct_red + 1024)/2048)*255;
    exam3DMasked = exam3DPos .* roi_red;
    exam3DMaskedReduit = boiteMin3D(exam3DMasked, roi_red);
    exam3Duint8 = uint8(exam3DPos);
    exam3DMaskeduint8 = uint8(exam3DMasked);
    [exam3Dreduit, maskreduit] = boiteMin3D(exam3DPos, roi_red);
    exam3Duint8reduit = boiteMin3D(exam3Duint8, roi_red);
    maskreduituint = uint8(maskreduit);
    
    [vectogran, vectoantigran,maxou,standev,cov,skew,kurt,energy, entropy,maxounorm,standevnorm,covnorm,skewnorm,kurtnorm,energynorm, entropynorm] = granularity(exam3Duint8reduit, 9, maskreduituint);
    mygrantableau = [vectogran; vectoantigran; maxou; standev; cov; skew; kurt; energy; entropy; maxounorm; standevnorm; covnorm; skewnorm; kurtnorm; energynorm; entropynorm];
    [width, height ]= size(mygrantableau);
    
    
    % TEXTURE INDICES 
    % Check if the tumor volume is > 10cm3, or textures are non-sense
    if fOrder_feats(2) > 10       
        % Resample ct intensities into a limit number of value
        ct_resamp = zeros(size(ct_red));
        intNew = 1/bit_req:1/bit_req:1;
        for iInt = 1:size(intNew,2)
            ct_resamp(ct_red >= intNew(iInt)) = iInt;
        end

        % COOCCURRENCE MATRIX FEATURES
        GLCMatrices = GLCM_compute(ct_resamp, distance, offset);   
        GLCMatrices = GLCMatrices(:,:,14);  % Keep only the mean matrix (correlations) %14ieme c'set la mean
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
        
        x_feat = [x_feat; fOrder_feats, GLCMfeat2, GLDMfeat, GLRLMfeat2, GLSZMfeat, vectogran, vectoantigran,maxou,standev,cov,skew,kurt,energy, entropy,maxounorm,standevnorm,covnorm,skewnorm,kurtnorm,energynorm, entropynorm]; 
        x_feat_utile = [x_feat_utile; fOrder_feats, GLCMfeat2, GLDMfeat, GLRLMfeat2, GLSZMfeat, vectogran, vectoantigran,maxou,standev,cov,skew,kurt,energy, entropy,maxounorm,standevnorm,covnorm,skewnorm,kurtnorm,energynorm, entropynorm];
        
        
        x_feat_patientNaymes = [x_feat_patientNaymes; patient_name]
        x_feat_utile_patientNaymes = [x_feat_utile_patientNaymes; patient_name]
    else
        % sinon les textures sont NaN
        x_feat = [x_feat; fOrder_feats, zeros([1,37 + width * height])/0];  %37 longueur totale des vecteurs + 20
        x_feat_patientNaymes = [x_feat_patientNaymes; patient_name]
    end
    toc;
end