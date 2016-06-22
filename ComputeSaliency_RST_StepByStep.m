function ComputeSaliency_RST_StepByStep(dataset, idxFirst, idxLast)

addPathRST();

%==========================================================================
% Input

%dataset = {'Weizmann'; '10_Clips'; 'MCL'; 'JHMDB'};
%video_type = {'png'; 'jpg'};

experiment = 'RST_Saliency';
saveDir = 'save';

saveDir = [saveDir '/' experiment];

%==========================================================================
% Config

%--------------------------
% Flow
flowConfig.method = 'CeLiuFlow';

%--------------------------
switch dataset
    case 'Weizmann'
        sp = [10 20 30 40];
        video_type = 'png';
    case '10_Clips'
        sp = [20 30 40 50];
        video_type = 'png';
    case 'MCL'
        sp = [15 20 30 40];
        video_type = 'png';
    case 'JHMDB'
        sp = [20 30 40 50];
        video_type = 'png';
	case 'SegTrack'
        sp = [160 170 180];
        video_type = 'png';
    case 'SegTrack2'
        sp = [160 170 180];
        video_type = 'jpg';
    case 'DAVIS'
        sp = [170 180 200];
        video_type = 'jpg';
end

if(~exist('idxFirst', 'var') && ~exist('idxLast', 'var'))
    idxFirst = 1;
    idxLast = 1000;
end

% Segmentation
segCofig.levels = size(sp,2);

segCofig.method = 'TSP';
addSegmentationPath(segCofig.method);

params = setDefaultTSPParams();
params.FlowType = 'forward';

switch (params.FlowType)
    case 'forward'
        params.f=1;
    case 'backward'
        params.f=2;
end

for i=1:segCofig.levels
    segCofig.params(i) = params;
    segCofig.params(i).K = sp(i);
    segCofig.description{i} = sprintf('%d', segCofig.params(i).K);
end

%--------------------------
% Spatial Saliency   

for i=1:segCofig.levels
    sSaliencyCofig.description{i} = segCofig.description{i};
    sSaliencyCofig.params(i).bins = [16 16 16 16 16 16 16 9]; %[L a b Hue intensity gabor_orientation flow_magnitude flow_orientation]
    sSaliencyCofig.params(i).localContrast = 0;
    
    sSaliencyCofig.params(i).FeatureWeights_CI = [4 1 1 2 2]; %[color intensity gabor_orientation flow_magnitude flow_orientation]
    sSaliencyCofig.params(i).FeatureWeights_RC = [4 2 4 0 0]; %[objectness center flow_magnitude veclocity size_change]
    sSaliencyCofig.params(i).useTrainedFeatureWeights = 0;
    sSaliencyCofig.params(i).alpha = 0.9;
    
    sSaliencyCofig.params(i).experiment = experiment;
    sSaliencyCofig.params(i).dataset = dataset;
    sSaliencyCofig.params(i).saveDir = saveDir;
    sSaliencyCofig.params(i).weightFile = [sSaliencyCofig.params(i).experiment '_' sSaliencyCofig.params(i).dataset];
end

%--------------------------
% Temporal Saliency   

for i=1:segCofig.levels
    tSaliencyCofig.description{i} = sSaliencyCofig.description{i};
    tSaliencyCofig.params(i).localContrast =  sSaliencyCofig.params(i).localContrast;
    
    tSaliencyCofig.params(i).moSigma = 2;
    tSaliencyCofig.params(i).maxSize = 50;
    tSaliencyCofig.params(i).wsSigma = 10;
    
    tSaliencyCofig.params(i).experiment = experiment;
    tSaliencyCofig.params(i).dataset = dataset;
    tSaliencyCofig.params(i).saveDir = saveDir;
end

%--------------------------
% Spatial Refinement   

spatial_refinment = 'Graphcut'; 
addSpatialRefinementPath(spatial_refinment);

