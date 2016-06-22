function [salient_map, salient_map_norm, output_energy] = CRF_fusion(sal_maps, weights)

[height, width] = size(sal_maps{1});
M = length(sal_maps);

% Prepare feature maps for inference into CRF framework.
feature_maps = zeros(M, height, width, 1);
for i=1:M
    feature_maps(i, :, :, 1) = sal_maps{i};
end

% Prepare feature engine.
featureEng = latticeFeatures(0, 0);

testdata.nodeFeatures = mkNodeFeatures(featureEng,feature_maps);
testdata.edgeFeatures = mkEdgeFeatures(featureEng,feature_maps);
testdata.nodeLabels = zeros(height, width, 1); % Dummy node labels.
testdata.ncases = 1;

featureEng = enterEvidence(featureEng, testdata, 1);
[nodePot, edgePot] = mkPotentials(featureEng, weights);

nstates = 2;
infEng = latticeInferBP(nstates);
[nodeBel, MAPlabels, niter, edgeBel, logZ] = infer(infEng, nodePot, edgePot);

crf_inference_map = imresize(MAPlabels, [height width]);
salient_map_norm = crf_inference_map;
crf_inference_map = (crf_inference_map - min(crf_inference_map(:))) / (max(crf_inference_map(:)) - min(crf_inference_map(:)));

salient_map = crf_inference_map;
output_energy = logZ;

end
