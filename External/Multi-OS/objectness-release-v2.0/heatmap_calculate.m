function [] = heatmap_calculate(img_path,target_path)

files = dir(img_path);
for i=3:length(files)
    i
    filename = files(i).name;
    [pathstr, name, ext] = fileparts(filename);
    myimage = imread([img_path '/' filename]);
    boxes = runObjectness(myimage,100000);
    %figure,imshow(myimage),drawBoxes(boxes);
    objHeatMap = computeObjectnessHeatMap(myimage,boxes);
    %outfile = strcat(filename(1:10),'_out.jpg');
    %outfile2 = strcat('person_heatmap/',outfile);
    save([target_path '/' name '.mat'],'objHeatMap');
    %imwrite(uint8(255*mat2gray(objHeatMap)),[target_path '/' name '.jpg']);
    close
end
