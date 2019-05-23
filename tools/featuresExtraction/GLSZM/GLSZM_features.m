% Mesure les caractéristiques issues des GLSZM
% SZE LZE LGZE HGZE SZLGE SZHGE LZLGE LZHGE ZP GLNUz ZLNU

function [GLSZMstats, label] = GLSZM_features(GLSZMatrice)

    % ------------------- Parameters ------------------- 
    i_vector = 1:size(GLSZMatrice,1); % Gray-Level Vector
    j_vector = 1:size(GLSZMatrice,2); % Zone-Length Vector

    p_i = sum(GLSZMatrice'); % Gray-Level Zone-Number Vector
    p_j = sum(GLSZMatrice); % Zone-Length Zone-Number Vector

    [i_matrix,j_matrix] = meshgrid(i_vector,j_vector);
    i_matrix = i_matrix'; j_matrix=j_matrix'; % !!

    theta = (sum(GLSZMatrice(:))); % Total number of zones

    % ------------------- Short Zone Emphasis (SZE) -------------------
    SZE = sum(p_j./(j_vector.^2))/theta;

    % ------------------- Long Zone Emphasis (LZE) --------------------
    LZE = sum(p_j.*(j_vector.^2))/theta;

    % ------------------- Low Gray-Level Zone Emphasis (LGZE) ---------
    LGZE = sum(p_i./(i_vector.^2))/theta;

    % ------------------- High Gray-Level Zone Emphasis (HGZE) --------
    HGZE = sum(p_i.*i_vector.^2)/theta;

    % ------------------- Short Zone Low Gray-Level Emphasis (SZLGE) --
    SZLGE = sum(sum(GLSZMatrice./(j_matrix.^2.*i_matrix.^2)))/theta;

    % ------------------- Short Zone High Gray-Level Emphasis (SZHGE) -
    SZHGE = sum(sum(GLSZMatrice.*(i_matrix.^2./j_matrix.^2)))/theta;

    % ------------------- Long Zone High Gray-Level Emphasis (LZLGE) --
    LZLGE = sum(sum(GLSZMatrice.*(j_matrix.^2./i_matrix.^2)))/theta;

    % ------------------- Long Zone Low Gray-Level Emphasis (LZLGE) ---
    LZHGE = sum(sum(GLSZMatrice.*i_matrix.^2.*j_matrix.^2))/theta;

    % ------------------- Gray-Level Nonuniformity (GLNUz) ------------
    GLNUz = sum(p_i.^2)/theta;

    % ------------------- Zone Length Nonuniformity (ZLNU) ------------
    ZLNU = sum(p_j.^2)/theta;

    % ------------------- Zones Percentage (ZP) -----------------------
    tmp_ZP = GLSZMatrice.*j_matrix;
    ZP = theta/sum(tmp_ZP(:));
    
	% ------------------- insert features -----------------------------
    GLSZMstats = [SZE LZE LGZE HGZE SZLGE SZHGE LZLGE LZHGE GLNUz ZLNU ZP];
    label = GLSZM_label();    
end 