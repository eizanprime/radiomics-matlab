clear; clc;
warning('off','all');

% Parameters
path_scan = 'E:\Data\data_NSCLC\DOI\'; % To change
path_save = 'E:\Data\data_NSCLC\DOI2\'; % To change

HU_range = [-1024, 1024]; % Hounsfield unit limit for normalization
reso_req = [2; 2; 2]; % Required resolution 
reso_method = 'triangle';
FOV_req = [250; 250]; % Field of view required

patients_list = dir(path_scan); 
patients_list = patients_list(3:end); % patients list Struct N*1
for iPat = 1:size(patients_list, 1) % Patients iteration
    tic;
    %% Path Management
    patient_name = patients_list(iPat).name;
    disp(patient_name);
    
    % Management CT/RT paths
    tmpA = dir([path_scan '\' patient_name]);
    tmpB = dir([path_scan '\' patient_name '\' tmpA(3).name]);

    for j=3:4
        tmp_path = [path_scan '\' patient_name '\' tmpA(3).name '\' tmpB(j).name];
        if (size(dir(tmp_path),1)-2)==1
            path_RTCT = tmp_path;
        end
        if (size(dir(tmp_path),1)-2)>1
            path_CT = tmp_path;
        end
    end    
    
    %% Data Management
    % CT management
    [ct_ini, ct_infos] = gestionCtPerso(path_CT);
     
    % ROI management
    file_name = ls(path_RTCT);  
    rt_infos = dicominfo([path_RTCT '\' file_name(3,:)]);    
    roi_contour_sequence = fieldnames(rt_infos.ROIContourSequence);
%     roi_ini_name = rt_infos.StructureSetROISequence.(roi_contour_sequence{1}).ROIName;
    roiIni = readRTstructuresPerso3(rt_infos, ct_infos, 1);
    
    %% Data preprocessing    
    % Rescale voxel resolution to (1,1,1)mm3
    tmp_info = ct_infos{1,1};
    resol_vox = double([tmp_info.PixelSpacing', tmp_info.SliceThickness]'); % current vox resolution    
    nb_vox = double([tmp_info.Width tmp_info.Height size(ct_infos,2)]'); % current vox nb
    FOV = round(resol_vox.*nb_vox./reso_req); % current FOV
   
    ct_resize = imresize3D(ct_ini, FOV, reso_method);    
    roi_resize = imresize3D(roiIni, FOV, reso_method)>0.5;
    
    % Management of the matrix size with margins
    if FOV(1) ~= FOV_req(1)    
        tmp = zeros(FOV_req(1), FOV_req(2), FOV(3));
        tmpA = abs(FOV_req(1)-FOV(1))/2;
        tmpB = abs(FOV_req(2)-FOV(2))/2;
        
        tmp(tmpA+1:tmpA+FOV(1), tmpB+1:tmpB+FOV(2), :) = ct_resize;        
        ct_resize = tmp;
        
        tmp = zeros(FOV_req(1), FOV_req(2), FOV(3), 'logical');
        tmp(tmpA+1:tmpA+FOV(1), tmpB+1:tmpB+FOV(2), :) = roi_resize;    
        roi_resize = tmp;
    end
    
    % CT normalization between -1024 et 1024 HU
    ct_norm = (ct_resize - HU_range(1))/(HU_range(2)-HU_range(1));
    ct_norm(ct_norm>1) = 1;
    ct_norm(ct_norm<0) = 0;
    
    % save data in .mat
    ct = ct_norm;
    roi = roi_resize;
    save([path_save, patient_name, '.mat'], 'ct', 'roi');
    toc;
end