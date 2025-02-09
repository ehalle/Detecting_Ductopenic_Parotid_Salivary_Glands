clear
close all
clc

folderDataName = "C:\elia\Detecting_Ductopenic_Parotid_Salivary_Glands\Out\DataTwoGroups\DeepLearning2\DataWithOutROI";
netPath =  folderDataName + "\Output\Resnet\sgdm\net_1.000000e-04_64_.mat";
excelPath = folderDataName + "\Output\Resnet\sgdm";
load(netPath);

inputSize = net.Layers(1).InputSize(1:2);

imdsValidation = imageDatastore(strcat(folderDataName,'\Validation'),...
    'IncludeSubfolders', true,...
    'FileExtensions', [".jpg",".png"],...
    'LabelSource','foldernames');
validationds = augmentedImageDatastore(inputSize,imdsValidation,'ColorPreprocessing','gray2rgb');

imdsTest = imageDatastore(strcat(folderDataName,'\Test'),...
    'IncludeSubfolders', true,...
    'FileExtensions', [".jpg",".png"],...
    'LabelSource','foldernames');
testds = augmentedImageDatastore(inputSize,imdsTest,'ColorPreprocessing','gray2rgb');

YPredValidation = classify(net, validationds);
savePlots(folderDataName, netName, currentSolverName, currentInitialLearningRate, ...
                currentMiniBatchSize, "validation1", imdsValidation.Labels, YPredValidation);
createExcel(excelPath, imdsValidation, YPredValidation, "validation");

YPredTest = classify(net, testds);
savePlots(folderDataName, netName, currentSolverName, currentInitialLearningRate, ...
                currentMiniBatchSize, "test", imdsTest.Labels, YPredTest);
createExcel(excelPath, imdsTest, YPredTest, "test");



function mltable = createExcel(excelPath, imdsValidation, YPred, splitType)
    counter = 0;
    position = 1;
    numberOfFiles = size(imdsValidation.Files, 1);
    for i = 1:numberOfFiles - 1            
        currentModelClassification = YPred(i);
        currentRealClassification = imdsValidation.Labels(i);
        currentName = getCaseName(imdsValidation.Files(i));
        nextName = getCaseName(imdsValidation.Files(i + 1));
        if strcmp(currentName, nextName) && not(i == numberOfFiles - 1)
            if(not(currentModelClassification == currentRealClassification))
                counter = counter + 1;
            end
        else
            numberOfMistake(position - 1, :) = counter;
            counter = 0;
        end
        if contains(imdsValidation.Files(i), "0_90_0") 
            name{position,:} = currentName;
            prediction(position,:) = YPred(i);
            classification(position,:) = imdsValidation.Labels(i);
            position = position + 1;
        end
    end
    mltable = table(classification, prediction, numberOfMistake, 'RowNames',name);
    write(mltable, strcat(excelPath, "\", splitType, ".xlsx"), 'WriteRowNames', true);
end

function name = getCaseName(fullName)
    name = split(fullName, '\');
    name = name{end};
    name = split(name, '_A');
    name = name{1};
end