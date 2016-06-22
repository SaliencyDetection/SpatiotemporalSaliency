function [Ls, A] = SegMerge(L0s, AD)
% Convert video-based segmentation to an adjacency matrix.
%
% Input
%   L0s     -  original super-voxel label, h x w x nF
%   AD      -  connected adjacency matrix, mSeg0 x mSeg0
%
% Output
%   Ls      -  new super-voxel label, h x w x nF
%   A       -  new adjacency matrix, mSeg x mSeg
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-23-2013

% dimension
[h, w, nF] = size(L0s);

% new label
ind = find(AD);
labels = mexMergeAdjacentRegions(double(AD), ind - 1);
ind = find(labels == 0);
labels(ind) = max(labels(:)) + 1 : length(ind);
mSeg = max(labels(:));

% adjust label
Ls = L0s;
for iF = 1 : nF
    L0 = double(L0s(:, :, iF));
    L = relabel_L_fast(L0, labels);
    Ls(:, :, iF) = uint16(L);
end

% adjaceny matrix
A = vdoSegL2A(Ls, mSeg);

end