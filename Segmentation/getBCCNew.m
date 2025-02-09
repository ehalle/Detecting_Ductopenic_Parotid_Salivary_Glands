function bestImage = getBCCNew(ROIImage, thres_img)
    connectivity_type = 26;
    
    % Precompute constant values
    min_y_axis = scaledParam(113);
    small_size_thresh = scaledParam(10) * scaledParam(10) * scaledParam(3);
    
    % Compute connected components
    CC = bwconncomp(thres_img, connectivity_type);
    if CC.NumObjects == 0
        error('No connected components found.');
    end
    
    % Get list of all connected components
    allCCs = CC.PixelIdxList;
    
    % Compute the Y-axis range for each connected component
    yElements = cellfun(@(idx) ind2sub(CC.ImageSize, idx), allCCs, 'UniformOutput', false);
    yDiffs = cellfun(@(y) max(y) - min(y), yElements);
    
    % Filter components based on height constraint
    validIndices = yDiffs >= min_y_axis;
    
    % If no components satisfy the height constraint, lower the threshold
    if ~any(validIndices)
        min_y_axis = scaledParam(30);
        validIndices = yDiffs >= min_y_axis;
    end
    
    % Further filter components based on size constraint
    CC_sizes = cellfun(@numel, allCCs);
    validIndices = validIndices & (CC_sizes >= small_size_thresh);
    
    % If no valid components remain, throw an error
    validCCs = find(validIndices);
    if isempty(validCCs)
        error('Could not find best connected component...');
    end
    
    % Create a new bwconncomp structure that only contains valid connected components
    filteredCC = struct('Connectivity', CC.Connectivity, ...
                        'ImageSize', CC.ImageSize, ...
                        'NumObjects', numel(validCCs), ...
                        'PixelIdxList', {allCCs(validCCs)});
    
    % Compute Solidity only for the filtered components
    properties = regionprops3(filteredCC, 'Solidity');
    
    % Select the component with the lowest Solidity value
    [~, bestIdx] = min(properties.Solidity);
    best_CC_index = validCCs(bestIdx);
    
    % Create a binary image with the best connected component
    img = false(size(thres_img));
    img(allCCs{best_CC_index}) = true;
    
    % Save the segmentation result
    saveImage(ROIImage, img, '5_segmentation.png');
    
    % Apply the mask to the ROI image
    bestImage = int16(img) .* ROIImage;
end
