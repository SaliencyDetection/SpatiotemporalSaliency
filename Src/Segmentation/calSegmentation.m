function calSegmentation()

input_dir = 'Data/10_Clips/Images';
flow_dir = 'save/10_Clips/MotionFlow';
output_dir = 'save/10_Clips/SuperPixel';
video_name = 'AN119T';
video_type = 'png';
method = 'TSP';
flow_method = 'CeLiuFlow';

addSegmentationPath(method);

Segmentation(input_dir, video_name, video_type, output_dir, method, flow_dir, flow_method);

end