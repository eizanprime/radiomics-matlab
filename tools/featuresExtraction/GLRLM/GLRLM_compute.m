% Compute all the Gray level run length matrix
%
% Output:
% matrice_output : Gray level run length matrix
% GLCM_compute(I, distance, numLevels, offSet)
%
% Input:
% image = the 3D image matrix
% distance: a nx1 array of distances that will be used when analyzing the
% image.
% numLevels = the number of graylevels to be used
% offSet: a nx3 array of direction offsets in [row, column, vertical]
% the standard 2D directions :

function GLRLMatrices = GLRLM_compute(image, d, offSet)
    NL = max(image(:))+1;
    numDir = size(offSet,1); % number of directions, currently 13
    
    for iOff = 1:numDir
        % Initialisation de la GLRLM dans la direction étudiée
        HHHH = num2str([offSet(iOff,1),offSet(iOff,2), offSet(iOff,3)]);
        seq = GLRLM_seq(image,HHHH);

        n = 1;
        for k = 1:length(seq)
            nn = findmaxnum(seq{k});
            if nn>n
                n = nn;
            end
        end
        oneGLRLM = zeros(NL,n); % Taille NdG par longueur max de run

        % Début de l'analyse
        for iiSeq = 1:length(seq)
            for iSeq = 1:length(seq{iiSeq}) 
                x = seq{iiSeq}{iSeq}; % x est la sequence i du plan ii

                % run length Encode of each vector
                index = [find(abs(x(1:end-1)- x(2:end))>(d-1)), length(x)];

                len = diff([ 0 index ]); % run lengths
                val = x(index);          % run values

                try
                    temp = accumarray([val+1;len]',1,[NL n]);% compute current numbers (or contribution) for each bin in GLRLM
                    oneGLRLM = temp + oneGLRLM; % accumulate each contribution
                catch
                end
            end
        end

        % Suppression des zeros de background
        oneGLRLM(1,:) = [];

        matricesOutput{iOff} = oneGLRLM; % stoke les matrices de longueurs de plage
    end

    % Recherche longueur et largeur max des GLRLMs
    xMax = 1; yMax = 1;
    for iOff = 1:numDir
        if xMax < size(matricesOutput{iOff},1)
            xMax = size(matricesOutput{iOff},1);
        end
        if yMax < size(matricesOutput{iOff},2)
            yMax = size(matricesOutput{iOff},2);
        end
    end
    
    % Conversion en matrice de la meme taille
    GLRLMatrices = zeros(xMax,yMax,length(matricesOutput)+1);
    for iOff = 1:numDir
        tmpS = size(matricesOutput{iOff});   
        GLRLMatrices(1:tmpS(1),1:tmpS(2),iOff) = matricesOutput{iOff};    
    end
       
    % Normalized 
%     for tmpI = 1:numDir
%         tmpMat = GLRLMatrices(:,:,tmpI);
%         GLRLMatrices(:,:,tmpI) = tmpMat/sum(tmpMat(:));       
%     end
    
    % Calcul de la matrice moyenne
    glrlmMean = zeros(size(GLRLMatrices,1), size(GLRLMatrices,2));
    for iOff = 1:numDir        
        glrlmMean = (glrlmMean + GLRLMatrices(:,:,iOff));           
    end
    
    GLRLMatrices(:,:,end) = glrlmMean/numDir;
end