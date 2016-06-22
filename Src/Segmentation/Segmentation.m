function segPath = Segmentation(input_dir, video_name, video_type, output_dir, method, flow_dir, description, params, skip)

img_dir = [input_dir '/' video_name];

output_dir = [output_dir '/' method '/' video_name];
if (nargin > 7)
    output_dir = [output_dir '/' description];
end

segPath = output_dir;

if (skip && exist([output_dir '/' video_name '_sp.mat'], 'file'))
    return;
end

mkdir(output_dir);

addSegmentationPath(method);

if (nargin < 8)
    switch (method)
        case 'TSP'
            calTSP(img_dir, video_name, video_type, flow_dir, output_dir);
        case 'SLIC'
            calSLIC(img_dir, video_name, video_type, output_dir);
        case 'Pedro'
            calPedro(img_dir, video_name, video_type, output_dir);
        otherwise
            return;
    end
else
    switch (method)
        case 'TSP'
            calTSP(img_dir, video_name, video_type, flow_dir, output_dir, params);
        case 'SLIC'
            calSLIC(img_dir, video_name, video_type, output_dir, params);
        case 'Pedro'
            calPedro(img_dir, video_name, video_type, output_dir, params);
        otherwise
            return;
    end
end

end