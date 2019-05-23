% Compute the Gray level size zone matrix
% GLCM_compute(I)
%
% Output:
% GLSZMatrices : Gray level size zone matrix
%
% Input:
% I = the 3D image matrix

function GLSZMatrice = GLSZM_compute(I)

% ************* Variable initialization/Declaration ***********************
    GLSZMatrice = zeros(max(I(:)), max(size(I)));

% ************************* Beginning analysis ****************************
    for idx_intensity = 1:max(I(:))
        mat_isintensity = (I==idx_intensity);
        mat_connection = bwlabeln(mat_isintensity, 26); % allow the max connectivity

        for idx_group = 1:max(mat_connection(:))
            if size(GLSZMatrice,2)< length(find(mat_connection== idx_group))
                GLSZMatrice(idx_intensity, length(find(mat_connection== idx_group))) = 1;
            else
                GLSZMatrice(idx_intensity, length(find(mat_connection== idx_group))) = ...
                    GLSZMatrice(idx_intensity, length(find(mat_connection== idx_group))) +1;
            end
        end
    end
    
    % Elimination of non-tumors voxels
    % GLSZMatrice(1,:) = [];
    
    % GLSZM get normalized 
    % GLSZMatrice = GLSZMatrice/sum(GLSZMatrice(:));    
return