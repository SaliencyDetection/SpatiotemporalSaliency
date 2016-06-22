function weights = CRF_train_weights(mask_path, feature_map_paths)

scale = 100;

mask_file = dir([mask_path '/*.png']);

training_set_length = length(mask_file);
labeled_masks =  zeros(scale, scale, training_set_length);

nLayers = length(feature_map_paths);
feature_maps = zeros(nLayers, scale, scale, training_set_length);

% Load the training labeled masks.
% Load the feature-map features.
for i = 1:training_set_length
    
    name = mask_file(i).name;
    
	training_mask = imread([mask_path '/' name]);
    training_mask = im2double(training_mask);
    training_mask = imresize(training_mask, [scale scale]);
    labeled_masks(:, :, i) = training_mask(:,:,1);
        
    for j=1:nLayers
        feature_map = imread([feature_map_paths{j} '/' name]);
        feature_map = im2double(feature_map);
        feature_map = imresize(feature_map, [scale scale]);
        feature_maps(j, :, :, i) = feature_map(:,:,1);
    end
end

% Make features and feature engine.
featureEng = latticeFeatures(0, 0);

% Supply the feature maps to the CRF framework.
traindata.nodeFeatures = mkNodeFeatures(featureEng, feature_maps);
traindata.edgeFeatures = mkEdgeFeatures(featureEng, feature_maps);
traindata.nodeLabels = labeled_masks;
traindata.ncases = length(training_set_length);
trainNdx = 1:traindata.ncases;

nNodeFeatures = size(traindata.nodeFeatures, 1);
nEdgeFeatures = size(traindata.edgeFeatures, 1);
winit = initWeights(featureEng, nNodeFeatures, nEdgeFeatures);

% I will figure it out later what nstates mean.
nstates = 2;
% Random params
infEng = latticeInferBP(nstates);

% BFGS training with Belief - Propagation
reg = 1;
maxIter = 3;
options = optimset('Display','iter','Diagnostics','off','GradObj','on', 'LargeScale','off','MaxFunEval',maxIter);

gradFunc = @scrfGradient;
gradArgs = {featureEng, infEng, traindata, reg};

weights = fminunc(gradFunc,winit,options,trainNdx,gradArgs{:});

end
