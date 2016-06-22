    close all;
    
    srcImg = imread('E:\ltnghia_Projects\Deep_Saliency\Data\JHMDB\Images\0472\frame_0016.png');
	[L, ~, ~] = SLIC_Split(srcImg, 400);
           
    F = rgb2lab(srcImg);
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
    
    adjcMatrix = GetAdjMatrix(L, iSeg);

    bdIds = GetBndPatchIds(L);
    colDistM = GetDistanceMatrix(meanLabCol);

    [clipVal, geoSigma, neiSigma] = EstimateDynamicParas(adjcMatrix, colDistM);

    %% Saliency Optimization
    [bgProb, bdCon, bgWeight] = EstimateBgProb(colDistM, adjcMatrix, bdIds, clipVal, geoSigma);
     
    obProb = 1-bgProb;
    %obProb(bgProb == 0) = 0;
    S = obProb(L);
    
    %S = mat2gray(S);
    imshow(S);

    object = objProb (srcImg, L);
    S = object(L);
    figure;
    imshow(S);

