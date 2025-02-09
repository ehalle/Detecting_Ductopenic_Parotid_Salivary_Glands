function imdsTrain = balanceDatasetWithAugmentation(imdsTrain)
    % Perform oversampling using data augmentation WITHOUT saving images to disk

    classCounts = countEachLabel(imdsTrain);
    maxClassCount = max(classCounts.Count);

    % Define augmentation transformations
    augmenter = imageDataAugmenter(...
        'RandRotation', [-30, 30], ...
        'RandXReflection', true, ...
        'RandYReflection', false, ...
        'RandXTranslation', [-10 10], ...
        'RandYTranslation', [-10 10]);

    augmentedImages = {}; % Cell array for augmented images
    augmentedLabels = []; % Corresponding labels

    % Extract image size from the first image
    firstImage = imread(imdsTrain.Files{1});
    outputSize = size(firstImage, 1:2); % Ensure it's a two-element vector [height, width]

    % Generate additional images for minority classes
    for i = 1:numel(classCounts.Label)
        classLabel = classCounts.Label(i);
        classFiles = imdsTrain.Files(imdsTrain.Labels == classLabel);
        numExisting = classCounts.Count(i);
        numToAugment = maxClassCount - numExisting;

        if numToAugment > 0
            for j = 1:numToAugment
                imgIdx = randi(numExisting);  % Randomly select an image
                img = imread(classFiles{imgIdx});
                imgAug = augment(augmenter, img); % Apply augmentation
                
                % Resize to match model input size
                imgAug = imresize(imgAug, outputSize);

                % Store augmented image and label
                augmentedImages{end+1} = imgAug; %#ok<AGROW>
                augmentedLabels = [augmentedLabels; classLabel];
            end
        end
    end

    % Convert augmented images to a datastore (imageDatastore supports labels)
    imdsAugmented = imageDatastore(augmentedImages, ...
        'Labels', categorical(augmentedLabels), ...
        'ReadFcn', @(x) x); % Use direct access since images are already in memory

    % Combine the original and augmented datasets
    imdsTrain = combine(imdsTrain, imdsAugmented);
end
