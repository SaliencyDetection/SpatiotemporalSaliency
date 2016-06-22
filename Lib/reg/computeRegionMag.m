function mag = computeRegionMag(L, M, mSeg)

cSegs = unique(L);

% each segment
mag = zeros(mSeg, 1); 
for iL = 1 : length(cSegs)
    cL = cSegs(iL);

    %% active pixels
    idxL = find(L == cL);
	
	mag(cL) = mean(M(idxL));
end
