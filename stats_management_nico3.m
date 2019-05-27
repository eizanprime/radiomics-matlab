
% Parameters
alpha = 0.05; % 1st order risk
coefAltman = 0.1; % altman tail suppression

% Loading data
pathScan = '/home/eizanprime/Documents/NEW_TFE/DATA/OneDrive_1_5-19-2019/data_NSCLC.xlsx';
[data_num, data_txt] = xlsread(pathScan);
label = data_txt(1,2:end);
type = data_txt(2,2:end);
patient = data_txt(3:end,1);
data_txt = data_txt(3:end,2:end);

% r�duction aux patients utiles
load('patientNaymes_utile.mat')
new_patient = x_feat_utile_patientNaymes(:, 1:end-4);
new_patient = string(new_patient);

ind = [];
for i = 1:size(patient, 1)
   tmp_patient = patient{i,:};
   if isempty(cell2mat(strfind(new_patient, tmp_patient)))
       % disp(tmp_patient);
       ind = [ind; i];
   end   
end

data_num(ind, :) = [];
data_txt(ind, :) = [];

% loading features
 load('x_feat_utile_lotsoffeatures.mat');
 my_feats = x_feat_utile;
data_num = [data_num, my_feats];
type = [type, repmat("double", 1, size(my_feats, 1))];

% Analyse statistiques
% outcome studied
yData = (data_txt(:, 12) == "Y");
times = data_num(:, 9);
[times, indTimes] = sort(times);
cens = zeros(size(times)); % to modif ?

legend = {'label', 'Se', 'Sp', 'AUC', 'Youden', 'Threshold', 'chi2', ...
    'logrank_p', 'logrank_h', 'altman_p', 'altman_h'};

% For contineous data: altman correction, ROC curves, Kaplan-meier analysis
% For discrete data: directly Kaplan-meier analysis
stats2 = [];
for iLab = 50:size(data_num, 2)
%     xLab = label{iLab};
    if strcmp(type{iLab}, 'double')
        xData = data_num(:, iLab);
        
        % remove NaN

        % Altmann correction: extremity deletion
        tailSize = round(coefAltman*size(xData,1)); % 10% tail
        [~, b] = sort(xData);
        indTail = b(tailSize+1:end-tailSize);
        xData_corrected = xData(indTail);
        yData_corrected = yData(indTail);

        % ROC curves
        [fpr, tpr, T, AUC, ~] = perfcurve(yData_corrected, xData_corrected, 1);

        if AUC<0.5
            AUC = 1 - AUC;
            fpr = 1 - fpr;
            tpr = 1 - tpr;
        end

        % Measurement of the sensibility and the sensitivity
        [u,uu] = max((1-fpr)+(tpr));
        youdenInd = u-1;
        Se = tpr(uu);
        Sp = 1-fpr(uu);

        % Best threshold according to ROC curves
        bestThresh = T(find(tpr==tpr(uu) & fpr==fpr(uu))+1);    
        % Features binarisation
        xDataBW = xData(indTimes) > bestThresh;

    elseif strcmp(type{iLab}, 'string')
        Se = NaN;
        Sp = NaN;
        AUC = NaN;
        youdenInd = NaN;
        bestThresh = NaN;
        
        xData = data_txt(:, iLab);    
        tmpLab = unique(xData);
        xDataBW = strcmp(xData(indTimes), tmpLab{1});
    end

    % Kaplan Meier survival analysis and logrank/chi2 test
    [chi2, pVal] = KManalyse(xDataBW, times, cens);
    signif1 = pVal <= alpha;
    
    if strcmp(type{iLab}, 'double')
        % Altmann correction
        pValAlt = NaN;
        if pVal<0.1
            pValAlt = -1.63 * pVal * (1 + 2.35 * log(pVal));  
        end
        signif2 = pValAlt <= alpha;
        
    elseif strcmp(type{iLab}, 'string')
        pValAlt = NaN;
        signif2 = NaN;
    end
    
    stats = {Se, Sp, AUC, youdenInd, bestThresh, chi2, pVal, signif1, pValAlt, signif2};
    stats2 = [stats2; stats];
end
stats2 = cell2mat(stats2);
find(stats2(:, 10))