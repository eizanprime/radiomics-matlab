% Mesure les caractéristiques issues des GLDM
% Coarseness, Contrast, Busyness, Complexity, Strength

function [GLDMstats, label] = GLDM_features(GLDMatrice)

    % Parameters
    epsilon= 1e-10;
    E = sum(GLDMatrice(:,3));
    % GL = size(GLDMmatrice(:,1),1);
    echelleNDG = min(find(GLDMatrice(:,1)~=0)):max(find(GLDMatrice(:,1)~=0));
    GL = size(echelleNDG,2); %NdG rééllement utilisés
    
    GLDMmatrice2 = GLDMatrice(echelleNDG(1):echelleNDG(end),:); %removing intensity before min tumor and after max
    
    [i,j] = meshgrid(echelleNDG(1):echelleNDG(end),echelleNDG(1):echelleNDG(end));
    j = j(:); i = i(:);
    [pi,pj] = meshgrid(GLDMmatrice2(:,1));
    pj = pj(:); pi = pi(:);    
    [si,sj] = meshgrid(GLDMmatrice2(:,2));
    sj = sj(:); si = si(:);  

    index = and((pi~=0),(pj~=0)); % proba non nul
        
    % Coarseness
    coarseness = 1/(epsilon + sum(GLDMmatrice2(:,1).*GLDMmatrice2(:,2)));

    % Contrast
    contrast = (1/(E*(GL*(GL-1)))) * (sum(pi(index).*pj(index).* ...
        (i(index)-j(index)).^2)) * sum(GLDMmatrice2(:,2));

    % Busyness
    busyness = sum(GLDMmatrice2(:,1).*GLDMmatrice2(:,2)) / ((sum(i(index).* ...
        pi(index)-j(index).*pj(index))));

    % Complexity
    complexity = sum(pi(index) .* si(index) + pj(index) .* sj(index)) .* ...
        sum(abs(i(index)-j(index))./(E*(pi(index) + pj(index))));

    % Strength
    strength =  sum((pi(index)+pj(index)).*(i(index)-j(index)).^2) / ...
        (epsilon + sum(GLDMmatrice2(:,2)));

	% ------------------- insert features --------------------------------
    GLDMstats = [coarseness, contrast, busyness, complexity, strength];
    label = GLDM_label(); 
end 