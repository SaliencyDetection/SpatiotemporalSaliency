function Refinement(data_dir, video_name, video_type, segPath, description, params, inputFolder, outputFolder)

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

loadDir = [params.saveDir '/' params.dataset '/' inputFolder '/' video_name '/' contrast '/' description];
matInputDir = [loadDir '/SS_mat'];
pngInputDir = [loadDir '/SS_png'];
pngInputPath = GetPNGPath(pngInputDir);

saveDir = [params.saveDir '/' params.dataset '/SpatialRefinement/' outputFolder '/' params.method '/' video_name '/' contrast '/' description];
matOutputDir = [saveDir '/SS_mat']; mkdir(matOutputDir);
pngOutputDir = [saveDir '/SS_png'];
[pngOutputPath, pngOutputName] = GetPNGPath(pngOutputDir);
for i=1:length(pngOutputPath)
    mkdir(pngOutputPath{i});
end

load([segPath '/' video_name '_sp.mat']);
mSeg = length(labels);

image = dir([data_dir '/' video_name '/*.' video_type]);
nF = length(image);

for iF = 1 : nF
    
    %======================================================================
    %% load mat
    %matpath = sprintf('%s/frame_%04d.mat', matInputDir, iF);
    %load(matpath);
    
    im = imread([data_dir '/' video_name '/' image(iF).name]);
    
    %======================================================================
    %% spatial refinement
    
    L = Ls(:, :, iF);
    L = double(LabelsToLabels(L));
    
    Si = [];
    So = [];
    
    for ind = 1:length(pngOutputName)
        try
            Si{ind} = mat2gray(imread(sprintf('%s/frame_%04d.png', pngInputPath{ind}, iF)));
            So{ind} = SpatialRefinement(Si{ind}, params.method, im, L);
            %So{ind} = So{ind} .* Si{ind};
            writeImage(So{ind}, pngOutputPath{ind}, iF);
        catch
        end
    end
    
    %======================================================================
    %% write mat
    L = Ls(:, :, iF);
    
    sal = GetMeanVal(So{1}, L, mSeg);
    
    try
        sal_CI = GetMeanVal(So{2}, L, mSeg);
        sal_RC = GetMeanVal(So{3}, L, mSeg);
        salCI_C = GetMeanVal(So{4}, L, mSeg);
        salCI_I = GetMeanVal(So{5}, L, mSeg);
        salCI_O = GetMeanVal(So{6}, L, mSeg);
        salCI_MM = GetMeanVal(So{7}, L, mSeg);
        salCI_MO = GetMeanVal(So{8}, L, mSeg);
        salRC_O = GetMeanVal(So{9}, L, mSeg);
        salRC_C = GetMeanVal(So{10}, L, mSeg);
        salRC_M = GetMeanVal(So{11}, L, mSeg);
        salRC_V = GetMeanVal(So{12}, L, mSeg);
        salRC_D = GetMeanVal(So{13}, L, mSeg);
    catch
        sal_CI = [];    sal_RC = [];
        salCI_C = [];   salCI_I = [];   salCI_O = [];
        salCI_MM = [];  salCI_MO = [];
        salRC_O = [];   salRC_C = [];   salRC_M = [];  salRC_V = [];     salRC_D = [];
    end
    
	matpath = sprintf('%s/frame_%04d.mat', matOutputDir, iF);
    save(matpath, 'sal', 'sal_CI', 'sal_RC', 'salCI_C', 'salCI_I', 'salCI_O', 'salCI_MM', 'salCI_MO', 'salRC_O', 'salRC_C', 'salRC_M', 'salRC_V', 'salRC_D');
end

end

function writeImage(S, im_path, iF)
S = ranNor(S, ranX(S));
path = sprintf('%s/frame_%04d.png', im_path, iF);    
imwrite(S, path);
end