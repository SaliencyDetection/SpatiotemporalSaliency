function SpatialSaliency(data_dir, video_name, video_type, flowPath, segPath, description, params)

% feature

% salCF_C:    color
% salCF_I:    intensity
% salCF_O:    orientation
% salCF_MM:   motion magnitude
% salCF_MO:   motion orientation

% salRI_O:    object probability
% salRI_C:    distance to screen centroid
% salRI_M:    mean motion magnitude
% salRI_V:    veclocity
% salRI_D:    region size change

if (params.localContrast)
    contrast = 'Local';
else
    contrast = 'Global';
end

saveDir = [params.saveDir '/' params.dataset '/SpatialSaliency/' video_name '/' contrast '/' description];

[salCI_Cs, salCI_Is, salCI_Os, salCI_MMs, salCI_MOs, salRC_Os, salRC_Cs, salRC_Ms, salRC_Vs, salRC_Ds] = calSpatialFeatures(data_dir, video_name, video_type, flowPath, segPath, params);

if (params.useTrainedFeatureWeights)
    [FeatureWeights_CI, FeatureWeights_RC] = getFeatureWeights(params);
else
    FeatureWeights_CI = params.FeatureWeights_CI;
    FeatureWeights_RC = params.FeatureWeights_RC;
end

matDir = [saveDir '/SS_mat'];
mkdir(matDir);

pngDir = [saveDir '/SS_png'];
pngPath = GetPNGPath(pngDir);
for i=1:length(pngPath)
    mkdir(pngPath{i});
end

load([segPath '/' video_name '_sp.mat']);

image = dir([data_dir '/' video_name '/*.' video_type]);
nF = length(image);

for iF = 1 : nF

    salCI_C  = salCI_Cs(:, iF);         salCI_C = ranNor(salCI_C, ranX(salCI_C)); 
    salCI_I  = salCI_Is(:, iF);         salCI_I = ranNor(salCI_I, ranX(salCI_I));
    salCI_O  = salCI_Os(:, iF);         salCI_O = ranNor(salCI_O, ranX(salCI_O));
    salCI_MM = salCI_MMs(:, iF);        salCI_MM = ranNor(salCI_MM, ranX(salCI_MM));
    salCI_MO = salCI_MOs(:, iF);        salCI_MO = ranNor(salCI_MO, ranX(salCI_MO));
    
    salRC_O  = salRC_Os(:, iF);         salRC_O = ranNor(salRC_O, ranX(salRC_O));
    salRC_C  = salRC_Cs(:, iF);         salRC_C = ranNor(salRC_C, ranX(salRC_C));
    salRC_M  = salRC_Ms(:, iF);         salRC_M = ranNor(salRC_M, ranX(salRC_M));
    salRC_V  = salRC_Vs(:, iF);         salRC_V = ranNor(salRC_V, ranX(salRC_V));
    salRC_D  = salRC_Ds(:, iF);         salRC_D = ranNor(salRC_D, ranX(salRC_D));
    
    sal_CI = salCI_C*FeatureWeights_CI(1) + salCI_I*FeatureWeights_CI(2) + salCI_O*FeatureWeights_CI(3) + salCI_MM*FeatureWeights_CI(4) + salCI_MO*FeatureWeights_CI(5);
    sal_RC = salRC_O*FeatureWeights_RC(1) + salRC_C*FeatureWeights_RC(2) + salRC_M*FeatureWeights_RC(3) + salRC_V*FeatureWeights_RC(4) + salRC_D*FeatureWeights_RC(5);

    sal = sal_CI .* sal_RC;

    %% write to file
    matpath = sprintf('%s/frame_%04d.mat', matDir, iF);
    save(matpath, 'sal', 'sal_CI', 'sal_RC', 'salCI_C', 'salCI_I', 'salCI_O', 'salCI_MM', 'salCI_MO', 'salRC_O', 'salRC_C', 'salRC_M', 'salRC_V', 'salRC_D');
    
    %======================================================================
    %% write image
    
    L = Ls(:, :, iF);
    S = [];
    
    S{1} = sal(L);
    S{2} = sal_CI(L);   S{3} = sal_RC(L);
    S{4} = salCI_C(L);  S{5} = salCI_I(L);  S{6} = salCI_O(L);
    S{7} = salCI_MM(L); S{8} = salCI_MO(L);
    S{9} = salRC_O(L);  S{10} = salRC_C(L);  S{11} = salRC_M(L);
    S{12} = salRC_V(L); S{13} = salRC_D(L);
    
    for iS = 1:length(S)
        writeImage(S{iS}, pngPath{iS}, iF);
    end
    
end

end

function writeImage(S, im_path, iF)
S = ranNor(S, ranX(S));
path = sprintf('%s/frame_%04d.png', im_path, iF);    
imwrite(S, path);
end