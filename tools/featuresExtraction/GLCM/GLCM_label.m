function label = GLCM_label(option)

    label = {'Energy_GLCM' 'Entropy_GLCM' 'Dissimilarity_GLCM' 'Contrast_GLCM'   ...
              'Homogeneity_GLCM' 'IDM_GLCM' 'Variance_GLCM' 'Cluster Shade_GLCM' ...
              'Cluster Tendendy_GLCM' 'Correlation_GLCM'};  
        
    if option == 2      
        offSet = [0 1 0; 0 1 -1; 0 -1 -1; 0 0 -1; ...
            -1 1 0; -1 0 0; -1 -1 0; -1 0 -1; -1 1 -1; -1 -1 -1; ...
            1 0 -1;  1 -1 -1;  1 1 -1];

        tmpC = 1;
        tmpLab = {};
        for i = 1:size(offSet,1)+1 % parcours des directions 
            
            for j = 1:size(label,2) % parcours des features
                tmp = label;
                if i ~= size(offSet,1)+1    
                    tmpLab{tmpC} = strcat([tmp{j}, ' ', num2str(offSet(i,:))]);
                else
                    tmpLab{tmpC} = strcat([tmp{j}, ' mean ']);
                end
                tmpC = tmpC+1;            
            end
           
                
        end
        
        label = tmpLab;
    end
    
end