function labels = SLICsegmentation(im, K, compactness)

method = 'vlfeat';

switch method
    case 'SLICmex'
        [labels, numlabels] = slicmex(im, K, compactness); %default = 10
    case 'vlfeat'
        siz = round(sqrt(size(im,1) * size(im,2) / K));
        
        imlab = vl_xyz2lab(vl_rgb2xyz(im)) ;
        labels = vl_slic(single(imlab), siz, compactness); %default = 0.1
end


end