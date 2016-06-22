function [ L ] = PedroSegmentation( im, sigma, k, min_size )

im = double(im);
segim = mexSegment(im, sigma, k, int32(min_size));

im = double(segim);
im = im(:, :, 1) + im(:, :, 2)*256 + im(:, :, 3)*256^2;
[gid, gn] = grp2idx(im(:));
L = uint16(reshape(gid, size(im)));

end

