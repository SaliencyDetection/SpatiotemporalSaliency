function TemporalSaliency(data_dir, video_name, video_type, flowPath, segPath, description, params, inputFolder, outputFolder)

if (params.localContrast)
    contrast = 'Local';
else
    contrast = 'Global';
end

loadDir = [params.saveDir '/' params.dataset '/' inputFolder '/' video_name '/' contrast '/' description];
pngInputPath = GetPNGPath([loadDir '/SS_png']);
matInputDir = [loadDir '/SS_mat'];

saveDir = [params.saveDir '/' params.dataset '/' outputFolder '/' video_name '/' contrast '/' description];
matOutputDir = [saveDir '/SS_mat']; mkdir(matOutputDir);
[pngOutputPath, pngOutputName] = GetPNGPath([saveDir '/SS_png']);
for i=1:length(pngOutputPath)
    mkdir(pngOutputPath{i});
end

load([segPath '/' video_name '_sp.mat']);
mSeg = length(labels);

image = dir([data_dir '/' video_name '/*.' video_type]);
nF = length(image);

for i=1:length(pngOutputPath)
    spatialSaliency{i} = zeros(mSeg, nF);
end
     
for iF = 1 : nF
    matpath = sprintf('%s/frame_%04d.mat', matInputDir, iF);
    load(matpath);
    
    spatialSaliency{1}(:, iF) = sal;
    spatialSaliency{2}(:, iF) = sal_CI;
    spatialSaliency{3}(:, iF) = sal_RC;
    spatialSaliency{4}(:, iF) = salCI_C;
    spatialSaliency{5}(:, iF) = salCI_I;
    spatialSaliency{6}(:, iF) = salCI_O;
    spatialSaliency{7}(:, iF) = salCI_MM;
    spatialSaliency{8}(:, iF) = salCI_MO;
    spatialSaliency{9}(:, iF) = salRC_O;
    spatialSaliency{10}(:, iF) = salRC_C;
    spatialSaliency{11}(:, iF) = salRC_M;
    spatialSaliency{12}(:, iF) = salRC_V;
    spatialSaliency{13}(:, iF) = salRC_D;
end

temporalSaliency = spatialSaliency;

for ind=1:length(spatialSaliency)
    
    for iF=1:nF
        
        L = Ls(:,:,iF);
        label = unique(L);
        
        load([flowPath '/Mag/' image(iF).name(1:end-4) '.mat']);
        flo = readFlowFile([flowPath '/Flo/' image(iF).name(1:end-4) '.flo']);
        
        %imshow(mag);
        M = sigmf(mag,[10 0.5]);
        %figure; imshow(M);
        
        for iSeg=1:length(label)
            idxSeg = label(iSeg);
            idxL = find(L == idxSeg);
            meanM = mean(M(idxL));
            stdM = std(M(idxL));
            
            ws = round(max(1, params.maxSize * exp(- meanM * meanM * params.moSigma / (stdM + eps))));
            
            indxWsFirst = max(iF - ws, 1);
            indxWsLast = iF;
            
            indxWs = indxWsFirst:indxWsLast;
            weightWs = gaussmf(indxWs,[params.wsSigma indxWsLast]);
            weightWs = weightWs ./ sum(weightWs);
            
            temporalSaliency{ind}(iSeg, iF) = 0;
            for iWs = indxWsFirst:indxWsLast
                temporalSaliency{ind}(iSeg, iF) = temporalSaliency{ind}(iSeg, iF) + spatialSaliency{ind}(iSeg, iWs) * weightWs(iWs+1 - indxWsFirst);
            end
        end
        
        val = temporalSaliency{ind}(:, iF);
        S = val(L);
        
        writeImage(S, pngOutputPath{ind}, iF);
    end
end

for iF = 1 : nF
    sal = temporalSaliency{1}(:, iF);
    sal_CI = temporalSaliency{2}(:, iF);
    sal_RC = temporalSaliency{3}(:, iF);
    salCI_C = temporalSaliency{4}(:, iF);
    salCI_I = temporalSaliency{5}(:, iF);
    salCI_O = temporalSaliency{6}(:, iF);
    salCI_MM = temporalSaliency{7}(:, iF);
    salCI_MO = temporalSaliency{8}(:, iF);
    salRC_O = temporalSaliency{9}(:, iF);
    salRC_C = temporalSaliency{10}(:, iF);
    salRC_M = temporalSaliency{11}(:, iF);
    salRC_V = temporalSaliency{12}(:, iF);
    salRC_D = temporalSaliency{13}(:, iF);
    
    matpath = sprintf('%s/frame_%04d.mat', matOutputDir, iF);
    save(matpath, 'sal', 'sal_CI', 'sal_RC', 'salCI_C', 'salCI_I', 'salCI_O', 'salCI_MM', 'salCI_MO', 'salRC_O', 'salRC_C', 'salRC_M', 'salRC_V', 'salRC_D');
end

end

function writeImage(S, im_path, iF)
S = ranNor(S, ranX(S));
path = sprintf('%s/frame_%04d.png', im_path, iF);    
imwrite(S, path);
end