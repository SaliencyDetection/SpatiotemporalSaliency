function calTSP(img_dir, video_name, img_type, flo_dir, output_dir, params)

if (nargin < 6)
    params = setDefaultTSPParams();
    params.FlowType = 'forward'; %{'forward', 'backward'}
    flo_dir = [flo_dir '/' params.FlowType '/' video_name];
end

flo_dir = [flo_dir '/Flo'];

sp_dir = [output_dir '/SP_png'];
mkdir(sp_dir);

Ls = TSP(img_dir, img_type, flo_dir, sp_dir, params);

Ls = LabelsToLabels(Ls);
labels = unique(Ls);

save([output_dir '/' video_name '_sp.mat'], 'labels', 'Ls');

label_dir = [output_dir '/Labels_png'];
mkdir(label_dir);
LabelsToImages(Ls, label_dir);

end