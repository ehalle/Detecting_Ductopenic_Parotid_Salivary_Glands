clear
clc
close all

addFoldersToPath();

[parentFolder, ~, ~] = fileparts(pwd);

mainDirectory = uigetdir(fullfile(parentFolder, 'out'));

folders = {"DataRoi", "DataSegment", "DataWithOutRoi"};

for folder = folders
    disp(fprintf('Start Deep Learning %s\n', folder{1}))
    tic
    deepLearningResnet(mainDirectory + "\" + folder{1});
    toc
end

function addFoldersToPath()
    folderNames = {'Utils', 'Models'};
    
    for i = 1:length(folderNames)
        addpath(genpath(fullfile(pwd, folderNames{i})))
    end
end
