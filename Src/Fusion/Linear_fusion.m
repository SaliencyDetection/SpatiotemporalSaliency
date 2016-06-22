function sal = Linear_fusion(imNames, weights)

M = length(imNames); % the number of incorporated saliency maps

sal = 0;
for i=1:M
    im = im2double(imread(imNames{i}));
    sal = sal + im(:,:,1) * weights(i);
end

sal = mat2gray(sal);

end
