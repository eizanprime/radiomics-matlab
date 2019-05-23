% Compute the Gray level difference matrix
% GLDM_compute(Iresamp, d)
%
% Output:
% GLSZMatrice : Gray level size zone matrix
%
% Input:
% Iresamp = resampled image 
% d = distance

function GLDMatrice = GLDM_compute(Iresamp)

    s = size(Iresamp);
    s2 = s+2;
    tmp = zeros(s2);
    
    AA = zeros(s2);
    neigbMat = zeros(s2);
    A = zeros(s2); % normalized sum of neighborhood 
    IA = zeros(s); % absolute difference between a voxel and the normalized sum of its neighborhood 

    [~,~,dimen] = size(Iresamp); %2D or 3D?
    if dimen==1 % for 2D slice
        tmp(2:s2(1)-1,2:s2(2)-1) = Iresamp;
        for x=2:s2(1)-1
            for y=2:s2(2)-1
                if tmp(x,y) ~=0
                    u = tmp(x-1:x+1, y-1:y+1);

                    uu = u~=0;
                    neigbMat(x,y) = sum(uu(:))-1;                    
                    AA(x,y) = sum(u(:)) - tmp(x,y);                   
            	end
        	end
        end
        
        A = AA./neigbMat;
        A = A(2:s2(1)-1,2:s2(2)-1);
        
    else % for 3D slice
        tmp(2:s2(1)-1,2:s2(2)-1,2:s2(3)-1) = Iresamp;
        for z=2:s2(3)-1
            for x=2:s2(1)-1
                for y=2:s2(2)-1
                    if tmp(x,y,z) ~=0
                        u = tmp(x-1:x+1, y-1:y+1, z-1:z+1);

                        uu = u~=0;
                        neigbMat(x,y,z) = sum(uu(:))-1;                    
                        AA(x,y,z) = sum(u(:)) - tmp(x,y,z);                   
                    end
                end
            end
        end

        A = AA./neigbMat;
        A = A(2:s2(1)-1,2:s2(2)-1,2:s2(3)-1);
    end
    
    A(isnan(A))=0;
    IA = abs(Iresamp - A);

% ------ Creation of the GLDM  --------------------------------------------
    for u = 1:max(Iresamp(:)) % commencer à 1 élimine les zones hors tumeurs (0)
        GLDMatrice(1,u) = sum(IA(find(Iresamp==u)));
    end

    % Histogramme des fréquences des NdG N(i,1)
    for i = 1:max(Iresamp(:))
        Hist(i) = size(find(Iresamp==i),1);
    end
    p = Hist./sum(Hist); % probabilité des NdG

    GLDMatrice = [p', GLDMatrice', Hist'];
return