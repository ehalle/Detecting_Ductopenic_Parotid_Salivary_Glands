function [imageNii, imageROI, imageWitoutROI] = createFilesForCase(fullPath, folderName)
    global outputPath;
    global sourceData;

%     if ~exist(file_path_nii, 'file')
%         return
%     end

    filePathNii = fullfile(sourceData, [folderName, '.nii']);
    filePathROI = fullfile(sourceData, [folderName, '_raw_ROI.nii']);
    filePathWithOutROI = fullfile(sourceData, [folderName, '_raw_withOut_ROI.nii']);

    if ~exist(sourceData, "dir")
        mkdir(sourceData);
    end

    if (not(isfile(filePathNii)))
        medVol = medicalVolume(fullPath);
        write(medVol, filePathNii);
        myLog('NIFTI file saved as %s', filePathNii);
    end

    imageNii = niftiread(filePathNii);
    
    if (not(isfile(filePathROI)))
        createROIFile(imageNii, filePathROI, 'false');
    end

    imageROI = niftiread(filePathROI);

    if (not(isfile(filePathWithOutROI)))
        createROIFile(imageNii, filePathWithOutROI, 'true');
    end

    imageWitoutROI = niftiread(filePathWithOutROI);

    if ~exist(outputPath, 'dir')
        mkdir(outputPath);
    end

    generateAndSaveMips(filePathNii);
end

