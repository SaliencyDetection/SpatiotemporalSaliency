function calPedro(img_dir, video_name, img_type, output_dir, params)

if (nargin < 5)
    params = setDefaultPedroParams();
end

sp_dir = [output_dir '/SP_png'];
mkdir(sp_dir);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

files = dir([img_dir '/*.' img_type]);
files = files(1:end);

oim = imread([img_dir '/' files(1).name]);
Ls = zeros(size(oim,1), size(oim,2), numel(files), 'uint32');

sp_dir = [output_dir '/SP_png'];

for i=1:numel(files)
    disp([' -> Frame '  num2str(i) ' / ' num2str(numel(files))]);

    im = imread([img_dir '/' files(i).name]);
    L = PedroSegmentation(im, params.sigma, params.K, params.min_size);
    Ls(:,:,i) = L;
    
    %----------------------------------------------------------------------
    im = DrawBorder( im, L );
    
    imwrite(im, sprintf('%s/frame_%04d.png', sp_dir, i));                                                                                                                                                                                                                                                                                                                                                                                         
end

labels = unique(Ls);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save([output_dir '/' video_name '_sp.mat'], 'labels', 'Ls');

label_dir = [output_dir '/Labels_png'];
mkdir(label_dir);
LabelsToImages(Ls, label_dir);

end
