function [lgraph, inputSize, netName] = prepareModel(modelType, imdsTrain)
    % Load and modify the deep learning model based on the selected architecture

    switch lower(modelType)
        case 'alexnet'
            net = alexnet;
            netName = 'AlexNet';
            prebuiltLayers = net.Layers(1:end-3);
            numClasses = numel(categories(imdsTrain.Labels));
            newLayers = [
                fullyConnectedLayer(numClasses, 'Name', 'new_fc');
                softmaxLayer;
                classificationLayer
            ];
            lgraph = layerGraph([prebuiltLayers; newLayers]);

        case 'resnet101'
            net = resnet101;
            netName = 'ResNet101';
            lgraph = layerGraph(net);
            learnableLayer = 'fc1000';
            classLayer = 'ClassificationLayer_predictions';
            numClasses = numel(categories(imdsTrain.Labels));
            newLearnableLayer = fullyConnectedLayer(numClasses, ...
                'Name', 'new_fc', ...
                'WeightLearnRateFactor', 10, ...
                'BiasLearnRateFactor', 10);
            lgraph = replaceLayer(lgraph, learnableLayer, newLearnableLayer);
            newClassLayer = classificationLayer('Name', 'new_classoutput');
            lgraph = replaceLayer(lgraph, classLayer, newClassLayer);

        otherwise
            error('Unsupported model type: %s', modelType);
    end

    inputSize = net.Layers(1).InputSize(1:2);
end
