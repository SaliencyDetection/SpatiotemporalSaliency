function addSpatialRefinementPath(methods)

addpath(genpath('Src/Spatial_Refinement'));
addpath(genpath('External/Multi-OS/Vlfeat-0.9.20/toolbox/mex'));

rmpath(genpath('External/Multi-OS/Graphcut_Maxflow'));
rmpath(genpath('External/Multi-OS/Cellular_Automata'));
rmpath(genpath('External/Multi-OS/CRF2D'));

switch methods
    case 'Graphcut'
        addpath(genpath('External/Multi-OS/Graphcut_Maxflow'));
    case 'SCA'
        addpath(genpath('External/Multi-OS/Cellular_Automata'));
	case 'Spatial'
        addpath(genpath('External/Multi-OS/CRF2D'));
end

end