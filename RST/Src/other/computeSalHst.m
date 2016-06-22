function [sHsts, sAreas, SHst, WArea] = computeSalHst(D, A, areas, siz)
% Compute saliency based on histogram distance.
%
% Input
%   D       -  histogram distance, mSeg x mSeg
%   A       -  adjacency matrix, mSeg x mSeg
%   areas   -  segment size, mSeg x 1
%   siz     -  image size, 1 x 2
%
% Output
%   sSegs   -  salience of each segment, mSeg x 1
%   sHsts   -  histogram-based saliency, mSeg x 1
%   sSpas   -  spatial prior of each region, mSeg x 1
%   sAreas  -  weight of each area, mSeg x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-27-2013

% dimension
h = siz(1);
w = siz(2);
mSeg = size(A, 1);

% set the diagonal = 1;
idx = sub2ind([mSeg, mSeg], 1 : mSeg, 1 : mSeg);
A(idx) = 1;

% area weight
sAreas = areas / h / w / 0.52;
sAreas = 1 ./ (1 + sAreas .^ 11);

WArea = repmat(areas', [mSeg, 1]) .* double(A);
WArea = WArea ./ repmat(sum((WArea + eps), 2), [1, mSeg]);

% histogram-based distance
% SHst = -log(max(1 - D, 1e-5));
% SHst = (1000 .^ D - 1) / (1000 - 1);
% SHst = (a .^ D - 1) / (a - 1);
SHst = D;
sHsts = sum(SHst .* WArea, 2);
