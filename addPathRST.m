function addPathRST()

global footpath;
footpath = pwd;

addpath(genpath([footpath '/Src']));
addpath(genpath([footpath '/Lib']));
addpath(genpath([footpath '/RST']));

addpath(genpath([footpath '/External/Multi-OS/objectness-release-v2.0']));

%addpath(genpath([footpath '/External/Cellular_Automata']));
%addpath(genpath([footpath '/External/Graphcut_Maxflow']));

end
