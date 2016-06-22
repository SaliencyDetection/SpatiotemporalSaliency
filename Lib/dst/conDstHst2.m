function ds = conDstHst2(Hst1, Hst2)
% L2-normalized histogram distance.

[d, ~] = size(Hst1);

% normalize
len1 = sum(Hst1 .^ 2);
len2 = sum(Hst2 .^ 2);
len1 = real(sqrt(len1));
len2 = real(sqrt(len2));
Hst1 = Hst1 ./ (repmat(len1, d, 1) + eps);
Hst2 = Hst2 ./ (repmat(len2, d, 1) + eps);

ds = sum((Hst1 - Hst2) .^ 2) / 2;
ds = real(sqrt(ds));