function generateAndSaveMips(volumePath)
    global savePlotsPath;

    % Load the NIfTI volume
    volume = niftiread(volumePath);
    
    % Generate Sagittal MIP
    [xDim, yDim, zDim] = size(volume);
    
    % Initialize coronal, sagittal and axial MIP arrays
    coronalMip = zeros(xDim, zDim);
    sagittalMip = zeros(yDim, zDim);
    sagittalMipLeft = zeros(yDim, zDim);
    sagittalMipRight = zeros(yDim, zDim);
    axialMip = zeros(xDim, yDim);
    
    % Generate axial MIP
    for x = 1:xDim
        axialMip(x, :) = max(squeeze(volume(x, :, :)), [], 2);
    end

    % Generate sagittal MIP
    for y = 1:yDim
        sagittalMip(y, :) = max(squeeze(volume(:, y, :)), [], 1);
    end

    % Generate sagittal MIP from the left side
    left_slices = 1:floor(xDim / 2);  % Select slices on the left side
    for y = 1:yDim
        sagittalMipLeft(y, :) = max(squeeze(volume(left_slices, y, :)), [], 1);
    end

    % Generate sagittal MIP from the right side
   right_slices = floor(xDim / 2):xDim;  % Select slices on the right side
    for y = 1:yDim
        sagittalMipRight(y, :) = max(squeeze(volume(right_slices, y, :)), [], 1);
    end

    % Generate coronal MIP 
    for x = 1:xDim
        coronalMip(x, :) = max(squeeze(volume(x, :, :)), [], 1);
    end

    % Scale the intensity values to the range [0, 255] for image saving
    scaledAxialMip = uint8((axialMip - min(axialMip(:))) / ...
                                 (max(axialMip(:)) - min(axialMip(:))) * 255);
    
    
    % Scale the intensity values to the range [0, 255] for image saving
    scaledSagittalMip = uint8((sagittalMip - min(sagittalMip(:))) / ...
                                 (max(sagittalMip(:)) - min(sagittalMip(:))) * 255);
    
    % Scale the intensity values to the range [0, 255] for image saving
    scaledSagittalMipLeft = uint8((sagittalMipLeft - min(sagittalMipLeft(:))) / ...
                                 (max(sagittalMipLeft(:)) - min(sagittalMipLeft(:))) * 255);
    
    % Scale the intensity values to the range [0, 255] for image saving
    scaledSagittalMipRight = uint8((sagittalMipRight - min(sagittalMipRight(:))) / ...
                                 (max(sagittalMipRight(:)) - min(sagittalMipRight(:))) * 255);
    
    % Scale the intensity values to the range [0, 255] for image saving
    scaledCoronalMip = uint8((coronalMip - min(coronalMip(:))) / ...
                                 (max(coronalMip(:)) - min(coronalMip(:))) * 255);

    % Save the Sagittal and Coronal MIP as an image file
    [~, filename, ~] = fileparts(volumePath);
    saveNewImage(imadjust(scaledAxialMip), fullfile(savePlotsPath, sprintf('%s_axial_mip.png', filename)));
    saveNewImage(imadjust(scaledCoronalMip), fullfile(savePlotsPath, sprintf('%s_coronal_mip.png', filename)));
    saveNewImage(imadjust(scaledSagittalMip), fullfile(savePlotsPath, sprintf('%s_sagittal_mip.png', filename)));
    saveNewImage(imadjust(scaledSagittalMipLeft), fullfile(savePlotsPath, sprintf('%s_sagittal_mip_left.png', filename)));
    saveNewImage(imadjust(scaledSagittalMipRight), fullfile(savePlotsPath, sprintf('%s_sagittal_mip_right.png', filename)));
    saveDicomSlice(volumePath, savePlotsPath, 100);
end

function saveDicomSlice(volumePath, outputPath, desiredSlice)

    volume = niftiread(volumePath);
    
    % Extract the axial section from the volume
    axialSection = squeeze(volume(:, :, desiredSlice));
    
    % Create a figure without displaying it
    fig = figure('Visible', 'off');
    
    % Display the axial section in the figure
    imshow(axialSection, []);
    
    % Optionally, add title and labels
    title(sprintf('Axial View of DICOM Slice %d', desiredSlice))
    xlabel('X-axis');
    ylabel('Y-axis');
    
    outputPathName = fullfile(outputPath, 'my_axial_slice.png');
    
    % Save the figure as an image
    saveas(fig, outputPathName);
    
    % Close the figure
    close(fig);
    
    myLog('New File saved as %s', outputPathName);
end

