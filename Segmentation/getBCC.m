function bestImage = getBCC(ROIImage, thres_img)
    connectivity_type = 26;
    best_CC_index = 0;
    CC_best_score = inf;
    
    CC = bwconncomp(thres_img, connectivity_type);
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

    saveImage(ROIImage, img, '5_segmentation.png');
    bestImage = int16(img) .* ROIImage;
end