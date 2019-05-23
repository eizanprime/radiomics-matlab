function [ROImask, ROIName] = readRTstructuresPerso3(rtssheader, imgheaders, iSeg)

xfm = getAffineXfm(imgheaders);

dimmin = [0 0 0 1]';
dimmax = double([imgheaders{1}.Columns-1 imgheaders{1}.Rows-1 length(imgheaders)-1 1])';

ROImask = false([imgheaders{1}.Columns imgheaders{1}.Rows length(imgheaders)]);
ROIContourSequence = fieldnames(rtssheader.ROIContourSequence);

%% Loop through contours
ROIName = rtssheader.StructureSetROISequence.(ROIContourSequence{iSeg}).ROIName;
try
    contourSequence = fieldnames(rtssheader.ROIContourSequence.(ROIContourSequence{iSeg}).ContourSequence);
    
    %% Loop through segments (slices)
    segments = cell(1,length(contourSequence));
    for j = 1:length(contourSequence)
        if strcmp(rtssheader.ROIContourSequence.(ROIContourSequence{iSeg}).ContourSequence.(contourSequence{j}).ContourGeometricType, 'CLOSED_PLANAR')
            %% Read points
            segments{j} = reshape(rtssheader.ROIContourSequence.(ROIContourSequence{iSeg}).ContourSequence.(contourSequence{j}).ContourData, ...
                3, rtssheader.ROIContourSequence.(ROIContourSequence{iSeg}).ContourSequence.(contourSequence{j}).NumberOfContourPoints)';
            
            %% Make lattice
            points = xfm \ [segments{j} ones(size(segments{j},1), 1)]';
            start = xfm \ [segments{j}(1,:) 1]';
            minvox = max(floor(min(points, [], 2)), dimmin);
            maxvox = min( ceil(max(points, [], 2)), dimmax);
            minvox(3) = round(start(3));
            maxvox(3) = round(start(3));
            [x,y,z] = meshgrid(minvox(1):maxvox(1), minvox(2):maxvox(2), minvox(3):maxvox(3));
            points = xfm * [x(:) y(:) z(:) ones(size(x(:)))]';
            
            %% Make binary image
            in = inpolygon(points(1,:), points(2,:), segments{j}(:,1), segments{j}(:,2));
            ROImask((minvox(1):maxvox(1))+1, (minvox(2):maxvox(2))+1, (minvox(3):maxvox(3))+1) = permute(reshape(in, size(x)), [2 1]);
        end
    end
catch ME
    % Don't display errors about non-existent fields.
    if ~strcmp(ME.identifier, 'MATLAB:nonExistentField')
        warning(ME.identifier, ME.message);
    end
end

% transp
for iSli = 1:size(ROImask,3)
    ROImask(:,:,iSli) = ROImask(:,:,iSli)';
end