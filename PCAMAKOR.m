function pcamatrix = PCAMAKOR(featmatrix)
utileNormResulst = normalize(featmatrix);
%utileResulst = utileNormResulst(:,all(~isnan(utileNormResulst)));
utileResulst = utileNormResulst;

granul = utileResulst;
granul = granul(:,all(~isnan(granul)));
pcaGranulCoef = pca(granul);
pcamatrix = granul*pcaGranulCoef;
