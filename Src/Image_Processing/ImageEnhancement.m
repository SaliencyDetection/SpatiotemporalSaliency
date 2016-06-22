function output = ImageEnhancement(input, method, param)

switch (method)
    case 'Sigmoid'
        output = sigmf(input,[param.a param.c]);
	case 'Binary'
        output = Binary(input, param.BinMethod, param.level);
	case 'Gaussian'
        output = imgaussfilt(im2double(input), param.sigma);
	case 'BinGau'
        output = Binary(input, param.BinMethod, param.level);
        output = imgaussfilt(im2double(output), param.sigma);
	otherwise
        output = input;
end

end

function output = Binary(I, method, param)

I = mat2gray(I);

switch method
    case 'Manual'
        level = param;
    case 'AdaptiveThresh'
        level = mean2(I) + std2(I);
    case 'GrayThresh'
        level = graythresh(I);
    otherwise
        level = mean2(I);
end

output = im2bw(I, level);

end