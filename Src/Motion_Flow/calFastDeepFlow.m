function calFastDeepFlow(input_dir, video_name, video_type, type, output_path, output_mag_dir, output_flo_dir, output_mag_png_dir, output_flo_png_dir, output_brox_png_dir)

input_dir = [input_dir '/' video_name];
image_file = dir([input_dir '/*.' video_type]);

if (nargin < 6)
output_dir = [output_path '/' method '/' type '/' video_name]; mkdir(output_dir);
output_mag_dir = [output_dir '/Mag']; mkdir(output_mag_dir);
output_flo_dir = [output_dir '/Flo']; mkdir(output_flo_dir);
output_mag_png_dir = [output_dir '/Mag_png']; mkdir(output_mag_png_dir);
output_flo_png_dir = [output_dir '/Flo_png']; mkdir(output_flo_png_dir);
end

n = length(image_file);
for i=1:n-1
	path_img1 = [input_dir '/' image_file(i).name];
	path_img2 = [input_dir '/' image_file(i+1).name];
    path_flow = [output_flo_dir '/' image_file(n).name(1:end-4) '.flo'];
    
    switch type
        case 'forward'
            FastDeepFlow(path_img1, path_img2, path_flow);
            % FastDeepFlow(path_img1, path_img2, path_flow, 'useDeepMatching');
        case 'backward'
            FastDeepFlow(path_img2, path_img1, path_flow);
            % FastDeepFlow(path_img2, path_img1, path_flow, 'useDeepMatching');
        otherwise
            FastDeepFlow(path_img1, path_img2, path_flow);
            % FastDeepFlow(path_img1, path_img2, path_flow, 'useDeepMatching');
    end
    
    flo = readFlowFile(path_flow);
    mag = computeMagnitude(flo);
    
    save([output_mag_dir '/' image_file(i).name(1:end-4) '.mat'], 'mag');
	imwrite(mat2gray(mag), [output_mag_png_dir '/' image_file(i).name(1:end-4) '.png']);
	imwrite(flowToColor(flo), [output_flo_png_dir '/' image_file(i).name(1:end-4) '.png']);
end

save([output_mag_dir '/' image_file(n).name(1:end-4) '.mat'], 'mag');
writeFlowFile(flo, [output_flo_dir '/' image_file(n).name(1:end-4) '.flo']);
imwrite(mat2gray(mag), [output_mag_png_dir '/' image_file(n).name(1:end-4) '.png']);
imwrite(flowToColor(flo), [output_flo_png_dir '/' image_file(n).name(1:end-4) '.png']);

end
