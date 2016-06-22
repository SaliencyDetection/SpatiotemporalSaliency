function addFlowPath(method)

addpath(genpath('Src/Motion_Flow'));
addpath(genpath('External/Multi-OS/Vlfeat-0.9.20/toolbox/mex'));

rmpath(genpath('External/Linux/FastDeepFlow_ICCV_2013-1.0.1'));
rmpath(genpath('External/Linux/HCOFlow_CVPR_2015'));
rmpath(genpath('External/Linux/SparseFlow_CVPR_2015'));
rmpath(genpath('External/Multi-OS/OpticalFlow_Celiu'));
rmpath(genpath('External/Multi-OS/OpticalFlow_Brox'));

switch method
    case 'FastDeepFlow'
        addpath(genpath('External/Linux/FastDeepFlow_ICCV_2013-1.0.1'));
    case 'HCOFlow'
        addpath(genpath('External/Linux/HCOFlow_CVPR_2015'));
    case 'SparseFlow'
        addpath(genpath('External/Linux/SparseFlow_CVPR_2015'));
    case 'CeLiuFlow'
        addpath(genpath('External/Multi-OS/OpticalFlow_Celiu'));
    case 'BroxFlow'
        addpath(genpath('External/Multi-OS/OpticalFlow_Brox'));
end

end
