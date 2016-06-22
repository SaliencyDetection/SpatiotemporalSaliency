function D = computeHistDist(Hst, A, idx, histDist)
% Compute saliency for histogram.
%
% Input
%   Hst     -  region histogram, mSeg x nBin
%   A       -  adjacency matrix, mSeg x mSeg
%   idx     -  index of non-zero entry
%
% Output
%   D       -  histogram distance, mSeg x mSeg
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-28-2013

if (nargin < 4)
	histDist = 'Chi_Square';
end

% dimension
mSeg = size(A, 1);

% adjust adjacency
for cSeg = 1 : mSeg
    A(cSeg, cSeg) = 0;
end

% only non-zero entry
if exist('idx', 'var') && ~isempty(idx)
    A(idx, :) = 0;
    A(:, idx) = 0;
end

D = zeros(mSeg, mSeg);
ind = find(A);
[is, js] = ind2sub([mSeg mSeg], ind);

fast = 0;

if (fast)
	if (strcmp(histDist, 'Chi_Square'))
        ds = conDstHst(Hst(is, :)', Hst(js, :)');
	else
        ds = conDstHst2(Hst(is, :)', Hst(js, :)');
	end
else
    % pair-wise distance
    % D2 = zeros(mSeg, mSeg);
    % ind = find(A);
    % for c = 1 : length(ind)
    %     [x, y] = ind2sub([mSeg, mSeg], ind(c));
    %     D2(x, y) = histDist(Hst(x, :), Hst(y, :));
    % end

    ds = [];

    step = 300;
    k = 1:step:length(is);
    for idx=1:length(k)-1

        if (idx < length(k)-1)
            i = is(k(idx):(k(idx+1)-1));
            j = js(k(idx):(k(idx+1)-1));
        else
            i = is(k(idx):length(is));
            j = js(k(idx):length(is));
        end

    if (strcmp(histDist, 'Chi_Square'))
        d = conDstHst(Hst(i, :)', Hst(j, :)');
    else
        d = conDstHst2(Hst(i, :)', Hst(j, :)');
    end

    ds = [ds; full(d')];

    end
end

D(ind) = ds;
D = sparse(D);
% equal('D', D, D2);
