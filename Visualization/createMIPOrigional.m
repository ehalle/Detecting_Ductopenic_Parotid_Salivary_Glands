function img = createMIPOrigional(img, folderName)
    global savePlotsPath;
    
    splitFolderName = split(folderName, '_');
    side = splitFolderName{end};
    
    if savePlotsPath
        mip = convert3DTo2D(img);
        % Crooped image
        [widthImage,heightImage,depthImage] = size(img);
        angles = [0; 90; 0;];
        if strcmp(side, 'left')
            rect = [1 heightImage/2-1 1 widthImage-1 heightImage/2-1 depthImage-1];
        else
            rect = [1 1 1 widthImage-1 heightImage/2-1 depthImage-1];
        end
        img = imcrop3(img, rect);
        croppedImageRotate = rotate3D(img, angles);
        croppedImageRotate = convert3DTo2D(croppedImageRotate);
        
        % Save images
        imwrite(uint8(croppedImageRotate), fullfile(savePlotsPath, 'cropped_rotate_0_90_0.png'))
        imwrite(uint8(mip), fullfile(savePlotsPath, 'original.png'))
    end
end
