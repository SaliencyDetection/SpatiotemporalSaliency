function addFusionPath(methods)

addpath(genpath('Src/Fusion'));
addpath(genpath('External/Multi-OS/Vlfeat-0.9.20/toolbox/mex'));

rmpath(genpath('External/Multi-OS/Cellular_Automata'));
rmpath(genpath('External/Multi-OS/CRF2D'));

switch methods
    case 'CRF'
        addpath(genpath('External/Multi-OS/Cellular_Automata'));
    case 'MCA'
        addpath(genpath('External/Multi-OS/CRF2D'));
end

end