% Mesure les caractéristiques issues des GLRLM
% SRE LRE LGRE HGRE SRLGE SRHGE LRLGE LRHGE RP GLNUr RLNU

function [GLRLMstats, GLRLMlabels] = GLRLM_features(GLRLMatrices, option)

    GLRLMstats = [];   
    for numDir = 1:size(GLRLMatrices,3) % directions   
        % ------------------- Parameters ------------------- 
        GLRLM = GLRLMatrices(:,:,numDir);
        
        i_vector = 1:size(GLRLM,1); % Gray-Level Vector
        j_vector = 1:size(GLRLM,2); % Zone-Length Vector

        p_i = sum(GLRLM'); % Gray-Level Zone-Number Vector
        p_j = sum(GLRLM); % Zone-Length Zone-Number Vector

        [i_matrix,j_matrix] = meshgrid(i_vector,j_vector);
        i_matrix = i_matrix'; j_matrix=j_matrix'; % !!

        theta = (sum(GLRLM(:))); % Total number of runs
        
%%%%%%%%%%%%%%%%%%%% Calculations %%%%%%%%%%%%%%%%%%%%   

        % ------------------- Short Zone Emphasis (SZE) -------------------
        SRE = sum(p_j./(j_vector.^2))/theta;

        % ------------------- Long Zone Emphasis (LZE) --------------------
        LRE = sum(p_j.*(j_vector.^2))/theta;

        % ------------------- Low Gray-Level Zone Emphasis (LGZE) ---------
        LGRE = sum(p_i./(i_vector.^2))/theta;

        % ------------------- High Gray-Level Zone Emphasis (HGZE) --------
        HGRE = sum(p_i.*i_vector.^2)/theta;

        % ------------------- Short Zone Low Gray-Level Emphasis (SZLGE) --
        SRLGE = sum(sum(GLRLM./(j_matrix.^2.*i_matrix.^2)))/theta;

        % ------------------- Short Zone High Gray-Level Emphasis (SZHGE) -
        SRHGE = sum(sum(GLRLM.*(i_matrix.^2./j_matrix.^2)))/theta;

        % ------------------- Long Zone High Gray-Level Emphasis (LZLGE) --
        LRLGE = sum(sum(GLRLM.*(j_matrix.^2./i_matrix.^2)))/theta;

        % ------------------- Long Zone Low Gray-Level Emphasis (LZLGE) ---
        LRHGE = sum(sum(GLRLM.*i_matrix.^2.*j_matrix.^2))/theta;

        % ------------------- Gray-Level Nonuniformity (GLNUz) ------------
        GLNUr = sum(p_i.^2)/theta;

        % ------------------- Zone Length Nonuniformity (ZLNU) ------------
        RLNU = sum(p_j.^2)/theta;

        % ------------------- Zones Percentage (ZP) -----------------------
        tmp_RP = GLRLM.*j_matrix;
        RP = theta/sum(tmp_RP(:));

        % ------------------- insert features -----------------------------
        tmpFeat = [SRE LRE LGRE HGRE SRLGE SRHGE LRLGE LRHGE GLNUr RLNU RP];              
        GLRLMstats = [GLRLMstats; tmpFeat];
    end
    
    GLRLMlabels = GLRLM_label(option);
end 