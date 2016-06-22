close all;

imgExample = imread('002053.jpg');
boxes = runObjectness(imgExample,100000);
figure,imshow(imgExample),drawBoxes(boxes);

[objHeatMap, gray] = computeObjectnessHeatMap(imgExample,boxes);
figure,imshow(gray);