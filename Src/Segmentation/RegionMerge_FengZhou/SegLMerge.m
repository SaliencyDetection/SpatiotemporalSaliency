function [Ls, A] = SegLMerge(L0s, bins, th, image_dir, image_type, varargin)
% Merge the super-voxels.
%
% Input
%   Ls     -  original label, h x w x nF
%   th      -  threshold for merge similar segments
%   bins    -  bins, [8 16 16 4]

A0 = SegL2A(L0s);
mSeg0 = size(unique(L0s(:)), 1);

% dimension
[h, w, nF] = size(L0s);
siz = [h, w];

% histogram of each region
HstF = 0;
file = dir([image_dir '/*.' image_type]);
for iF = 1 : nF
    %% read frame
    F = im2double(imread([image_dir '/' file(iF).name]));

    %% read seg
    L0 = L0s(:, :, iF);

    %% quantize
    FQ = computeQuantMatrixImg(F, bins(1 : 4));
    HstFi = computeRegionHist_fast(FQ, double(L0), prod(bins(1 : 4)), mSeg0);

    %% store
    HstF = HstF + HstFi;
end

% compute distance
HstF = sparse(HstF);
D = computeHistDist(HstF, A0);
AD = D < th & D ~= 0;

% merge label
[Ls, A] = SegMerge(L0s, AD);

end