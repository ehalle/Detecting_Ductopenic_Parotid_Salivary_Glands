clear
close all
clc

% function category = predictNewCase(folderName, imageToPredict)
netPath = "C:\elia\Detecting_Ductopenic_Parotid_Salivary_Glands\Out\DataTwoGroups\DeepLearning\DataROI\Output\Resnet\sgdm\net_1.000000e-04_64_.mat";
load(netPath, "net");
% Load the new image
caseName = '‏‏48_Right';
group = 'Ductopenia';
imagePath = sprintf('C:\\elia\\Detecting_Ductopenic_Parotid_Salivary_Glands\\Out\\DataTwoGroups\\Data\\%s\\%s\\DataROI\\%s_A0_90_0_ROI.png', group, caseName, caseName);
newImage = imread(imagePath);

% Preprocess the image
inputSize = net.Layers(1).InputSize;
resizedImage = imresize(newImage, [inputSize(1), inputSize(2)]);

% Ensure the image has the correct number of channels
if size(resizedImage, 3) ~= inputSize(3)
    if inputSize(3) == 1
        resizedImage = rgb2gray(resizedImage);
    elseif inputSize(3) == 3
        resizedImage = cat(3, resizedImage, resizedImage, resizedImage);
    end
end

% Predict using the trained network
predictedLabel = classify(net, resizedImage);

% Display the image with the prediction
figure;
imshow(newImage);
predictLabelChar = char(predictedLabel);

if predictLabelChar == "Basic"
    predictLabelChar = 'Normal';
end

title(['Case: ', caseName, ' Predicted Label: ', char(predictLabelChar)]);     
% end
