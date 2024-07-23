function [segmentation] = getTreeROI(ROIImage, hessianImage)
    % getTreeROI - Extract a tree region of interest (ROI) from an input image.
    %
    % This function takes an input binary image 'ROIImage', a binary threshold
    % image 'ROIImageThreshold', and a Hessian-filtered image 'hessianImage'.
    % It processes these images to extract a tree region of interest (ROI) and
    % marks the non-tree regions in the 'ROIImage' with a specific value (-2000).
    %
    % Input:
    %   ROIImage - The original binary image containing the region of interest.
    %   ROIImageThreshold - The binary threshold image used for filtering.
    %   hessianImage - The Hessian-filtered image.
    %
    % Output:
    %   ROIImage - The input ROIImage with non-tree regions marked as -2000.
    %
    % Usage:
    %   ROIImage = getTreeROI(ROIImage, ROIImageThreshold, hessianImage)
    %
    % Detailed Description:
    %   - The function starts by dilating the Hessian-filtered image
    %     ('hessianImage') using a specified structuring element ('dilateBeforeCC').
    %   - It then identifies the best-connected component (CC) within the
    %     dilated image, which is assumed to represent the tree skeleton.
    %   - After finding the best CC, the function dilates the tree skeleton
    %     using another structuring element ('dilateAfterCC').
    %   - Finally, it marks the non-tree regions in the 'ROIImage' by setting
    %     their corresponding pixels to -2000 based on the binary threshold
    %     ('ROIImageThreshold') and the dilated tree skeleton.
    %
    % Note:
    %   - This function is typically used for extracting and highlighting the
    %     tree structure or skeleton within a binary image, while marking
    %     non-tree regions for further analysis or visualization.
    %
    % Author: [Your Name]
    % Date: [Date]

    dilateBeforeCC = [6, 6, 2];

    myLog('Tree ROI start: %.f seconds', myToc);
    
    possible_path_args = {'ROIImage', 'hessianImage'};
    for i = 1:length(possible_path_args)
        arg_name = possible_path_args{i};
        eval(sprintf('if isa(%1$s, ''char''), %1$s = load_img_from_nii(%1$s); end', arg_name));
    end

    logical_hessian_img = logical(hessianImage);
    filteredImgDilated = imdilate(logical_hessian_img, getSeSphere(dilateBeforeCC));
    saveImage(ROIImage, filteredImgDilated, '4_DilateBefore.png');
    bestCC = getBestCC(filteredImgDilated);
    saveImage(ROIImage, bestCC, '5_segmentation.png');
    segmentation = int16(bestCC) .* ROIImage;
    
    myLog('Tree ROI end: %.f seconds', myToc);
end