function bImg = GaussianBlur(Img, radius, sig, bmin, bmax)

mGaussianKernel = fspecial('gaussian', [radius radius], sig);
bImg = imfilter(Img, mGaussianKernel,'replicate');
bImg = mat2gray(bImg);
bImg = imadjust(bImg, [bmin bmax], [0 1]);

end