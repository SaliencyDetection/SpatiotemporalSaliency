function calHCOFlow(input_dir, video_name, video_type, type, output_path, output_mag_dir, output_flo_dir, output_mag_png_dir, output_flo_png_dir, output_brox_png_dir)

input_dir = [input_dir '/' video_name];
image_file = dir([input_dir '/*.' video_type]);

if (nargin < 6)
output_dir = [output_path '/' method '/' type '/' video_name]; mkdir(output_dir);
output_mag_dir = [output_dir '/Mag']; mkdir(output_mag_dir);
output_flo_dir = [output_dir '/Flo']; mkdir(output_flo_dir);
output_mag_png_dir = [output_dir '/Mag_png']; mkdir(output_mag_png_dir);
output_flo_png_dir = [output_dir '/Flo_png']; mkdir(output_flo_png_dir);
end

options = setupOptions();

n = length(image_file);
for i=1:n-1
	Img1 = imread([input_dir '/' image_file(i).name]);
	Img2 = imread([input_dir '/' image_file(i+1).name]);
    
    switch type
        case 'forward'
            [flo, mag] = HCOFlow(Img1, Img2, options);
        case 'backward'
            [flo, mag] = HCOFlow(Img2, Img1, options);
        otherwise
            [flo, mag] = HCOFlow(Img1, Img2, options);
    end
	  
	save([output_mag_dir '/' image_file(i).name(1:end-4) '.mat'], 'mag');
	writeFlowFile(flo, [output_flo_dir '/' image_file(i).name(1:end-4) '.flo']);
	imwrite(mat2gray(mag), [output_mag_png_dir '/' image_file(i).name(1:end-4) '.png']);
	imwrite(flowToColor(flo), [output_flo_png_dir '/' image_file(i).name(1:end-4) '.png']);
end

save([output_mag_dir '/' image_file(n).name(1:end-4) '.mat'], 'mag');
writeFlowFile(flo, [output_flo_dir '/' image_file(n).name(1:end-4) '.flo']);
imwrite(mat2gray(mag), [output_mag_png_dir '/' image_file(n).name(1:end-4) '.png']);
imwrite(flowToColor(flo), [output_flo_png_dir '/' image_file(n).name(1:end-4) '.png']);
        
end
