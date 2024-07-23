function folderName = createGlobals(fullPath)
    global windowCenter;
    global windowWidth;
    global niftyPath;
    global sourceData;
    global outputPath;
    global savePlotsPath;
    global pixelSpacing;

    fileNames = dir(fullPath);
    info = dicominfo(fullfile(fileNames(3).folder, fileNames(3).name));
    pathParts = strsplit(fullPath, '\');
    folderName = pathParts{end};
    group = pathParts{end -1};
    
    savePlotsPath = fullfile(pwd, 'Result', char(group), folderName);
    windowCenter = info.WindowCenter;
    windowWidth = info.WindowWidth;
    pixelSpacing = mean(info.PixelSpacing);
    sourceData = fullfile(niftyPath, group, folderName);
    outputPath = fullfile(pwd, 'Out', 'DataAll/','Data', group, folderName);

    if exist('savePlotsPath', 'var') && ~exist(savePlotsPath, 'dir') 
        % If the directory doesn't exist, create it
        mkdir(savePlotsPath);
        disp(['Directory created: ', savePlotsPath]);
    end
end