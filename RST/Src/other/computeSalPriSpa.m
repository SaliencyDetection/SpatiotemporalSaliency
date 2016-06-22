function sSpas = computeSalPriSpa(areas, xDs, yDs, siz)
% Compute saliency based on spatial prior.
%
% Input
%   areas   -  segment size, mSeg x 1
%   xDs     -  cumulative differency in X position, mSeg x 1
%   yDs     -  cumulative differency in Y position, mSeg x 1
%   siz     -  image size, 1 x 2
%
% Output
%   sSpas   -  spatial prior of each region, mSeg x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-18-2013

% dimension
h = siz(1);
w = siz(2);
mSeg = length(areas);
idx = areas > 0;

% compute prior
sSpas = zeros(mSeg, 1);
sSpas(idx) = exp(-9 * (xDs(idx) ./ (areas(idx) + eps)) / w ^ 2 ...
                 -9 * (yDs(idx) ./ (areas(idx) + eps)) / h ^ 2);
