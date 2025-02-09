function folderName = createGlobals(fullPath)
    global windowCenter;
    global windowWidth;
    global niftyPath;
    global sourceData;
    global outputPath;
    global savePlotsPath;
    global pixelSpacing;
    global isRunningTest;

    fileNames = dir(fullPath);
    info = dicominfo(fullfile(fileNames(3).folder, fileNames(3).name));
    pathParts = strsplit(fullPath, '\');
    folderName = pathParts{end};
    group = pathParts{end -1};
    
    if isRunningTest
        savePlotsPath = fullfile(pwd, 'Result', char(group), folderName);
    else
        savePlotsPath = "";
    end

    windowCenter = info.WindowCenter;
    windowWidth = info.WindowWidth;
    pixelSpacing = mean(info.PixelSpacing);
    sourceData = fullfile(niftyPath, group, folderName);
    outputPath = fullfile(pwd, 'Out', 'DataTwoGroups/','Data', group, folderName);

    if isRunningTest && exist('savePlotsPath', 'var') && ~exist(savePlotsPath, 'dir') 
        % If the directory doesn't exist, create it
        mkdir(savePlotsPath);
        disp(['Directory created: ', savePlotsPath]);
    end
end