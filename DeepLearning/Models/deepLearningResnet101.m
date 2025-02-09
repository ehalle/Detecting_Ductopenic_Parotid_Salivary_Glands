function deepLearningResnet101(folderDataName)

    clearvars -except folderDataName options
    close all
    
    % Load data
    imdsTrain = imageDatastore(strcat(folderDataName,'\Train'),...
        'IncludeSubfolders', true,...
        'FileExtensions', [".jpg",".png"],...
        'LabelSource','foldernames');
    
    imdsValidation = imageDatastore(strcat(folderDataName,'\Test'),...
        'IncludeSubfolders', true,...
        'FileExtensions', [".jpg",".png"],...
        'LabelSource','foldernames');
    

    % Load the pre-trained model, ResNet-101
    net = resnet101;
    netName = 'Resnet';
    lgraph = layerGraph(net);
    inputSize = net.Layers(1).InputSize(1:2);
    
    imageAugmenter = options.imageAugmenter;
    if not(isempty(imageAugmenter))
        trainds = augmentedImageDatastore(inputSize,imdsTrain,...
            'DataAugmentation',imageAugmenter,'ColorPreprocessing','gray2rgb');
    else
        trainds = augmentedImageDatastore(inputSize,imdsTrain,'ColorPreprocessing','gray2rgb');
    end

    validationds = augmentedImageDatastore(inputSize,imdsValidation,'ColorPreprocessing','gray2rgb');

    learnableLayer='fc1000';
    classLayer='ClassificationLayer_predictions';

    % Modify the network for the current task
    numClasses = numel(categories(imdsValidation.Labels));
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
    lgraph = replaceLayer(lgraph,learnableLayer,newLearnableLayer);
    newClassLayer = classificationLayer('Name','new_classoutput');
    lgraph = replaceLayer(lgraph,classLayer,newClassLayer);
    

    % Options    
    solverName = options.solverName;
    initialLearnRate = options.initialLearnRate;
    miniBatchSize = options.miniBatchSize;

    for j=1:length(solverName)
        for i=1:length(miniBatchSize)
            for k=1:length(initialLearnRate)
            currentMiniBatchSize = miniBatchSize(i);
            currentInitialLearningRate = initialLearnRate(k);
            currentSolverName = solverName(j);
            valFrequency = max(floor(numel(validationds.Files)/currentMiniBatchSize)*10,1);
            topts = trainingOptions(currentSolverName,...
                'InitialLearnRate',currentInitialLearningRate,...
                'MaxEpochs',15,...
                'MiniBatchSize',currentMiniBatchSize,...
                'ValidationData',validationds, ...
                'ValidationFrequency',valFrequency, ...
                'Verbose',false,...
                'Plots','training-progress');

            % Train the network
            net = trainNetwork(trainds,lgraph,topts);

            savePlots(folderDataName, netName, currentSolverName,currentInitialLearningRate, ...
                currentMiniBatchSize, "validation", imdsValidation.Labels, classify(net, validationds));
            
            nameFolder = fullfile(folderDataName,'Output',netName,currentSolverName);
            paramters = sprintf('%d_%d_%d',currentInitialLearningRate,currentMiniBatchSize);
            nameMat = strcat('net_',paramters,'.mat');
            save(fullfile(nameFolder,nameMat));
            end
        end
    end
end

