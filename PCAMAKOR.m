function [pcamatrix, labels] = PCAMAKOR(featmatrix, labelname)
utileNormResulst = normalize(featmatrix);
%utileResulst = utileNormResulst(:,all(~isnan(utileNormResulst)));
utileResulst = utileNormResulst;

granul = utileResulst;
granul = granul(:,all(~isnan(granul)));
pcaGranulCoef = pca(granul);
pcamatrix = granul*pcaGranulCoef;
length = size(pcamatrix,2);
labels = {}
for i= 1:length
    labels(i,1) = {strcat(labelname, ' ', int2str(i))};
    %labels(i,1) = {strcat(labelname)};
    
end