for i=1:segCofig.levels   
    sRefineCofig.description{i} = sSaliencyCofig.description{i};
    
    sRefineCofig.params(i).localContrast = sSaliencyCofig.params(i).localContrast;
    sRefineCofig.params(i).experiment = sSaliencyCofig.params(i).experiment;
    sRefineCofig.params(i).dataset = sSaliencyCofig.params(i).dataset;
    sRefineCofig.params(i).saveDir = sSaliencyCofig.params(i).saveDir;
    
    sRefineCofig.params(i).method = spatial_refinment;
end

%--------------------------
% Image Enhancement  
SigmoidParam.method = 'Sigmoid';
SigmoidParam.a = 10;
SigmoidParam.c = 0.6;
SigmoidParam.description = sprintf('%d_%1.2f', SigmoidParam.a, SigmoidParam.c);

% Contrast Enhancement  
for i=1:segCofig.levels   
    sEnhanceCofig.description{i} = sSaliencyCofig.description{i};
    
    % Sigmoid
    sEnhanceCofig.params{i}= SigmoidParam;
    
	sEnhanceCofig.params{i}.localContrast = sSaliencyCofig.params(i).localContrast;
    sEnhanceCofig.params{i}.experiment = sSaliencyCofig.params(i).experiment;
    sEnhanceCofig.params{i}.dataset = sSaliencyCofig.params(i).dataset;
    sEnhanceCofig.params{i}.saveDir = sSaliencyCofig.params(i).saveDir;
end

%--------------------------
% Layer Fusion
sFusion.method = 'MCA'; % {'Mean', 'MCA'}

for i=1:segCofig.levels      
	sFusion.params{i}.localContrast = sSaliencyCofig.params(i).localContrast;
    sFusion.params{i}.experiment = sSaliencyCofig.params(i).experiment;
    sFusion.params{i}.dataset = sSaliencyCofig.params(i).dataset;
    sFusion.params{i}.saveDir = sSaliencyCofig.params(i).saveDir;
    sFusion.params{i}.description = sSaliencyCofig.description{i};
    sFusion.params{i}.weight = [];
end

%==========================================================================
% Pre-processing

data_dir = ['Data/' dataset '/Images'];

videos = dir(data_dir);

if (2+idxLast <= length(videos))
    videos = videos(2+idxFirst:2+idxLast);
else
    videos = videos(2+idxFirst:end);
end

addFlowPath(flowConfig.method);
addSegmentationPath(segCofig.method);

%==========================================================================
% Motion Flow
flow_dir = [saveDir '/' dataset '/MotionFlow'];
flowPath = cell(length(videos), 1);
for i=1:length(videos)
	video_name = videos(i).name;
	fprintf('* Calculate Motion Flow: (%d - %d) %s\n', i, length(videos), video_name);
	flowPath{i} = CalculateMotion(data_dir, video_name, video_type, flow_dir, flowConfig.method, 1);
end

%==========================================================================
% Compute Objecness   
%global footpath;
%
%params = defaultParams([footpath '/External/Multi-OS/objectness-release-v2.0']);
%
%for i=1:length(videos)
%    video_name = videos(i).name;
%    image = dir([data_dir '/' video_name '/*.' video_type]);
%    fprintf('* Calculate Objecness: (%d - %d) %s\t', i, length(videos), video_name);
%    mkdir([saveDir '/' dataset '/Objectness/' video_name '/Heatmap']);
%    mkdir([saveDir '/' dataset '/Objectness/' video_name '/Saliency']);
%    mkdir([saveDir '/' dataset '/Objectness/' video_name '/Saliency2']);
%    tic;
%    for j=1:length(image)
%        img = imread([data_dir '/' video_name '/' image(j).name]);
%        boxes = runObjectness(img,[footpath '/External/Multi-OS/objectness-release-v2.0'],10000,params);
%        [heat, gray] = computeObjectnessHeatMap(img,boxes);
%        imwrite(heat, sprintf('%s/frame_%04d.png', [saveDir '/' dataset '/Objectness/' video_name '/Heatmap'], j));
%        imwrite(mat2gray(gray), sprintf('%s/frame_%04d.png', [saveDir '/' dataset '/Objectness/' video_name '/Saliency'], j));
%        imwrite(mat2gray(sigmf(mat2gray(gray),[10 0.8])), sprintf('%s/frame_%04d.png', [saveDir '/' dataset '/Objectness/' video_name '/Saliency2'], j));
%    end
%    toc;
%end

