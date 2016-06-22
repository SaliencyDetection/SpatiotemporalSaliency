function [sHst_Col, sHst_Int, sHst_Ori, sHst_MagF, sHst_OriF] = calLocalContrastInformation(Hst_Col, Hst_Int, Hst_Ori, Hst_MagF, Hst_OriF, L, area, siz, mSeg)

tempL = L;
tempiLabel = unique(tempL);

L = double(LabelsToLabels(L));
iLabel = unique(L);

adjcMatrix = GetAdjMatrix(L, length(iLabel));
wDistance = adjcMatrix;
distance = 'Chi_Square';
idx = [];

% histogram distance
DF = computeHistDist(sparse(Hst_Col), adjcMatrix, idx, distance);
DI = computeHistDist(sparse(Hst_Int), adjcMatrix, idx, distance);
DG = computeHistDist(sparse(Hst_Ori), adjcMatrix, idx, distance);
DM = computeHistDist(sparse(Hst_MagF), adjcMatrix, idx, distance);
DO = computeHistDist(sparse(Hst_OriF), adjcMatrix, idx, distance);

% histogram saliency
Hst_Col = computeSalHst(DF, wDistance, area, siz);
Hst_Int = computeSalHst(DI, wDistance, area, siz);
Hst_Ori = computeSalHst(DG, wDistance, area, siz);
Hst_MagF = computeSalHst(DM, wDistance, area, siz);
Hst_OriF = computeSalHst(DO, wDistance, area, siz);

sHst_Col = zeros(mSeg, 1);
sHst_Int = zeros(mSeg, 1);
sHst_Ori = zeros(mSeg, 1);
sHst_MagF = zeros(mSeg, 1);
sHst_OriF = zeros(mSeg, 1);

sHst_Col(tempiLabel) = Hst_Col;
sHst_Int(tempiLabel) = Hst_Int;
sHst_Ori(tempiLabel) = Hst_Ori;
sHst_MagF(tempiLabel) = Hst_MagF;
sHst_OriF(tempiLabel) = Hst_OriF;

end