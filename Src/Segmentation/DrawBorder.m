function [ im ] = DrawBorder( im, L )

    im = im2double(im);
    
    [gx, gy] = gradient(double(L));
    
    L((gx.^2+gy.^2)==0) = 0;
    L(L>0) = 1;
    
    se = strel('disk', 1);
    L = imdilate(L,se);
    
    c1 = im(:,:,1);
    c2 = im(:,:,2);
    c3 = im(:,:,3);
    
    c1(L==1) = 1;
    c2(L==1) = 1;
    c3(L==1) = 0;
    
    im = cat (3, c1, c2, c3);


end

