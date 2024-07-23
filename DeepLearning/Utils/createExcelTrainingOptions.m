function T = createExcelTrainingOptions(dirPath, netName)
    dirPath = fullfile(dirPath, netName, 'sgdm');
    splitDirPath = split(dirPath, '\');
    numberGroups = splitDirPath{end - 4};
    typeData = splitDirPath{end - 3};
    listFiles = dir(fullfile(dirPath,'*.mat'));
    nFile = length(listFiles);
    varTypes = ["string","string","string","string","string","double","double","double"];
    varNames = ["NumberGroups", "TypeData", "Name", "netName", "solverName", "InitialLearnRate","MiniBatchSize","Accuracy"];
    T = table('Size',[nFile length(varNames)],'VariableTypes',varTypes,'VariableNames',varNames);
    for k=1:nFile
        name = listFiles(k).name;
        load(fullfile(listFiles(k).folder,name), 'currentInitialLearningRate' ...
            , 'currentMiniBatchSize', 'accuracy');
        Name = name;
        solverName = 'sgdm';
        InitialLearnRate = currentInitialLearningRate;
        MiniBatchSize = currentMiniBatchSize;
        Accuracy = accuracy;
        T(k,:) = {numberGroups, typeData, Name,netName,solverName,InitialLearnRate,MiniBatchSize,Accuracy};
    end
    
%     filePath = fullfile(dirPath,'trainingOptions.xlsx');
%     writetable(T,filePath,'Sheet','MyNewSheet');
end

