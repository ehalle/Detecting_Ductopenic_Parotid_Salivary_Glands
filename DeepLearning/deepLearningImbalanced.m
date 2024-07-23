function deepLearningImbalanced(folderDataName, options)
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

    histogram(imdsTrain.Labels)
    labels = imdsTrain.Labels;
    [G, ~] = findgroups(labels);
    numObservations = splitapply(@numel,labels,G);

    desiredNumObservationsPerClass = max(numObservations);

    files = splitapply(@(x){randReplicateFiles(x,desiredNumObservationsPerClass)},imdsTrain.Files,G);
    files = vertcat(files{:});
    labels=[];info=strfind(files,'\');
    for i=1:numel(files)
        idx=info{i};
        dirName=files{i};
        targetStr=dirName(idx(end-1)+1:idx(end)-1);
        targetStr2=cellstr(targetStr);
        labels = [labels; categorical(targetStr2)];
    end

    imdsTrain.Files = files;
    imdsTrain.Labels=labels;
    labelCount_oversampled = countEachLabel(imdsTrain);
    histogram(imdsTrain.Labels)

    % Load the pre-trained model, ResNet-18
    net = resnet18;
    netName = 'ResnetImbalance';
    inputSize = net.Layers(1).InputSize;
    lgraph = layerGraph(net);
    learnableLayer='fc1000';
    classLayer='ClassificationLayer_predictions';

    % Modify the network for the current task
    numClasses = numel(categories(imdsTrain.Labels));
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
            'Name','new_fc', ...
            'WeightLearnRateFactor',10, ...
            'BiasLearnRateFactor',10);
    lgraph = replaceLayer(lgraph,learnableLayer,newLearnableLayer);
    newClassLayer = classificationLayer('Name','new_classoutput');
    lgraph = replaceLayer(lgraph,classLayer,newClassLayer);
   
    imageAugmenter = options.imageAugmenter;

    if not(isempty(imageAugmenter))
        augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
            'DataAugmentation',imageAugmenter,'ColorPreprocessing','gray2rgb');
    else
        augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain,'ColorPreprocessing','gray2rgb'); 
    end
    
    augimdsTest = augmentedImageDatastore(inputSize(1:2),imdsValidation,'ColorPreprocessing','gray2rgb');
    
    % Options
    solverName = options.solverName;
    initialLearningRate = options.initialLearnRate;
    miniBatchSize = options.miniBatchSize;
    
    for j=1:length(solverName)
        for i=1:length(miniBatchSize)
            for k=1:length(initialLearningRate)
            currentMiniBatchSize = miniBatchSize(i);
            currentInitialLearningRate = initialLearningRate(k);
            currentSolverName = solverName(j);
            valFrequency = max(floor(numel(augimdsTest.Files)/currentMiniBatchSize)*10,1);
            topts = trainingOptions(currentSolverName, ...
                'InitialLearnRate',currentInitialLearningRate, ...
                'MaxEpochs',30, ...
                'MiniBatchSize',currentMiniBatchSize, ...
                'ValidationData',augimdsTest, ...
                'ValidationFrequency',valFrequency, ...
                'Verbose',false, ...
                'Plots','training-progress');

            % Train the network
            net = trainNetwork(augimdsTrain,lgraph,topts);

            % Classification assessment
            [YPred,probs] = classify(net,augimdsTest);
            accuracy = mean(YPred == imdsValidation.Labels);

            YValidation = imdsValidation.Labels;
            YTrue=imdsValidation.Labels;

            savePlots(folderDataName,net,netName,currentSolverName, ...
                currentInitialLearningRate, currentMiniBatchSize,YTrue,YPred);
            
            nameFolder = fullfile(folderDataName,'Output',netName,currentSolverName);
            paramters = sprintf('%d_%d_%d',currentInitialLearningRate,currentMiniBatchSize);
            nameMat = strcat('net_',paramters,'.mat');
            save(fullfile(nameFolder,nameMat));
            end
        end
    end
end

function files = randReplicateFiles(files,numDesired)
    n = numel(files);
    ind = randi(n,numDesired,1);
    files = files(ind);
end