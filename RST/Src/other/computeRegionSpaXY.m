function [XD, YD] = computeRegionSpaXY(siz)
% Compute spatial prior of each region.
% Output
%   areas   -  area size, mSeg x 1
%   xDs     -  differency sum in X position, mSeg x 1
%   yDs     -  differency sum in Y position, mSeg x 1
%
%   create & modify  -  Feng Zhou (zhfe99@gmail.com), 07-09-2013

% dimension
h = siz(1);
w = siz(2);

if (mod(h,2))
    dh = 0.5;
else
    dh = 1;
end

if (mod(w,2))
    dw = 0.5;
else
    dw = 1;
end

% distance to center
[XD, YD] = meshgrid(-w / 2 + dw : w / 2, -h / 2 + dh : h / 2);
XD = XD .^ 2;
YD = YD .^ 2;
