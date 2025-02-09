clear
clc
close all
imagePath = uigetdir('C:\elia\Detecting_Ductopenic_Parotid_Salivary_Glands\Out\DataTwoGroups\Data');

netPath = "C:\elia\Detecting_Ductopenic_Parotid_Salivary_Glands\Out\DataTwoGroups\DeepLearning\DataROI\Output\Resnet\sgdm\net_1.000000e-04_64_.mat";
load(netPath, "net");
files = dir(fullfile(imagePath, '**', '*.png'));  % Adjust '*.png' for your file extension
realClassification = 'Ductopenia';
counter = 1;

for k = 1:length(files)
    % Get the full path of the current file
    fullFilePath = fullfile(files(k).folder, files(k).name);
    label = predictLabel(net, fullFilePath);
    % if not(realClassification == label)
        name{counter,:} = files(k).name;
        classification(counter,:) = realClassification;
        prediction(counter,:) = label;
        counter = counter + 1;
    % end
end
mltable = table(classification, prediction,'RowNames',name);
writetable(mltable, 'mltable_output1.xlsx', 'WriteRowNames', true);
disp(mltable);

function label = predictLabel(net, imagePath)

    % Load the new image
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
    label = classify(net, resizedImage);
end
