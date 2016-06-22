function Q = computeQuantMatrixImg(F, bins)
% Compute the quantization matrix based on the 3-dimensional matrix imgLAB.
%
% k = prod(bins)
%
% Input
%   F       -  input image, h x w x nC
%   bins    -  #bin, 1 x nBin
%
% Output
%   Q       -  quantized image, h x w
%              the range of each pixel values is in [1, k].
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-04-2013

% rgb -> lab
Lab = rgb2lab(F);
L = Lab(:, :, 1);
a = Lab(:, :, 2);
b = Lab(:, :, 3);

% rgb -> hsv
Hsv = rgb2hsv(F);
H = Hsv(:, :, 1);
ind = find(H > 0.5);
H(ind) = 1 - H(ind);

% each component
ll = min(floor(L / (100 / bins(1))) + 1, bins(1));
aa = min(floor((a + 120) / (240 / bins(2))) + 1, bins(2));
bb = min(floor((b + 120) / (240 / bins(3))) + 1, bins(3));
hh = min(floor(H * bins(4)) + 1, bins(4));

% combine
%Q = (ll - 1) * bins(2) * bins(3) * bins(4) + ...
%    (aa - 1) * bins(3) * bins(4) + ...
%    (bb - 1) * bins(4) + ...
%    hh + 1;

Q = (ll - 1) * bins(2) * bins(3) + ...
    (aa - 1) * bins(3) + ...
     bb + 1;
