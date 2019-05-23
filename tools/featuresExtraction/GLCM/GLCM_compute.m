% Compute all the 3D Cooccurrence matrices
%
% Output:
% GLCMatrices : Cooccurrence matrix
% GLCM_compute(I, distance, numLevels, offSet)
%
% Input:
% I: the 3D image matrix
% distance: a nx1 array of distances
% numLevels: the number of graylevels to be used
% offSet: a nx3 array of direction offsets in [row, column, vertical]
% the standard 2D directions :
% [0 1 0] 0 degrees
% [1 1 0] 45 degrees
% [1 0 0] 90 degrees
% [1 -1 0] 135 degrees
% the standard 3D directions :
% [0 1 1]   0 degrees, 45 degrees
% [0 0 1]   straight up
% [0 -1 1]   0 degrees, 45 degrees
% [1 0 1]  90 degrees, 45 degrees
% [-1 0 1]   90 degrees, 135 degrees
% [-1 1 -1]  45 degrees, 45 degrees
% [1 -1 -1]  45 degrees, 135 degrees
% [-1 -1 -1] 135 degrees, 45 degrees
% [1 1 -1]   135 degrees, 135 degrees

% [0 0 1]   straight up
% [0 1 1]   0 degrees, 45 degrees

% [0 -1 1]   0 degrees, 45 degrees
% [1 0 1]  90 degrees, 45 degrees
% [-1 0 1]   90 degrees, 135 degrees
% [-1 1 -1]  45 degrees, 45 degrees
% [1 -1 -1]  45 degrees, 135 degrees
% [-1 -1 -1] 135 degrees, 45 degrees
% [1 1 -1]   135 degrees, 135 degrees


function GLCMatrices = GLCM_compute(A, d, offSet)
% ************* Variable initialization/Declaration ***********************
    numLevels = max(A(:));
    numDir = size(offSet,1); % number of directions, currently 13
    GLCMatrices = zeros(numLevels,numLevels,numDir+1);

% ************************* Beginning analysis ****************************
    % Order of loops: Direction, slice, graylevel, graylevel locations
	for direction = 1:numDir % 13 for the 3D images

        tmpMat = zeros(numLevels,numLevels,size(A,3));
        for slicej = 1:size(A,3)
        	for j = 1:numLevels 
            	% finds all the instances of that graylevel
                [rowj,colj] = find(A(:,:,slicej)==j);  

                % populating the Cooc matrix.
                for tempCount = 1:size(rowj,1) 
                	rowT = rowj(tempCount) + d*offSet(direction,1);
                    colT = colj(tempCount) + d*offSet(direction,2);
                    sliceT = slicej+d*offSet(direction,3);
                    [I1, I2, I3] = size(A);

                    if rowT <= I1 && colT <= I2 && sliceT <= I3
                        if rowT > 0 && colT > 0 && sliceT > 0
                            % Error checking for NANs and Infinite numbers
                            IIntensity = A(rowT,colT,sliceT);
                            if ~isnan(IIntensity) && ~isinf(IIntensity) && IIntensity~=0
                                tmpMat(j,IIntensity,slicej) = tmpMat(j,IIntensity,slicej)+1;
                            end
                        end                      
                    end                
                end    

        	end
        end

        for slicej = 1:size(A,3)
        	GLCMatrices(:,:,direction) = GLCMatrices(:,:,direction)+tmpMat(:,:,slicej);        
        end
	end

%     % Elimination of non-tumors voxels
%     GLCMatrices(1,:,:) = [];
%     GLCMatrices(:,1,:) = [];


%    GLCM get normalized 
    for tmpI = 1:numDir
        tmpMat = GLCMatrices(:,:,tmpI);
        GLCMatrices(:,:,tmpI) = tmpMat/sum(tmpMat(:));       
    end
    
    % ****************** Calcul de la matrice moyenne *************************
    coocMean = zeros(size(GLCMatrices,1), size(GLCMatrices,2));
    for dir = 1:size(GLCMatrices,3)           
        coocMean = (coocMean + GLCMatrices(:,:,dir));           
    end
    
    GLCMatrices(:,:,end) = coocMean/(size(offSet,1));
return