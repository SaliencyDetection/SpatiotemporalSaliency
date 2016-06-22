function object = objProb (F, L)

F = rgb2lab(F);

[h, w, chn] = size(F);
tmpImg=reshape(F, h*w, chn);

label = unique(L(:));
iSeg = length(label);

l = L;

meanLabCol=zeros(iSeg, chn);
for i=1:length(label)
    meanLabCol(i, :) = mean(tmpImg(L==label(i),:));
    l(L==label(i)) = i;
end

L = l;

bdIds = GetBndPatchIds(L, 8);
colDistM = GetDistanceMatrix(meanLabCol); %hidden regions have distances = 0

adjcMatrix = GetAdjMatrix(L, iSeg);

[clipVal, geoSigma, neiSigma] = EstimateDynamicParas(adjcMatrix, colDistM);
[bgProb, bdCon, bgWeight] = EstimateBgProb(colDistM, adjcMatrix, bdIds, clipVal, geoSigma);

object = 1 - bgProb;

end