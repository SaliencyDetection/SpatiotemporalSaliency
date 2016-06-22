function [salCI_Cs, salCI_Is, salCI_Os, salCI_MMs, salCI_MOs, salRC_Os, salRC_Cs, salRC_Ms, salRC_Vs, salRC_Ds] = calSpatialFeatures(data_dir, video_name, video_type, flowPath, segPath, params)

image = dir([data_dir '/' video_name '/*.' video_type]);
nF = length(image);

load([segPath '/' video_name '_sp.mat']);
mSeg = length(labels);

% spatial prior
im = imread([data_dir '/' video_name '/' image(1).name]);
siz = size(im);
[XD, YD] = computeRegionSpaXY(siz);

% loop the video
salCI_Cs = zeros(mSeg, nF);     % color
salCI_Is = zeros(mSeg, nF);     % intensity 
salCI_Os = zeros(mSeg, nF);     % orientation
salCI_MMs = zeros(mSeg, nF);    % flow magnitude
salCI_MOs = zeros(mSeg, nF);    % flow orientation

salRC_Os = zeros(mSeg, nF);     % object probability
salRC_Cs = zeros(mSeg, nF);     % distance to screen centroid
salRC_Ms = zeros(mSeg, nF);     % mean motion magnitude
salRC_Vs = zeros(mSeg, nF);     % veclocity (location change)
salRC_Ds = zeros(mSeg, nF);     % regional deformation (size change)

for iF = 1 : nF
    
    im = imread([data_dir '/' video_name '/' image(iF).name]);
    load([flowPath '/Mag/' image(iF).name(1:end-4) '.mat']);
    flo = readFlowFile([flowPath '/Flo/' image(iF).name(1:end-4) '.flo']);
    
    % Compute spatial features
    L = Ls(:, :, iF);
    iLabel = unique(L);
    
    % Compute Contrast Information
    [area, xDs, yDs] = calSpatialInfo(L, XD, YD);
    [Hst_Col, Hst_Ori, Hst_Int, Hst_MagF, Hst_OriF] = calContrastFeatures(im, mag, flo, L, params.bins);
    if (params.localContrast)
        %% local contrast
        [salCI_Cs(:, iF), salCI_Is(:, iF), salCI_Os(:, iF), salCI_MMs(:, iF), salCI_MOs(:, iF)] = calLocalContrastInformation(Hst_Col, Hst_Int, Hst_Ori, Hst_MagF, Hst_OriF, L, area, siz, mSeg);
    else
        %% global contrast
         [salCI_Cs(:, iF), salCI_Is(:, iF), salCI_Os(:, iF), salCI_MMs(:, iF), salCI_MOs(:, iF)] = calGlobalContrastInformation(Hst_Col, Hst_Int, Hst_Ori, Hst_MagF, Hst_OriF, L, area, siz, mSeg);
    end
    
    % Compute motion features
    [areas, xCens, yCens] = maskRegCen(uint16(L), mSeg);
    cens = [xCens / siz(2); yCens / siz(1)];
    
    if (iF == 1)
        areas0 = zeros(1, mSeg);
        cens0 = zeros(2, mSeg);
    end
    
    indx = unique([find(areas==0) find(areas0==0)]);
    
    % change size
    sVal_Def = abs(areas - areas0);
    sVal_Def = sVal_Def';
    sVal_Def(indx) = 0;
    areas0 = areas;
    
    % change location
    d = cens - cens0;
    sVal_Vel = sqrt(d(1,:) .* d(1,:) + d(2,:) .* d(2,:));
    sVal_Vel = sVal_Vel';
    sVal_Vel(indx) = 0;
    cens0 = cens;
    
    % Compute Regional Chracteristics
    [Val_Obj, Val_Cen, Val_MagF] = calRegionalFeatures(im, mag, L, XD, YD, siz);
    [salRC_Os(:, iF), salRC_Cs(:, iF), salRC_Ms(:, iF), salRC_Vs(:, iF), salRC_Ds(:, iF)] = calRegionalChracteristics(Val_Obj, Val_Cen, Val_MagF, sVal_Vel, sVal_Def, L, mSeg);
end    
    
end
