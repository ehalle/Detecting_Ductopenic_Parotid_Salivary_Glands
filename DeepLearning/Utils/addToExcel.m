function addToExcel()
    varTypes = ["string","string","string","double","double","double"];
    varNames = ["Name","netName","solverName","InitialLearnRate","MiniBatchSize","Accuracy"];
    T = table('Size',[5 length(varNames)],'VariableTypes',varTypes,'VariableNames',varNames);
    Name = name;
    InitialLearnRate = initialLearningRate;
    MiniBatchSize = miniBatchSize;
    Accuracy = nnz(YPred == YTrue)/numel(YPred);
    T(1,:) = {Name,netName,solverName,InitialLearnRate,MiniBatchSize,Accuracy};

    filePath = fullfile(dirPath,'trainingOptions.xlsx');
    writetable(T,filePath,'Sheet','MyNewSheet');
end