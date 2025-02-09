function deepLearningModel(folderDataName, modelType)
    % General function to train deep learning models (AlexNet, ResNet, etc.)

    % 1️⃣ Load Data
    [imdsTrain, imdsValidation] = loadData(folderDataName);

    % 2️⃣ Balance Dataset (Oversampling using Data Augmentation)
    % imdsTrain = balanceDatasetWithAugmentation(imdsTrain);

    % 3️⃣ Prepare the Selected Model
    [lgraph, inputSize, netName] = prepareModel(modelType, imdsTrain);

    % 4️⃣ Create Augmented Datastores
    [augimdsTrain, augimdsTest] = createAugmentedData(imdsTrain, imdsValidation, inputSize);

    % 5️⃣ Train and Evaluate Model
    trainAndEvaluateNetwork(augimdsTrain, augimdsTest, imdsValidation, lgraph, folderDataName, netName);
end
