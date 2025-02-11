function evaluateNetwork(net, imdsTest, folderDataName, netName, params)
    % EVALUATENETWORK Evaluates the trained model's performance.

    % Evaluate performance
    [YPred, probs] = classify(net, imdsTest);
    YTrue = imdsTest.Labels;
    accuracy = mean(YPred == YTrue);

    fprintf('Model accuracy: %.2f%%\n', accuracy * 100);

    % Save evaluation plots
    savePlots(folderDataName, netName, params.solverName, ...
        params.initialLearningRate, params.miniBatchSize, "validation", YTrue, YPred);
end
