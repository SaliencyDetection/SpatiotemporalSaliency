function addSegmentationPath(method)

addpath(genpath('Src/Segmentation'));
addpath(genpath('External/Multi-OS/Vlfeat-0.9.20/toolbox/mex'));

rmpath(genpath('External/Linux/TSP_CVPR_2013'));

switch method
    case 'TSP'
        addpath(genpath('Src/Motion_Flow'));
        addpath(genpath('External/Linux/TSP_CVPR_2013'));
end

end