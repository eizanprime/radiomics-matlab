
%[granulPCAFEAT, labelgranulPCAFEAT] = PCAMAKOR(x_feat_utile(:, 51: 70),'granulPCAFEAT');
 [granulALLPCAFEAT, labelgranulALLPCAFEAT] = PCAMAKOR(x_feat_utile(:, 51: 170),'granularity_ALLFEAT PCA');
 %[covPCAFEAT, labelcovPCAFEAT] = PCAMAKOR(x_feat_utile(:, 171: 300),'MorphoCov-PCAFEAT');
 [covPCAALL, labelcovPCAALL] = PCAMAKOR(x_feat_utile(:, 171:end), 'MorphoCov-ALLFEAT PCA');
    
iter = 0; 
 
[vectogranPCA, labelvectogranPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 60 +iter ), 'granularity PCA');
iter = iter +10;
[vectoantigranPCA, labelvectoantigranPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 60 +iter ), 'antigranularity PCA');
iter = iter +10;
[N300PCA, labelN300PCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 60 + 10 + 10 +iter ),'granularity-N_300_030_003 PCA');
iter = iter +10;
%[N030PCA,labelN030PCA]= PCAMAKOR(x_feat_utile(:, 51+iter: 60 +iter ),'granularity-N030 PCA');
iter = iter +10;
%[N003PCA,labelN003PCA]= PCAMAKOR(x_feat_utile(:, 51+iter: 60 +iter ),'granularity-N003 PCA'); 
iter = iter +10;
[maxounormPCA, labelmaxounormPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 60 +iter ),'granularity-max PCA');
iter = iter +10;
[standevnormPCA, labelstandevnormPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 60 +iter ),'granularity-standev PCA');
iter = iter +10;
[covnormPCA, labelcovnormPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 60 +iter ),'granularity-cov PCA');
iter = iter +10;
[skewnormPCA, labelskewnormPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 60 +iter ),'granularity-skewness PCA');
iter = iter +10;
[kurtnormPCA, labelkurtnormPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 60 +iter ),'granularity-kurtosisPCA');
iter = iter +10;
[energynormPCA, labelenergynormPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 60 +iter ),'granularity-energy PCA'); 
iter = iter +10;
[entropynormPCA, labelentropynormPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 60 +iter ),'granularity-entropy PCA'); 
iter = iter +10;
[covolumePCA, labelcovolumePCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 51 + 129 +iter ),'MorphoCov-volume PCA');
iter = iter +130;
[covN300PCA, labelcovN300PCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 51 + 3*129 +iter ),'MorphoCov-N300_030_003 PCA');
iter = iter +130;
%[covN030PCA, labelcovN030PCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 51 + 129 +iter ),'MorphoCov-N030 PCA'); 
iter = iter +130;
%[covN003PCA, labelcovN003PCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 51 + 129 +iter ),'MorphoCov-N003 PCA');
iter = iter +130;
[covmaxounormPCA, labelcovmaxounormPCA]= PCAMAKOR(x_feat_utile(:, 51+iter: 51 + 129 +iter ),'MorphoCov-max PCA');
iter = iter +130;
[covstandevnormPCA, labelcovstandevnormPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 51 + 129 +iter ),'MorphoCov-standev PCA');
iter = iter +130;
[covcovnormPCA, labelcovcovnormPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 51 + 129 +iter ),'MorphoCov-covnorm PCA');
iter = iter +130;
[covskewnormPCA, labelcovskewnormPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 51 + 129 +iter ),'MorphoCov-skewnorm PCA');
iter = iter +130;
[covkurtnormPCA, labelcovkurtnormPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 51 + 129 +iter ),'MorphoCov-kurtnorm PCA ');
iter = iter +130;
[covenergynormPCA, labelcovenergynormPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 51 + 129 +iter ),'MorphoCov-energynorm PCA');
iter = iter +130;
[coventropynormPCA, labelcoventropynormPCA] = PCAMAKOR(x_feat_utile(:, 51+iter: 51 + 129 +iter ), 'MorphoCov-entropynorm PCA');
iter = iter +130;


granulALLPCAFEAT(:,11:end) = [];
covPCAALL(:,11:end) = [];
labelgranulALLPCAFEAT(11:end) = [];
labelcovPCAALL(11:end) = [];


covolumePCA(:,11:end) = [];
covN300PCA(:,11:end) = [];
%covN030PCA(:,11:end) = [];
%covN003PCA(:,11:end) = [];
covN030PCA = [];
covN003PCA = [];

covmaxounormPCA(:,11:end) = [];
covstandevnormPCA(:,11:end) = [];
covcovnormPCA(:,11:end) = [];
covskewnormPCA(:,11:end) = [];
covkurtnormPCA(:,11:end) = [];
covenergynormPCA(:,11:end) = [];
coventropynormPCA(:, 11:end) = [];


labelcovolumePCA(11:end) = [];
labelcovN300PCA(11:end) = [];
%labelcovN030PCA(11:end) = []; 
labelcovN030PCA = []; 
%labelcovN003PCA(11:end) = [];
labelcovN003PCA= [];

labelcovmaxounormPCA(11:end) = [];
labelcovstandevnormPCA(11:end) = [];
labelcovcovnormPCA(11:end) = [];
labelcovskewnormPCA(11:end) = [];
labelcovkurtnormPCA(11:end) = [];
labelcovenergynormPCA(11:end) = [];
labelcoventropynormPCA(11:end) = [];

