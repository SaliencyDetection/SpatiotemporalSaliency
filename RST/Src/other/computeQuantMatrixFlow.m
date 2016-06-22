function MQ = computeQuantMatrixFlow(M, bins)
% Compute the quantization matrix based on the 3-dimensional matrix imgLAB.
%
% k = cumprod(bins)
%
% Input
%   M       -  input image, h x w x nC
%   bins    -  #bin, 1 x nBin
%
% Output
%   MQ      -  quantized image, h x w
%              the range of each pixel values is in [1, k].
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-29-2013

MQ = min(floor(M * bins) + 1, bins);
