
%PERSOO  
customvolume = 0
dayzz = 2*365.25

numvalidset = 20

% Parameters
alpha = 0.05; % 1st order risk
coefAltman = 0.1; % altman tail suppression

% Loading data
pathScan = '/home/eizanprime/Documents/NEW_TFE/DATA/OneDrive_1_5-19-2019/data_NSCLC.xlsx';
[data_num, data_txt] = xlsread(pathScan);
label = data_txt(1,2:end);
type = data_txt(2,2:end);
patient = data_txt(3:end,1);
data_txt = data_txt(3:end, 2:end);
%fuckmatlab = strfind(type, "double")
%find([fuckmatlab{:}] == 1)

%testxt = testxt(:, strfind(type, "double"))
%data_txt = data_txt(3:end,:); %modified by me
% Added by Nicolas the mémorant null
%NaNaNaHaHa = find(all(isnan(data_num),1))
%NOTNaNaNaHaHa = find(all(~isnan(data_num),1))
%index = false(1, numel(C))
doubleindex = [];
stringindex = [];
%this loop is needed because matlab is cancer, my radiomics feature tell me
%that matlab is cancer with 100% accuracy and p-value of 0,00000000001
for k = 1:size(type')
    if(strcmp(type(k),"double"))
        doubleindex = [doubleindex, k  ];%-1 because the first double is at 2...  ugly I know
    end
    if(strcmp(type(k),"string"))
        stringindex = [stringindex, k];
    end
end
doubleindex;
stringindex;

data_num =  data_num(:, doubleindex);
data_txt = data_txt(:, stringindex);
%data_txt = data_txt(:, 2:end); %we dont need patient name (even you, my beloved LUNG1-001)


% r�duction aux patients utiles
load('x_feat_utile_EVERYBODY_patientNaymes.mat');
load('x_feat_utile_EVERYBODY.mat');
load('xLabelsMorph_verbose.mat');

%%% VOLUME TRIAGE
ind = [];
for i = 1:size(x_feat_utile, 1)
    if(x_feat_utile(i,2) < customvolume)
        ind = [ind, i];
    end

end
x_feat_utile(ind, :) = [];
x_feat_utile_patientNaymes(ind, :) = [];

PCAhahahascript

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
 
 %load('GranulFirstOrderPCAFeat.mat');
 %load('GranulPCAFeat.mat');
 %load('GranulFirstOrderPCANormFeat.mat')
 my_feats = x_feat_utile(:,1:50);
 %my_feats = x_feat_utile; % FOR AAAALLLLL
data_num = [data_num, my_feats];
%data_num = [data_num, granulPCAFEAT];
data_num = [data_num, granulALLPCAFEAT];
data_num = [data_num, covPCAALL];
%data_num = [data_num, covPCAFEAT(:,1:50)];
data_num = [data_num, vectogranPCA, vectoantigranPCA,N300PCA, maxounormPCA, standevnormPCA, covnormPCA, skewnormPCA, kurtnormPCA, energynormPCA, entropynormPCA, covolumePCA, covN300PCA,covmaxounormPCA, covstandevnormPCA,covcovnormPCA, covskewnormPCA,covkurtnormPCA,covenergynormPCA, coventropynormPCA];

%data_num = [data_num, GranulFirstOrderNormPCAFeat];
type = [type, repmat("double", 1, size(my_feats, 1))];


atest = data_num;



%%% SORTING VALID SET

[org, sortindex] = sort(data_num(:,4));
ordererdtxt = data_txt;
datanum_ordered = data_num;
for i=1:size(data_num,1)
    datanum_ordered(i,:) = data_num(sortindex(i), :);
    ordererdtxt(i,:) = data_txt(sortindex(i),:);
end
data_num = datanum_ordered;
data_txt = ordererdtxt;

athirdtest = data_num;

notded_txt = [];
notded_num = [];

ded_txt = [];
ded_num = [];

for i=1:size(data_num, 1)
    if(data_txt(i, 7) == "N")
        notded_txt = [notded_txt; data_txt(i,:)];
        notded_num = [notded_num; data_num(i,:)];
    else
        ded_txt = [ded_txt; data_txt(i,:) ];
        ded_num = [ded_num; data_num(i,:)];
    end
    
end

%%SORT THE DEADS

[org, sortindex] = sort(ded_num(:,2));
ordererdtxt = ded_txt;
datanum_ordered = ded_num;
for i=1:size(ded_num,1)
    datanum_ordered(i,:) = ded_num(sortindex(i), :);
    ordererdtxt(i,:) = ded_txt(sortindex(i),:);
end
ded_num = datanum_ordered;
ded_txt = ordererdtxt;

data_txt = [ded_txt; notded_txt];
data_num = [ded_num; notded_num];


validation_txt = [];
validation_num = [];
ind = [];
spacinguu = floor(size(data_num, 1) / numvalidset);
for i=1:numvalidset
    j = i*spacinguu - 1;
    ind = [ind, j];
    validation_txt =  [validation_txt; data_txt(j,: )];
    validation_num = [validation_num; data_num(j, :)];
end
data_txt(ind, :) = [];
data_num(ind, :) = [];


% asectest = data_num;
% 
% 
% 
% 
% [org, sortindex] = sort(atest(:,4));
% datanum_ordered = atest;
% for i=1:size(data_num,1)
%     datanum_ordered(i,:) = atest(sortindex(i), :);
% end
% atest = datanum_ordered;
% 
% 
% 
% 
% [org, sortindex] = sort(asectest(:,4));
% datanum_ordered = asectest;
% for i=1:size(data_num,1)
%     datanum_ordered(i,:) = asectest(sortindex(i), :);
% end
% asectest = datanum_ordered;
% 
% [org, sortindex] = sort(athirdtest(:,4));
% datanum_ordered = athirdtest;
% for i=1:size(data_num,1)
%     datanum_ordered(i,:) = athirdtest(sortindex(i), :);
% end
% athirdtest = datanum_ordered;
% 
% realllyyy = [];
% %realllyyy = find(atest~=atest);
% realllyyy = isequal(atest(:,2:end), athirdtest(:,2:end));









%%%%









% Analyse statistiques
% outcome studied
%yData = (data_txt(:, 10) == "Y");
for i=1:size(data_num, 1)
   yData(i) = (data_num(i,2) <= dayzz) && (data_txt(i, 7) == "Y");
end
%yData = ((data_num(:,2) <= dayzz) && (data_txt(:, 7) == "Y"));  %FOR ANY DAYS
times = data_num(:, 3);
[times, indTimes] = sort(times);
cens = zeros(size(times)); % to modif ?

legend = {'label', 'Se', 'Sp', 'AUC', 'Youden', 'Threshold', 'chi2', ...
    'logrank_p', 'logrank_h', 'altman_p', 'altman_h'};

%%%%%% TOOOOOO DEEELEEEETEEEE

%%%%%% TOOOOOO DEEELEEEETEEEE

%%%%%% TOOOOOO DEEELEEEETEEEE

%data_num(yData, :) = []; %deletion of surviving patients

%%%%%% TOOOOOO DEEELEEEETEEEE

%%%%%% TOOOOOO DEEELEEEETEEEE

%%%%%% TOOOOOO DEEELEEEETEEEE


%%%%



final_labels = [xLabelsMorph(1:50).'; labelgranulALLPCAFEAT; labelcovPCAALL; labelvectogranPCA ; labelvectoantigranPCA ;labelN300PCA;labelmaxounormPCA ;labelstandevnormPCA ;labelcovnormPCA ;labelskewnormPCA ;labelkurtnormPCA ;labelenergynormPCA ;labelentropynormPCA ;labelcovolumePCA ;labelcovN300PCA ;labelcovmaxounormPCA ;labelcovstandevnormPCA ;labelcovcovnormPCA ;labelcovskewnormPCA ;labelcovkurtnormPCA ;labelcovenergynormPCA ;labelcoventropynormPCA];

% For contineous data: altman correction, ROC curves, Kaplan-meier analysis
% For discrete data: directly Kaplan-meier analysis
stats2 = [];
for iLab = 4:size(data_num, 2)
%     xLab = label{iLab};
    if 1%strcmp(type{iLab}, 'double') %now its always double guys hahaha
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
        
        if(iLab == 71 + 3 || iLab == 2 + 3)
            figure;
            set(gcf, 'Position',  [0, 0, 500, 500])
            plot(fpr, tpr);
            
            %xline(4.5,'-',{'Acceptable','Limit'});
            SP=bestThresh; %your point goes here 
            hold on
            
            plot(fpr(uu), tpr(uu),'ro')
            hold on
            line('Color',[0.5, 0.5, 0.5],'LineStyle','--');
            xlabel('False positive rate') ;
            ylabel('True positive rate');
            title(['Area Under Curve for ', final_labels(iLab - 3)]);
        end
        

    elseif 0 %strcmp(type{iLab}, 'string') %muhhahah
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
    
    if 1 %strcmp(type{iLab}, 'double')
        % Altmann correction
        pValAlt = NaN;
        if pVal<0.1
            pValAlt = -1.63 * pVal * (1 + 2.35 * log(pVal));  
        end
        signif2 = pValAlt <= alpha;
        
    elseif 0% strcmp(type{iLab}, 'string')
        pValAlt = NaN;
        signif2 = NaN;
    end
    
    stats = {Se, Sp, AUC, youdenInd, bestThresh, chi2, pVal, signif1, pValAlt, signif2};
    stats2 = [stats2; stats];
end


[org, sortindex] = sort(cell2mat(stats2(:,7)));
ordererdlabels = final_labels;
statsordered = stats2;
indexaha = {};
for i=1:size(stats2,1)
    statsordered(i,:) = stats2(sortindex(i), :);
    ordererdlabels(i) = final_labels(sortindex(i));
    indexaha{i, 1} = sortindex(i);
end
combinedlabelstats = [indexaha, ordererdlabels, statsordered];


truthhh = cell2mat(statsordered(:,10));
thurthindex = cell2mat(indexaha);


vipdata_num = [];
viplabels = {};
for i=1:size(truthhh, 1)
    if(truthhh(i))
        vipdata_num = [vipdata_num, data_num(:, 3 + thurthindex(i))];
        viplabels = [viplabels, final_labels{thurthindex(i)}];
    end
end

test_cell = num2cell(vipdata_num);
test_cell = [num2cell(data_num(:, 2)), data_txt(:, 7), data_txt(:, 8), data_txt(:, 9), data_txt(:, 10), test_cell];
viplabels = ['survivaltime', 'DS', 'DC1', 'DC2', 'DC3', viplabels];

willgo2R = [viplabels; test_cell];
rtable = table(willgo2R);

writetable(rtable,'/tmp/for_RR.csv');





truthhh = cell2mat(statsordered(:,10));
thurthindex = cell2mat(indexaha);


vipdata_num = [];
viplabels = {};
for i=1:size(truthhh, 1)
    if(truthhh(i))
        vipdata_num = [vipdata_num, validation_num(:, 3 + thurthindex(i))];
        viplabels = [viplabels, final_labels{thurthindex(i)}];
    end
end

test_cell = num2cell(vipdata_num);
test_cell = [num2cell(validation_num(:, 2)), validation_txt(:, 7), validation_txt(:, 8), validation_txt(:, 9), validation_txt(:, 10), test_cell];
viplabels = ['survivaltime', 'DS', 'DC1', 'DC2', 'DC3', viplabels];

willgo2R = [viplabels; test_cell];
rtable = table(willgo2R);

writetable(rtable,'/tmp/for_RR_valid.csv');


%stats2 = cell2mat(stats2);
%find(stats2(:, 10))

%mytableou = table(char(combinedlabelstats(:, 2)), cell2mat(combinedlabelstats(:,3)), cell2mat(combinedlabelstats(:,4)) , cell2mat(combinedlabelstats(:,5)) , cell2mat(combinedlabelstats(:,7)),cell2mat(combinedlabelstats(:,9)), cell2mat(combinedlabelstats(:,11), cell2mat(combinedlabelstats(:,12))))





testtable = table(combinedlabelstats);


