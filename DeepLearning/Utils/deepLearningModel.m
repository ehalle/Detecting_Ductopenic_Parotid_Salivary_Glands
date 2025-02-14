function deepLearningModel(folderDataName, modelType)
    % General function to train deep learning models (AlexNet, ResNet, etc.)

    % 1️⃣ Load Data
    [imdsTrain, imdsTest, imdsValidation] = loadData(folderDataName);

    % 2️⃣ Balance Dataset (Oversampling)
%     imdsTrain = balanceDataset(imdsTrain);

    % 3️⃣ Prepare the Selected Model
    [lgraph, inputSize, netName] = prepareModel(modelType, imdsTrain);

    % 4️⃣ Create Augmented Datastores
    [augimdsTrain, augimdsTest, augimdsValidation] = createAugmentedData(imdsTrain, imdsTest, imdsValidation, inputSize);

    % 5️⃣ Train and Save Network
    [net, params] = trainAndSaveNetwork(augimdsTrain, augimdsValidation, lgraph, folderDataName, netName);
    
    % 6️⃣ Evaluate Model using the trained network
    evaluateNetwork(net, augimdsTest, folderDataName, netName, params);
end
