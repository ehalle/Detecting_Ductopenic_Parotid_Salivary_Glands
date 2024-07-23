function [img] = getBestCC(thres_img)
    % getBestCC - Find the best-connected component in a binary thresholded image.
    %
    % This function takes a binary thresholded image and identifies the
    % best-connected component (CC) within it. The best CC is determined based
    % on criteria such as solidity and size. The purpose is to extract a
    % specific region of interest from the input binary image.
    %
    % Input:
    %   thres_img - The binary thresholded image.
    %
    % Output:
    %   img - A binary image containing only the best CC.
    %
    % Usage:
    %   img = getBestCC(thres_img)
    %
    % Detailed Description:
    %   - The function first identifies connected components in the binary
    %     thresholded image using 26-connectivity.
    %   - It evaluates each CC based on criteria including solidity and size.
    %   - The best CC is selected based on these criteria.
    %   - The selected CC is converted into a binary image, and only the pixels
    %     belonging to the best CC are set to 'true' in the output image.
    %
    % Author: [Your Name]
    % Date: [Date]

    connectivity_type = 26;
    CC = bwconncomp(thres_img, connectivity_type);
    best_CC_index = 0;
    CC_best_score = inf;
    properties = regionprops3(CC,'Solidity');
    min_y_axis = scaledParam(113);
    
    i = 1;
    while i < CC.NumObjects + 1
        [~, yElements, ~] = ind2sub(CC.ImageSize, CC.PixelIdxList{i});
        y_diff = max(yElements) - min(yElements);
        CC_length = length(CC.PixelIdxList{i});

        if y_diff < min_y_axis && not(min_y_axis == scaledParam(30))
            if best_CC_index == 0 && i == CC.NumObjects
                min_y_axis = scaledParam(30);
                i = 0;
            end
            i = i + 1;
            continue;
        end
        
        if CC_length < scaledParam(10)*scaledParam(10)*scaledParam(3)
            i = i + 1;
            continue;
        end
        
        currentSolidity = properties.Solidity(i);
        CC_score = currentSolidity;
        if CC_score < CC_best_score
            CC_best_score = CC_score;
            best_CC_index = i;
        end
        i = i + 1;
    end

    if best_CC_index == 0
        error('Could not find best CC...')
    end
    
    best_CC = CC.PixelIdxList{best_CC_index};
    img = false(size(thres_img));
    img(best_CC) = true;
end