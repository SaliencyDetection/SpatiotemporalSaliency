function [sp_labels] = TSP(img_dir, img_type, flow_dir, sp_dir, params)
%
%   All work using this code should cite:
%   J. Chang, D. Wei, and J. W. Fisher III. A Video Representation Using
%      Temporal Superpixels. CVPR 2013.
%

%--------------------------------------------------------------------------

[pathstr, name, ext] = fileparts(mfilename('fullpath'));
addpath ([pathstr '/mex']);
addpath ([pathstr '/util']);

if (nargin < 4)
    params = setDefaultTSPParams();
end

if(nargin < 3)
    sp_dir = [];
else
    mkdir(sp_dir);
end

%--------------------------------------------------------------------------

files = dir([img_dir '/*.' img_type]);
files = files(1:end);

oim = imread([img_dir '/' files(1).name]);
sp_labels = zeros(size(oim,1), size(oim,2), numel(files), 'uint32');

disp('Staring Segmentation');
for frame_it=1:numel(files)
    disp([' -> Frame '  num2str(frame_it) ' / ' num2str(numel(files))]);

    oim = imread([img_dir '/' files(frame_it).name]);

    if (frame_it==1)
        IMG = IMG_init(oim, params);
    else
        % optical flow returns actual x and y flow... flip it
        flow = readFlowFile([flow_dir '/' files(frame_it-1).name(1:end-4) '.flo']);
        vx = flow(:,:,1);
        vy = flow(:,:,2);
        IMG = IMG_prop(oim, vy, vx, IMG);
    end

    E = [];
    it = 0;
    IMG.alive_dead_changed = true;
    IMG.SxySyy = [];
    IMG.Sxy = [];
    IMG.Syy = [];
    converged = false;
    
    while (~converged && it<5 && true && frame_it==1)
        it = it + 1;

        oldK = IMG.K;
        IMG.SP_changed(:) = true;
        [IMG.K, IMG.label, IMG.SP, IMG.SP_changed, IMG.max_UID, IMG.alive_dead_changed, IMG.Sxy,IMG.Syy,IMG.SxySyy, newE] = split_move(IMG,1);
        E(end+1) = newE;
        converged = IMG.K - oldK < 2;

        %------------------------------------------------------------------
        if (~isempty(sp_dir))
            im = zeros(size(oim,1)+2*IMG.w, size(oim,2)+2*IMG.w, 3);
            im(IMG.w+1:end-IMG.w, IMG.w+1:end-IMG.w, :) = double(oim)/255;
            borders = is_border_valsIMPORT(double(reshape(IMG.label+1, [IMG.xdim IMG.ydim])));
            im = setPixelColors(im, find(borders), [1 0 0]);
            imwrite(im, sprintf('%s/%s.png', sp_dir, files(frame_it).name(1:end-4)));
        end
        %------------------------------------------------------------------
    end

    if (frame_it>1)
        IMG.SP_changed(:) = true;
        [IMG.K, IMG.label, IMG.SP, ~, IMG.max_UID, ~, ~, ~] = merge_move(IMG,1);
        [IMG.K, IMG.label, IMG.SP, ~, IMG.max_UID, ~, ~, ~] = split_move(IMG,10);
        [IMG.K, IMG.label, IMG.SP, ~, IMG.max_UID, ~, ~, ~] = switch_move(IMG,1);
        [IMG.K, IMG.label, IMG.SP, ~, IMG.max_UID, ~, ~, ~] = localonly_move(IMG,1000);
    end
    IMG.SP_changed(:) = true;
    IMG.alive_dead_changed = true;
    
    it = 0;
    converged = false;
    while (~converged && it<20)
        it = it + 1;
        times = zeros(1,5);

        if (~params.reestimateFlow)
            tic;[IMG.K, IMG.label, IMG.SP, SP_changed1, IMG.max_UID, IMG.alive_dead_changed, IMG.Sxy,IMG.Syy,IMG.SxySyy,newE] = localonly_move(IMG,1500);times(2)=toc;
            SP_changed0 = SP_changed1;
        else
            tic;[IMG.K, IMG.label, IMG.SP, SP_changed0, IMG.max_UID, IMG.alive_dead_changed, IMG.Sxy,IMG.Syy,IMG.SxySyy,newE] = local_move(IMG,1000);times(1)=toc;
            tic;[IMG.K, IMG.label, IMG.SP, SP_changed1, IMG.max_UID, IMG.alive_dead_changed, IMG.Sxy,IMG.Syy,IMG.SxySyy,newE] = localonly_move(IMG,500);times(2)=toc;
        end
        if (frame_it>1 && it<5)
            tic;[IMG.K, IMG.label, IMG.SP, SP_changed2, IMG.max_UID, IMG.alive_dead_changed, IMG.Sxy,IMG.Syy,IMG.SxySyy,newE] = merge_move(IMG,1);times(3)=toc;
            tic;[IMG.K, IMG.label, IMG.SP, SP_changed3, IMG.max_UID, IMG.alive_dead_changed, IMG.Sxy,IMG.Syy,IMG.SxySyy,newE] = split_move(IMG,1);times(4)=toc;
            tic;[IMG.K, IMG.label, IMG.SP, SP_changed4, IMG.max_UID, IMG.alive_dead_changed, IMG.Sxy,IMG.Syy,IMG.SxySyy,newE] = switch_move(IMG,1);times(5)=toc;
            IMG.SP_changed = SP_changed0 | SP_changed1 | SP_changed2 | SP_changed3 | SP_changed4;
        else
            IMG.SP_changed = SP_changed0 | SP_changed1;
        end

        E(end+1) = newE;
        converged = ~any(~arrayfun(@(x)(isempty(x{1})), {IMG.SP(:).N}) & IMG.SP_changed(1:IMG.K));

        %------------------------------------------------------------------
        if (~isempty(sp_dir))
            im = zeros(size(oim,1)+2*IMG.w, size(oim,2)+2*IMG.w, 3);
            im(IMG.w+1:end-IMG.w, IMG.w+1:end-IMG.w, :) = double(oim)/255;
            borders = is_border_valsIMPORT(double(reshape(IMG.label+1, [IMG.xdim IMG.ydim])));
            im = setPixelColors(im, find(borders), [1 0 0]);
            imwrite(im, sprintf('%s/%s.png', sp_dir, files(frame_it).name(1:end-4)));
        end
        %------------------------------------------------------------------
    end

    SP_UID = {IMG.SP(:).UID};
    mask = arrayfun(@(x)(isempty(x{1})), SP_UID);
    for m = find(mask)
        SP_UID{m} = -1;
    end
    sp_labels(:,:,frame_it) = reshape([SP_UID{IMG.label(IMG.w+1:end-IMG.w,IMG.w+1:end-IMG.w) +1}], size(oim,1), size(oim,2));
end



