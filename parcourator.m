rootfolder = '/home/eizanprime/Documents/NEW_TFE/matlabcode/gestionExamNew/NSCLC-Radiomics/';
[value, string] = system(['ls ' rootfolder]);
table = strsplit(string);
for k=1:length(table)
    try
    dossier = table{k};
    [value2, string2] = system(['ls ' strcat(rootfolder, dossier)]);
    [value3, string3] = system(['ls ' strcat(rootfolder, dossier, '/', string2)]);
    
    twodossier = strsplit(string3);
    
    [value4, string5] = system(['ls -1 ' strcat(rootfolder, dossier, '/', string2, '/', twodossier{1}) '| wc -l']);
    [value5, string6] = system(['ls -1 ' strcat(rootfolder, dossier, '/', string2, '/', twodossier{2}) '| wc -l']);
    
    val1 = str2num(string5);
    val2 = str2num(string6);
    
    if (val1 > val2)
        dicomRTPath= strcat(rootfolder, dossier, '/', string2, '/', twodossier{2}, '/');
        dicomsPath= strcat(rootfolder, dossier, '/', string2, '/', twodossier{1}, '/');
    else 
        dicomRTPath= strcat(rootfolder, dossier, '/', string2, '/', twodossier{1}, '/');
        dicomsPath= strcat(rootfolder, dossier, '/', string2, '/', twodossier{2}, '/');
    end
    
    [vectogran, vectoantigran] = untitlednicolas(dicomsPath, dicomRTPath)
    fid = fopen( strcat(dossier,'results.txt'), 'wt' );
    fprintf(fid,'%f, ', vectogran);
    fprintf(fid, '\n');
    fprintf(fid,'%f, ', vectoantigran);
    fclose(fid);
    catch
        
    end
    
    
end