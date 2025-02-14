function [net, params] = trainAndSaveNetwork(augimdsTrain, augimdsValidation, lgraph, folderDataName, netName)
    % TRAINANDSAVENETWORK Trains the deep learning model and saves it.
    % Returns the trained network and the training options used.

    % Define hyperparameters in a struct (single source of truth)
    params.solverName = "sgdm";
    params.initialLearningRate = 0.0001;
    params.maxEpochs = 15;
    params.miniBatchSize = 64;

    % Define training options
    topts = trainingOptions(params.solverName, ...
        'InitialLearnRate', params.initialLearningRate, ...
        'MaxEpochs', params.maxEpochs, ...
        'MiniBatchSize', params.miniBatchSize, ...
        'ValidationData', augimdsValidation, ...
        'Verbose', false, ...
        'Plots', 'training-progress');

    % Train the model
    net = trainNetwork(augimdsTrain, lgraph, topts);

    % Save the trained network
    nameFolder = fullfile(folderDataName, 'Output', netName, params.solverName);
    if ~exist(nameFolder, 'dir')
        mkdir(nameFolder);
    end
    paramStr = sprintf('%g_%d', params.initialLearningRate, params.miniBatchSize);
    nameMat = fullfile(nameFolder, strcat('net_', paramStr, '.mat'));
    save(nameMat, 'net');

    fprintf('Model training completed and saved in: %s\n', nameMat);
end

