function trainAndEvaluateNetwork(augimdsTrain, augimdsTest, imdsValidation, lgraph, folderDataName, netName)
    % Train and evaluate the deep learning model

    solverName = "sgdm";
    initialLearningRate = 0.0001;
    maxEpochs = 30;
    miniBatchSize = 64;

    topts = trainingOptions(solverName, ...
        'InitialLearnRate', initialLearningRate, ...
        'MaxEpochs', maxEpochs, ...
        'MiniBatchSize', miniBatchSize, ...
        'ValidationData', augimdsTest, ...
        'Verbose', false, ...
        'Plots', 'training-progress');

    % Train the model
    net = trainNetwork(augimdsTrain, lgraph, topts);

    % Evaluate performance
    [YPred, probs] = classify(net, augimdsTest);
    YTrue = imdsValidation.Labels;
    accuracy = mean(YPred == YTrue);

    % Save plots (confusion matrix & training progress)
    savePlots(folderDataName, netName, solverName, ...
        initialLearningRate, miniBatchSize, "validation", YTrue, YPred);

    % Save the trained network
    nameFolder = fullfile(folderDataName, 'Output', netName, currentSolverName);
    if ~exist(nameFolder, 'dir')
        mkdir(nameFolder);
    end
    paramStr = sprintf('%g_%d', currentInitialLearningRate, currentMiniBatchSize);
    nameMat = fullfile(nameFolder, strcat('net_', paramStr, '.mat'));
    save(nameMat, 'net');
end
