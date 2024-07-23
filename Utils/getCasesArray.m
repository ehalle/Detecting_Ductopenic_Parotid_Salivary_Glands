function casesArray = getCasesArray()
    dicomPath = fullfile(pwd, "Dicom");
    dirPath = uigetdir(dicomPath);
    groups = ["Basic","Moderate", "Severe"];

    if isequal(dirPath, 0)
        disp('User canceled the operation.');
    else
        parts = strsplit(dirPath, filesep);
        lastFolder = parts{end};
        disp(['Last folder in dirPath: ' lastFolder]);

        switch true 
            case contains(lastFolder, 'Right') || contains(lastFolder, 'Left')
                casesArray = processSingleCase(dirPath);
            case ismember(lastFolder, groups)
                casesArray = processSingleGroup(dirPath);
            case lastFolder == "Dicom"
                casesArray = processMultipleGroups(dirPath, groups);
            otherwise
                disp('It doesn''t contain any of the specified last folder.');
        end
    end
end

function casesArray = processSingleCase(dirPath)
    casesArray = string(zeros(1));
    dcmFiles = dir(fullfile(dirPath, '*.dcm'));

    if ~isempty(dcmFiles) && all(~[dcmFiles.isdir])
        disp('Folder contains only DCM files.');
        casesArray(1) = convertCharsToStrings(dcmFiles(1).folder);
    else
        disp('Folder must contain only DCM files. Please select a valid folder.');
    end
end

function casesArray = processSingleGroup(dirPath)
    contents = dir(dirPath);
    folders = contents([contents.isdir]);
    validFolders = folders(~ismember({folders.name}, {'.', '..'}));
    folderNames = {validFolders.name};
    casesArray = fullfile(dirPath, folderNames);
end

function casesArray = processMultipleGroups(dirPath, groups)
    casesArray = {};
    for i = 1:numel(groups)
        currentGroup = fullfile(dirPath, groups{i});
        stringArray = processSingleGroup(currentGroup);
        casesArray = [casesArray, stringArray];
    end
end

