function [areas, xDs, yDs] = calSpatialInfo(L, XD, YD)

L = double(LabelsToLabels(L));
iSeg = length(unique(L));

fast = 1;
if (fast)
    [areas, xDs, yDs] = computeRegionSpa_fast(double(L), XD, YD, iSeg);
else
    [areas, xDs, yDs] = computeRegionSpa(L, XD, YD, iSeg);
end

end
