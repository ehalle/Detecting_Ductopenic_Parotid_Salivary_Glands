% This is an example for init_path.m that you should have in your project.
% It defines few "Enviroment Variables" that changes from one computer to another
function initPath()
    global niftyPath;
    global isRunningTest;

    niftyPath = fullfile(pwd, "Nifty");
    isRunningTest = false;
    folderNames = {'Externals', 'Utils', 'Visualization', 'Segmentation', 'Scripts'};
    
    for i = 1:length(folderNames)
        addpath(genpath(fullfile(pwd,folderNames{i})))
    end
end

