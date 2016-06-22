function flowPath = calMotionFlow(input_dir, video_name, video_type, output_dir, method)

%input_dir = 'Data/10_Clips/Images';
%video_name = 'AN119T';
%video_type = 'png';
%output_dir = 'save/10_Clips/MotionFlow';
%method = 'CeLiuFlow';
types = {'forward', 'backward'};

addFlowPath(method);

for i=1:length(types)
    type = types{i};
    flowPath{i} = MotionFlow(input_dir, video_name, video_type, output_dir, method, type);
end


end