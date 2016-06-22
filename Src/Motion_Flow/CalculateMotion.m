function flowPath = CalculateMotion(data_dir, video_name, video_type, flow_dir, method, skip)

if (~skip)
    flowPath = calMotionFlow(data_dir, video_name, video_type, flow_dir, method);
else
    types = {'forward', 'backward'};
    output = 0;
    for i=1:length(types)
        flowPath{i} = [flow_dir '/' method '/' types{i} '/' video_name];
        output = output + check(flowPath{i});
    end
    if (output == 0)
        flowPath = calMotionFlow(data_dir, video_name, video_type, flow_dir, method);
    end
end

end

function output = check(path)
    if (~exist(path, 'dir'))
        output = 0;
        return;
    end
    
    if (~exist([path '/Flo'], 'dir') || ~exist([path '/Flo_png'], 'dir') || ~exist([path '/Mag'], 'dir') || ~exist([path '/Mag_png'], 'dir'))
        output = 0;
        return;
    end

    flo = dir([path '/Flo_png/*.png']);
    mag = dir([path '/Mag_png/*.png']);
    
    if (length(flo) == length(mag))
        output = 1;
    else
        output = 0;
    end
end
