function [ROIImage] = createROIFile(image, ROIFilePath, sideView)
    switch sideView
        case 'false'
            if(contains(lower(ROIFilePath), 'left'))
                ROILeft = [0.625 * size(image, 1), size(image, 1); 0.4 * size(image, 2), 0.8 * size(image, 2); 1,ceil(size(image,3)*3/4)];
                ROIImage = extractROIImage(image, ROILeft, ROIFilePath);
            end
    
            if(contains(lower(ROIFilePath), 'right'))
                ROIRight = [1, 0.375 * size(image, 1); 0.4 * size(image, 2), 0.8 * size(image, 2); 1,ceil(size(image,3)*3/4)];
                ROIImage = extractROIImage(image, ROIRight, ROIFilePath);
            end

        case 'true'
            if(contains(lower(ROIFilePath), 'right'))
                rightROI = [1, 0.5 * size(image, 1); 1, size(image, 2); 1, size(image,3)];
                ROIImage = extractROIImage(image, rightROI, ROIFilePath);
            end
            if(contains(lower(ROIFilePath), 'left'))
                leftROI = [0.5 * size(image, 1), size(image, 1); 1, size(image, 2); 1, size(image,3)];
                ROIImage = extractROIImage(image, leftROI, ROIFilePath);
            end
    end
end

function ROIImage = extractROIImage(image, ROI, ROIFileName)
    ROIImage = image(round(ROI(1,1):ROI(1,2)), round(ROI(2,1):ROI(2,2)), round(ROI(3,1):ROI(3,2)));
    niftiwrite(ROIImage, ROIFileName);
    myLog('ROI file saved as %s', ROIFileName);
end