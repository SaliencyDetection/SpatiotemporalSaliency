function sal = Mean_fusion(imNames)

M = length(imNames); % the number of incorporated saliency maps

sal = 0;
for i=1:M
    im = im2double(imread(imNames{i}));
    %figure; imshow(im);
    sal = sal + im(:,:,1);
end

sal = sal / (M);

sal = mat2gray(sal);

end
