clear
clc
% Get the main folder
mainFolder = uigetdir('F:\Elia\salivary\Out\Data_1_5_1_0.015_segment\DeepLearningTwoGroups');

% List all subfolders inside the main folder
subfolders = dir(mainFolder);
subfolders = subfolders([subfolders.isdir]); % Keep only folders
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'})); % Remove '.' and '..'
combinedTable = table();

% Iterate through each subfolder
for i = 1:numel(subfolders)
    subfolder = fullfile(mainFolder, subfolders(i).name, 'output');
    combinedTable = vertcat(combinedTable, createExcelTrainingOptions(subfolder, 'Resnet'));
    combinedTable = vertcat(combinedTable, createExcelTrainingOptions(subfolder, 'ResnetImbalance'));

    %     createExcelTrainingOptions(subfolder, 'ResenetImbalance');
end
filePath = fullfile(mainFolder,'trainingOptions.xlsx');
writetable(combinedTable,filePath,'Sheet','MyNewSheet');