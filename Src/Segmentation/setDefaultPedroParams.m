function [ params ] = setDefaultPedroParams()

 % k: constant for treshold function.
 % min_size: minimum component size (enforced by post-processing stage)
  % sigma: to smooth the image.

params.K = 100;
params.min_size = 150;
params.sigma = 0.8;

end

