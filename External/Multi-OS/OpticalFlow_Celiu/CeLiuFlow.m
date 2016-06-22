function [flow, mag] = CeLiuFlow(Img1, Img2)

% parameters
alpha = 0.012;
ratio = 0.5;
wMi = 20;
nOutFP = 3;
nInFP = 1;
nSOR = 20;
options = [alpha, ratio, wMi, nOutFP, nInFP, nSOR];

% call Ce Liu Optical Flow
[vx, vy] = Coarse2FineTwoFrames(im2double(Img1), im2double(Img2), options);

flow(:,:,1) = vx;
flow(:,:,2) = vy;

mag = computeMagnitude(flow);

end
