function [parFlow, parVoxs, parSeg, parSal, parInf] = setParameters()
% Obtain the default parameter for saliency.
%
% Input
%   src      -  hs src
%
% Output
%   parFlow  -  flow parameter
%   parVox   -  voxel parameter
%   parSeg   -  segmentation parameter
%   parSal   -  saliency parameter

% default optical flow parameter
parFlow.wF = 200; %window for smoothing the magitude
parFlow.dire = 'both';

alpha = 0.012;
ratio = 0.5;
wMi = 20;
nOutFP = 3;
nInFP = 1;
nSOR = 20;
parFlow.para = [alpha, ratio, wMi, nOutFP, nInFP, nSOR];


% default voxel parameter
%nL = 4;
%sigs = linspace(.5, .5, nL);
%cs = round(linspace(10, 100, nL));
%mis = [4000 2700 1400 100];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CVPR 2014 config
%wMa = 400;
%c_reg = 200; % not used
%range = 10;
%parVox = st('wMa', wMa, 'c_reg', c_reg, 'range', range, 'nL', 0, 'cl', 'hsv', 'uniqueColor', 0);
%nL = 2;
%sigs = linspace(.5, .5, nL);
%cs = round(linspace(10, 100, nL));
%mis = round(linspace(100, 100, nL));
%for cL = 1 : nL
%    parVoxs{cL} = stAdd(parVox, 'c', cs(cL), 'mi', mis(cL), 'sigma', sigs(cL));
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% my config for eli_walk

%nL = 5;
%sigs = linspace(.5, .5, nL);
%cs = round(linspace(5, 20, nL));
%mis = round(linspace(50, 200, nL));

%for cL = 1 : nL
%    parVox.c = cs(cL);
%    parVox.mi = mis(cL);
%    parVox.sigma = sigs(cL);
%    parVox.nL = nL;
    
%    parVox.wMa = 400;
%    parVox.c_reg = 200; % not used
%    parVox.range = 10;
%    parVox.uniqueColor = 0;

%    parVoxs{cL} = parVox;
%end

% my config for BUS

nL = 5;
sigs = linspace(1, 1, nL);
cs = round(linspace(30, 30, nL));
mis = round(linspace(200, 1000, nL));

for cL = 1 : nL
    parVox.c = cs(cL);
    parVox.mi = mis(cL);
    parVox.sigma = sigs(cL);
    parVox.nL = nL;
    
    parVox.wMa = 400;
    parVox.c_reg = 200; % not used
    parVox.range = 10;
    parVox.uniqueColor = 0;

    parVoxs{cL} = parVox;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% default segmentation parameter
parSeg.th = 0.1; %threshold for merge similar segments
parSeg.rat = 0.2; %ratio of maximum distance between region
parSeg.bins = [8 16 16 4]; 


% default saliency weight parameter
parSal.bins = [8 16 16 8 16 9 8]; %[L a b intensity flow_magnitude flow_orientation gabor_orientation]
parSal.sigS = 8;
parSal.direS = 'left';
parSal.wS = 24;
parSal.N = 300;
parSal.sigN = 0.03;
parSal.useTemporalWindows = 1;
parSal.localContrast = 1;
%% core local contrast: weight = size of region (no distance between 2 regions)
%% core global contrast: weight = size * distance
parSal.histDist = 'Chi_Square'; %'Norm2' , 'Chi_Square' %===> global contrast use Norm2


%default hierarchical inference
parInf.beta = [4 3 2 1 0.5];
parInf.lambda = linspace(0.1, 0.1, nL);

parInf.optimizeEnergy = 0;

