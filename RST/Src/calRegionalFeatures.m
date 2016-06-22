function [Val_Obj, Val_Cen, Val_MagF] = calRegionalFeatures(im, M, L, XD, YD, siz)

% compute object probability by image boundary
Val_Obj = objProb (im, L);

% segmentation
L = double(LabelsToLabels(L));
iSeg = length(unique(L(:)));

fast = 1;
if (fast)
    Val_MagF = computeRegionMag_fast(L, M, iSeg);
else
    Val_MagF = computeRegionMag(L, M, iSeg);
end

[area, xDs, yDs] = calSpatialInfo(L, XD, YD);
Val_Cen = computeSalPriSpa(area, xDs, yDs, siz);

end
