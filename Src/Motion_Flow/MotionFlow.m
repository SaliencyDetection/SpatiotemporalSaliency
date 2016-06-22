function flowPath = MotionFlow(input_dir, video_name, video_type, output_path, method, type)

if(nargin < 5)
    type = 'forward';
end

output_dir = [output_path '/' method '/' type '/' video_name]; mkdir(output_dir);
output_mag_dir = [output_dir '/Mag']; mkdir(output_mag_dir);
output_flo_dir = [output_dir '/Flo']; mkdir(output_flo_dir);
output_mag_png_dir = [output_dir '/Mag_png']; mkdir(output_mag_png_dir);
output_flo_png_dir = [output_dir '/Flo_png']; mkdir(output_flo_png_dir);
output_brox_png_dir = [output_dir '/Brox_png']; mkdir(output_brox_png_dir);

flowPath = output_dir;

switch method
    case 'FastDeepFlow'
        calFastDeepFlow(input_dir, video_name, video_type, type, output_path, output_mag_dir, output_flo_dir, output_mag_png_dir, output_flo_png_dir, output_brox_png_dir);
    case 'HCOFlow'
        calHCOFlow(input_dir, video_name, video_type, type, output_path, output_mag_dir, output_flo_dir, output_mag_png_dir, output_flo_png_dir, output_brox_png_dir);
    case 'SparseFlow'
        calSparseFlow(input_dir, video_name, video_type, type, output_path, output_mag_dir, output_flo_dir, output_mag_png_dir, output_flo_png_dir, output_brox_png_dir);
    case 'CeLiuFlow'
        calCeLiuFlow(input_dir, video_name, video_type, type, output_path, output_mag_dir, output_flo_dir, output_mag_png_dir, output_flo_png_dir, output_brox_png_dir);
	case 'BroxFlow'
        calBroxFlow(input_dir, video_name, video_type, type, output_path, output_mag_dir, output_flo_dir, output_mag_png_dir, output_flo_png_dir, output_brox_png_dir);
    otherwise
        % call Ce Liu Optical Flow
        calCeLiuFlow(input_dir, video_name, video_type, type, output_path, output_mag_dir, output_flo_dir, output_mag_png_dir, output_flo_png_dir, output_brox_png_dir);
end
end

