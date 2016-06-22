function img_out_disp = gabor_filter(image)
% an example to demonstrate the use of gabor filter.
% requires lena.jpg in the same path.
% the results mimic:
% http://matlabserver.cs.rug.nl/edgedetectionweb/web/edgedetection_examples
% .html
% using default settings (except for in radians instead of degrees)
%
% note that gabor_fn only take scalar inputs, and multiple filters need to
% be generated using (nested) loops
%
% also, apparently the scaling of the numbers is different from the example
% software at
% http://matlabserver.cs.rug.nl
% but are consistent with the formulae shown there

lambda  = 8;
theta   = 0;
psi     = [0 pi/2];
gamma   = 0.5;
bw      = 1;
N       = 8;

img_in = im2double(image);
img_in(:,:,2:3) = [];   % discard redundant channels, it's gray anyway
img_out = zeros(size(img_in,1), size(img_in,2), N);
for n=1:N
    gb = gabor_fn(bw,gamma,psi(1),lambda,theta)...
        + 1i * gabor_fn(bw,gamma,psi(2),lambda,theta);
    % gb is the n-th gabor filter
    img_out(:,:,n) = imfilter(img_in, gb, 'symmetric');
    % filter output to the n-th channel
    theta = theta + 2*pi/N;
    % next orientation
end

% default superposition method, L2-norm
img_out_disp = sum(abs(img_out).^2, 3).^0.5;

% normalize
%img_out_disp = img_out_disp./max(img_out_disp(:));
img_out_disp = mat2gray(img_out_disp);
%figure;imshow(img_out_disp);

end

function gb=gabor_fn(bw,gamma,psi,lambda,theta)
% bw    = bandwidth, (1)
% gamma = aspect ratio, (0.5)
% psi   = phase shift, (0)
% lambda= wave length, (>=2)
% theta = angle in rad, [0 pi)
 
sigma = lambda/pi*sqrt(log(2)/2)*(2^bw+1)/(2^bw-1);
sigma_x = sigma;
sigma_y = sigma/gamma;

sz=fix(8*max(sigma_y,sigma_x));
if mod(sz,2)==0, sz=sz+1;end

% alternatively, use a fixed size
% sz = 60;
 
[x y]=meshgrid(-fix(sz/2):fix(sz/2),fix(sz/2):-1:fix(-sz/2));
% x (right +)
% y (up +)

% Rotation 
x_theta=x*cos(theta)+y*sin(theta);
y_theta=-x*sin(theta)+y*cos(theta);
 
gb=exp(-0.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*cos(2*pi/lambda*x_theta+psi);
%imshow(gb/2+0.5);

end
