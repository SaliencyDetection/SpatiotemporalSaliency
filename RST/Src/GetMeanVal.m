function [val, im] = GetMeanVal(img, Ls, mSeg)

im = img;

label = unique(Ls);
n = length(label);

if (nargin < 3)
    mSeg = n;
end

val = zeros(mSeg, 1);

for i=1:n
    ind = (label(i) == Ls);
    val(label(i)) = mean(img(ind));
    im(ind) = val(label(i));
end

end