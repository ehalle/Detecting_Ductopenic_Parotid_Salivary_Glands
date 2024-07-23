function deepLearningAlexnet(folderDataName, options)
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
    
    net = alexnet;
    netName = 'Alexnet';
    prebuiltLayers = net.Layers(1:end-3);
    layers = [prebuiltLayers;fullyConnectedLayer(3);softmaxLayer;classificationLayer];
    
        
    inputSize = net.Layers(1).InputSize(1:2);
    imageAugmenter = options.imageAugmenter;
    if not(isempty(imageAugmenter))
        trainds = augmentedImageDatastore(inputSize,imdsTrain,...
            'DataAugmentation',imageAugmenter,'ColorPreprocessing','gray2rgb');
    else
        trainds = augmentedImageDatastore(inputSize,imdsTrain,'ColorPreprocessing','gray2rgb');
        
    end

    testds = augmentedImageDatastore(inputSize,imdsValidation,'ColorPreprocessing','gray2rgb');


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
            valFrequency = max(floor(numel(testds.Files)/currentMiniBatchSize)*10,1);
            topts = trainingOptions(currentSolverName,...
                'InitialLearnRate',currentInitialLearningRate,...
                'MaxEpochs',30,...
                'MiniBatchSize',currentMiniBatchSize,...
                'ValidationData',testds, ...
                'ValidationFrequency',valFrequency, ...
                'Verbose',false,...
                'Plots','training-progress');

            [net,info] = trainNetwork(trainds,layers,topts);

            [YPred,probs] = classify(net,testds);
            YTrue = imdsValidation.Labels;
            accuracy = nnz(YPred == YTrue)/numel(YPred);

            % savePlots confision matrix and training progress        
            savePlots(folderDataName,net,netName,currentSolverName,...
                currentInitialLearningRate,currentMiniBatchSize,YTrue,YPred);
            
            nameFolder = fullfile(folderDataName,'Output',netName,currentSolverName);
            paramters = sprintf('%d_%d_%d',currentInitialLearningRate,currentMiniBatchSize);
            nameMat = strcat('net_',paramters,'.mat');
            save(fullfile(nameFolder,nameMat));
            end
        end
    end
end

