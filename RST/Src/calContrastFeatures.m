function [Hst_Col, Hst_Ori, Hst_Int, Hst_MagF, Hst_OriF] = calContrastFeatures(im, mag, flo, L, bins)

% color: Lab + Hue
FQ = computeQuantMatrixImg(im, bins(1 : 4));

% intensity
Hsv = rgb2hsv(im);
IQ = computeQuantMatrixFlow(Hsv(:,:,3), bins(5));

%gabor filter
GQ = computeQuantMatrixFlow(gabor_filter(im), bins(6));

% flow
MQ = computeQuantMatrixFlow(mag, bins(7));

% segmentation
L = double(LabelsToLabels(L));
iSeg = length(unique(L(:)));

fast = 1;
if (fast)
    Hst_Col = computeRegionHist_fast(FQ, L, prod(bins(1 : 4)), iSeg);
    Hst_Int = computeRegionHist_fast(IQ, L, bins(5), iSeg);
    Hst_Ori = computeRegionHist_fast(GQ, L, bins(6), iSeg);
    Hst_MagF = computeRegionHist_fast(MQ, L, bins(7), iSeg);
else
    Hst_Col = computeRegionHist(FQ, bins(1 : 4), L, iSeg);
    Hst_Int = computeRegionHist(IQ, bins(5), L, iSeg);
    Hst_Ori = computeRegionHist(GQ, bins(6), L, iSeg);
    Hst_MagF = computeRegionHist(MQ, bins(7), L, iSeg);
end

VX = flo(:,:,1);
VY = flo(:,:,2);
Hst_OriF = computeHof(VX, VY, L, bins(8), iSeg);

Hst_Col = sparse(Hst_Col);
Hst_Ori = sparse(Hst_Ori);
Hst_Int = sparse(Hst_Int);
Hst_MagF = sparse(Hst_MagF);
Hst_OriF = sparse(Hst_OriF);

end
