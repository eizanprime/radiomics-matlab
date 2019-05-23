clear; clc;
warning('off','all');

% Parameters
pathScan = 'E:\Data\data_NSCLC\data_NSCLC.xlsx';
[data_num, data_txt] = xlsread(pathScan);

label = data_txt(1,2:end);
type = data_txt(2,2:end);
patient = data_txt(3:end,1);
data_txt = data_txt(3:end,2:end);

% For contineous data: mean, std, 1st quartile, median, 3rd quartil
% For discrete/qualitative data: number and %
for iLab = 1:size(label, 2)    
    disp(label{iLab});
    if strcmp(type{iLab}, 'double')
        tmpVar = data_num(:, iLab);
        tmpVar(isnan(tmpVar)) = []; % remove unknow value
        stats = [mean(tmpVar), std(tmpVar), quantile(tmpVar, 0.50), min(tmpVar), max(tmpVar)];
        
        disp(stats);
        
    elseif strcmp(type{iLab}, 'string')
        tmpVar = data_txt(:, iLab);
        [tmpLab, ~, tmpNum] = unique(tmpVar);
        stats = histc(tmpNum, unique(tmpNum));
        stats = [stats, round(stats/sum(stats)*100, 2)];
        
        disp(tmpLab);
        disp(stats);
    end 
end
