clc;
clear;
close all;

% caseName = 'Normal_I0000003441_Right_A0_90_0';
% caseName = 'Moderate_‏‏I0000008814_Right_A0_90_0';
caseName = '‏‏Severe_I0000030010_Left_A0_90_0';

stageName = 'segment';

load(sprintf("Nets/net_1.000000e-04_64_%s.mat", stageName), "net");

% img = imread(sprintf('%s_%s.png', caseName, stageName)); 

img = imread("Examples/Severe_I0000030010_Left_A0_90_0_original.png"); 

% Preprocess the image
inputSize = net.Layers(1).InputSize;
img = imresize(img, [inputSize(1), inputSize(2)]);

featureLayer = 'res5c_relu'; 
classificationLayer = 'new_classoutput'; 

% Ensure the image has the correct number of channels
if size(img, 3) ~= inputSize(3)
    if inputSize(3) == 1
        img = rgb2gray(img);
    elseif inputSize(3) == 3
        img = cat(3, img, img, img);
    end
end

scores = activations(net, single(img), classificationLayer);
[~, classIdx] = max(scores);

classes = net.Layers(347,1).Classes;
gradCAMMap = gradCAM(net, img, classIdx, 'FeatureLayer', featureLayer);

figure;
imshow(img);
hold on;
imagesc(gradCAMMap, 'AlphaData', 0.5);
colormap jet;
colorbar;
title('Grad-CAM Visualization');
hold off;