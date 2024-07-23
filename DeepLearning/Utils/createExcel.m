clear
dirPath = uigetdir('F:\Elia\salivary\Out\Data_1_5_1_0.015_segment\DeepLearningDataSegment\Output'); 
split = split(dirPath, '\');
[netName, solverName] = split{end-1:end};
listFiles = dir(fullfile(dirPath,'*.mat'));
nFile = length(listFiles);
varTypes = ["string","string","string","double","double","double"];
varNames = ["Name","netName","solverName","InitialLearnRate","MiniBatchSize","Accuracy"];
T = table('Size',[nFile length(varNames)],'VariableTypes',varTypes,'VariableNames',varNames);
for k=1:nFile
    name = listFiles(k).name;
    load(fullfile(listFiles(k).folder,name), 'currentSolverName', 'currentInitialLearningRate' ...
        , 'currentMiniBatchSize', 'accuracy', 'netName');
    Name = name;
    solverName = currentSolverName;
    InitialLearnRate = currentInitialLearningRate;
    MiniBatchSize = currentMiniBatchSize;
    Accuracy = accuracy;
    T(k,:) = {Name,netName,solverName,InitialLearnRate,MiniBatchSize,Accuracy};
end

filePath = fullfile(dirPath,'trainingOptions.xlsx');
writetable(T,filePath,'Sheet','MyNewSheet');