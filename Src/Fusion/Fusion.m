function image_saliency = Fusion(imNames, method, weights, model, L)

switch (method)
    case 'MCA'
        image_saliency = MCA_fusion(imNames);
	case 'Linear'
        image_saliency = Linear_fusion(imNames, weights);
	case 'CRF'
    case 'Liblinear_SVR'
        L = LabelsToLabels(L);
        label = unique(L);
        
        data_mean = zeros(length(label), length(imNames));
        data_std = zeros(length(label), length(imNames));
            
        for i=1:length(label)
            for j=1:length(imNames)
                im = im2double(imread(imNames{j}));
                im = im(:,:,1);
                data_mean(i,j) = mean(im(label(i)==L));
                data_std(i,j) = std(im(label(i)==L));
            end
        end
        
        feat = sparse([data_mean data_std]);
        zero = zeros(length(label),1);
        prob_estimates = predict(zero, feat, model, '-q');
        
        sal = mat2gray(prob_estimates);
        image_saliency = sal(L);
    case 'Mean'
        image_saliency = Mean_fusion(imNames);
    otherwise
        image_saliency = Mean_fusion(imNames);
end

end
