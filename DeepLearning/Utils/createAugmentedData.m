function [augimdsTrain, augimdsTest, augimdsValidation] = createAugmentedData(imdsTrain, imdsTest, imdsValidation, inputSize)
    % Create augmented datastores for training and validation

    % pixelRange = [-30 30];
    % RotationRange = [-30 30];
    % scaleRange = [0.8 1.2];
    % imageAugmenter = imageDataAugmenter( ...
    %     'RandXReflection',true, ...
    %     'RandXTranslation',pixelRange, ...
    %     'RandYTranslation',pixelRange, ...
    %     'RandXScale',scaleRange, ...
    %     'RandYScale',scaleRange, ...
    %     'RandRotation',RotationRange ...
    %     );

    imageAugmenter = imageDataAugmenter('RandXReflection', true);

    if not(isempty(imageAugmenter))
        augimdsTrain = augmentedImageDatastore(inputSize(1:2), imdsTrain, ...
            'DataAugmentation', imageAugmenter, 'ColorPreprocessing', 'gray2rgb');
    else
        augimdsTrain = augmentedImageDatastore(inputSize(1:2), imdsTrain, 'ColorPreprocessing', 'gray2rgb');
    end

    augimdsValidation = augmentedImageDatastore(inputSize,imdsValidation,'ColorPreprocessing','gray2rgb');
    augimdsTest = augmentedImageDatastore(inputSize,imdsTest,'ColorPreprocessing','gray2rgb');
end
