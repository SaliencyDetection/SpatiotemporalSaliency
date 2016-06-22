function A = SegL2A(Ls)
% Convert video-based segmentation to an adjacency matrix.
%
% Input
%   Ls      -  super-voxel label, h x w x nF
%
% Output
%   A       -  adjacency matrix, mSeg x mSeg (logical)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-23-2013

% dimension
[h, w, nF] = size(Ls);

labels = unique(Ls(:));
mSeg = size(labels, 1);

% spatio-temporal neighbour
A = uint8(zeros(mSeg, mSeg));

% neighbour in y direction
dy = Ls ~= Ls([2 : end end], :, :);
idx1 = find(dy);
[y1s, x1s, z1s] = ind2sub([h, w, nF], idx1);
idx2 = sub2ind([h, w, nF], y1s + 1, x1s, z1s);
s1 = double(Ls(idx1));
s2 = double(Ls(idx2));

A(sub2ind([mSeg, mSeg], s1, s2)) = 1;
A(sub2ind([mSeg, mSeg], s2, s1)) = 1;

% neighbour in x direction
dx = Ls ~= Ls(:, [2 : end end], :);
idx1 = find(dx);
[y1s, x1s, z1s] = ind2sub([h, w, nF], idx1);
idx2 = sub2ind([h, w, nF], y1s, x1s + 1, z1s);
s1 = double(Ls(idx1));
s2 = double(Ls(idx2));

A(sub2ind([mSeg, mSeg], s1, s2)) = 1;
A(sub2ind([mSeg, mSeg], s2, s1)) = 1;

% neighbour in z direction
dz = Ls ~= Ls(:, :, [2 : end end]);
idx1 = find(dz);
[y1s, x1s, z1s] = ind2sub([h, w, nF], idx1);
idx2 = sub2ind([h, w, nF], y1s, x1s, z1s + 1);
s1 = double(Ls(idx1));
s2 = double(Ls(idx2));

A(sub2ind([mSeg, mSeg], s1, s2)) = 1;
A(sub2ind([mSeg, mSeg], s2, s1)) = 1;