function LayerFusion(data_dir, video_name, video_type, fusionParam, inputFolder, outputFolder)

if (fusionParam.params{1}.localContrast)
    contrast = 'Local';
else
    contrast = 'Global';
end

for i=1:length(fusionParam.params)
    params = fusionParam.params{i};
    loadDir = [params.saveDir '/' params.dataset '/' inputFolder '/' video_name '/' contrast '/' params.description];
    pngInputDir = [loadDir '/SS_png'];
    pngInputPath{i} = GetPNGPath(pngInputDir);
end

saveDir = [params.saveDir '/' params.dataset '/Fusion/' outputFolder '/' fusionParam.method '/' video_name '/' contrast];
pngOutputDir = [saveDir '/SS_png'];
[pngOutputPath, pngOutputName] = GetPNGPath(pngOutputDir);
for i=1:length(pngOutputPath)
    mkdir(pngOutputPath{i});
end

image = dir([data_dir '/' video_name '/*.' video_type]);
nF = length(image);

for iF = 1 : nF
    
    %======================================================================
    %% Enhancement
    
    path = [];
    
    for j=1:length(pngInputPath{1})
        for i=1:length(pngInputPath)
            path{i} = sprintf('%s/frame_%04d.png', pngInputPath{i}{j}, iF);
        end
        %close all;
        sal = Fusion(path, fusionParam.method, fusionParam.params{i}.weight);
        %imshow(sal);
        writeImage(sal, pngOutputPath{j}, iF);
    end
end

end

function writeImage(S, im_path, iF)
S = ranNor(S, ranX(S));
path = sprintf('%s/frame_%04d.png', im_path, iF);    
imwrite(S, path);
end