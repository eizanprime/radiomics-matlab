function [exam3D, info3D] = gestionCtPerso(pathExam)    
    files = ls(pathExam);
    files(1:2, :) = [];
    
    if strcmp(files(end,:), 'rt.dcm    ')
        files(end, :) = [];
    end
    % Initialisation
    nSlice = size(files,1);
    sizeSlice = size(dicomread([pathExam '\' files(1,:)]));
    exam3D = double(zeros([sizeSlice, nSlice]));
    info3D = cell(1,nSlice);  

    % Ajout des coupes l'une après l'autre
    jSlice = single(zeros(1,nSlice));  
    for iSli = 1:nSlice
        tmpInfo = dicominfo([pathExam '\' files(iSli,:)]);
        jSlice(iSli) = tmpInfo.ImagePositionPatient(3);

        exam3D(:,:,iSli) = dicomread([pathExam, '\', files(iSli,:)]);
        try
            % Get calibration factor  Rescale slope Attribute Name in DICOM 
            exam3D(:,:,iSli) = exam3D(:,:,iSli).*tmpInfo.RescaleSlope + tmpInfo.RescaleIntercept;
        end
        info3D{1,iSli} = tmpInfo;
    end

    [~, zOrder] = sort(jSlice,'descend');
    exam3D = exam3D(:,:,zOrder);
    info3D = info3D(1,zOrder);
end