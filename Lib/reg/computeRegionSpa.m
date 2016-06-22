function [areas, xDs, yDs] = computeRegionSpa(L, XD, YD, mSeg)
% Compute spatial prior of each region.
%
% Input
%   L       -  label image, h x w
%   cSegs   -  segment index, 1 x mSeg
%   mSeg    -  #region
%
% Output
%   areas   -  area size, mSeg x 1
%   xDs     -  differency sum in X position, mSeg x 1
%   yDs     -  differency sum in Y position, mSeg x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-09-2013

cSegs = unique(L);

% each segment
areas = zeros(mSeg, 1);
xDs = zeros(mSeg, 1);
yDs = zeros(mSeg, 1); 
for iL = 1 : length(cSegs)
    cL = cSegs(iL);

    %% active pixels
    idxL = find(L == cL);
    areas(cL) = length(idxL);

    %% spatial prior
    xDs(cL) = sum(XD(idxL));
    yDs(cL) = sum(YD(idxL));
end
