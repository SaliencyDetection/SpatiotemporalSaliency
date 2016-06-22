function Hst = computeHof(VX, VY, L, nBin, mSeg)
% Compute the HoF histogram.
%
% Input
%   VX      -  flow in X, h x w
%   VY      -  flow in Y, h x w
%   L       -  label matrix, h x w
%   nBin    -  #bins, 9 | ...
%   mSeg    -  #segments
%
% Output
%   Hst     -  Histogram, mSeg x nBin
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-01-2013

% theshold
magMi = 0.4 * 0.4;

% angle
Ang = atan2(VY, VX) + pi;

% magtitude
Mag = real(sqrt(VX .^ 2 + VY .^ 2));
Vis = Mag <= magMi;

% bin
angBase = pi * 2 / (nBin - 1);
BinF = Ang / angBase;
BinF = max(0, BinF);
BinF = min(nBin - 1, BinF);
Bin0 = floor(BinF);
Wei0 = 1 - (BinF - Bin0);
Wei1 = 1 - Wei0;
Bin0 = mod(Bin0, nBin - 1);
Bin1 = mod(Bin0 + 1, nBin - 1);
Bin0 = Bin0 + 1;
Bin1 = Bin1 + 1;
Mag0 = Wei0 .* Mag;
Mag1 = Wei1 .* Mag;

% last bin for small flow
Bin0(Vis) = nBin;
Bin1(Vis) = 1;
Mag0(Vis) = 1;
Mag1(Vis) = 0;

% apply to each pixel
% Hst = zeros(mSeg, nBin);
% for i = 1 : length(L(:))
%     c = L(i);
%     bin0 = Bin0(i);
%     mag0 = Mag0(i);
%     bin1 = Bin1(i);
%     mag1 = Mag1(i);
%     Hst(c, bin0) = Hst(c, bin0) + mag0;
%     Hst(c, bin1) = Hst(c, bin1) + mag1;
% end
% Hst2 = Hst;

Hst = computeRegionHof_fast(L, Bin0, Bin1, Mag0, Mag1, nBin, mSeg);
% equal('Hst', Hst, Hst2);