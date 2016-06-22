function LabelsToImages(Ls, output_dir)

labels = unique(Ls(:));
colors = [];

maxLabel = max(labels);

for i=1:(maxLabel+10)
    colors = [colors; [rand() rand() rand()]];
end

for iF=1:size(Ls,3)
    L = Ls(:,:,iF);
    label = unique(L);
    c1 = zeros(size(L)); c2 = zeros(size(L)); c3 = zeros(size(L));
    for i=1:length(label)
        ind = (L == label(i));
        c1(ind) = colors(label(i)+1, 1);
        c2(ind) = colors(label(i)+1, 2);
        c3(ind) = colors(label(i)+1, 3);
    end
    
    im = cat (3, c1, c2, c3);
    imwrite(im, sprintf('%s/frame_%04d.png', output_dir, iF));
end

end