%==========================================================================
% Video Segmentation
seg_dir = [saveDir '/' dataset '/SuperPixel'];
segPath = cell(length(videos), segCofig.levels);
for i=1:length(videos)
	video_name = videos(i).name;
	fprintf('* Calculate Video Segmentation: (%d - %d) %s\n', i, length(videos), video_name);
	for j=1:segCofig.levels
        tic;
        %try
            segPath{i,j} = Segmentation(data_dir, video_name, video_type, seg_dir, segCofig.method, flowPath{i}{segCofig.params(j).f}, segCofig.description{j}, segCofig.params(j), 1);
        %catch
        %end
        fprintf('\t _ Level: %d\t\t', j);
        toc;
	end
end

%==========================================================================
% Compute Spatial Saliency
% for i=1:length(videos)
%     video_name = videos(i).name;
%     fprintf('* Calculate Spatial Saliency: (%d - %d) %s\n', i, length(videos), video_name);
%     for j=1:segCofig.levels
%         tic;
%         if (~isempty(segPath{i,j}))
%             SpatialSaliency(data_dir, video_name, video_type, flowPath{i}{segCofig.params(j).f}, segPath{i,j}, sSaliencyCofig.description{j}, sSaliencyCofig.params(j));
%         end
%         fprintf('\t _ Level: %d\t\t', j);
%         toc;
%     end
% end

%==========================================================================
% Compute Temporal Saliency
% for i=1:length(videos)
%     video_name = videos(i).name;
%     fprintf('* Calculate Temporal Saliency: (%d - %d) %s\n', i, length(videos), video_name);
%     for j=1:segCofig.levels
%         tic;
%         if (~isempty(segPath{i,j}))
%             TemporalSaliency(data_dir, video_name, video_type, flowPath{i}{segCofig.params(j).f}, segPath{i,j}, tSaliencyCofig.description{j}, tSaliencyCofig.params(j), 'SpatialSaliency', 'TemporalSaliency');
%         end
%         fprintf('\t _ Level: %d\t\t', j);
%         toc;
%     end
% end

%==========================================================================
% Compute Spatial Refinement
% for i=1:length(videos)
%     video_name = videos(i).name;
%     fprintf('* Calculate Spatial Refinement: (%d - %d) %s\n', i, length(videos), video_name);
%     for j=1:segCofig.levels
%         tic;
%         fprintf('\t _ Level: %d\t', j);
%         Refinement(data_dir, video_name, video_type, segPath{i,j}, sRefineCofig.description{j}, sRefineCofig.params(j), 'TemporalSaliency', 'TemporalSaliency');
%         toc;
%     end
% end

%==========================================================================
% Fusion
for i=1:length(videos)
    video_name = videos(i).name;
    fprintf('* Calculate Layer Fusion: (%d - %d) %s\t', i, length(videos), video_name);
    tic;
    LayerFusion(data_dir, video_name, video_type, sFusion, 'SpatialRefinement/TemporalSaliency/Graphcut', 'Graphcut/TemporalSaliency');
    toc;
end

%==========================================================================
% Enhancement Fusion
for i=1:length(videos)
    video_name = videos(i).name;
    fprintf('* Calculate Final Refinement: (%d - %d) %s\t', i, length(videos), video_name);
    j=1;
    tic;
    Enhancement(data_dir, video_name, video_type, segPath{i,j}, [], sEnhanceCofig.params{j}, ['Fusion/Graphcut/TemporalSaliency/' sFusion.method], ['Enhancement/Fusion/' sEnhanceCofig.params{j}.method '/' sEnhanceCofig.params{j}.description '/Graphcut/TemporalSaliency/' sFusion.method]);
    toc;
end


end
