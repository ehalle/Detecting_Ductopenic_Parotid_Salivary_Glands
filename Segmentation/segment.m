function segmentation = segment(ROIImage, imageName, hessianThreshold)
    global sourceData;

    saveImage(ROIImage, ROIImage, '1_ROI.png');
    tic
    myLog('Segmenting : %s , start: %.f seconds\n', imageName, myToc);
   
    %% basic ROI -> Hessian filtered ROI
    try
        sigma1 = 1;
        sigma2 = 5;
        hessianMatFileName = fullfile(sourceData, [imageName, '_hessian_', num2str(sigma1), '_', num2str(sigma2), '_', '1' , '.mat']);
        load(hessianMatFileName, 'hessian');
    catch
        [hessian] = frangiFilterBasedHessian(ROIImage, sigma1, sigma2);
        save(hessianMatFileName, 'hessian');
    end
    
    rawHessianImage = hessian.Iout;
    saveImage(ROIImage, rawHessianImage, '2_Hessian_with_out_threshold.png');
    hessianAnalyze = analyzeHessian(rawHessianImage, hessian.scale, hessianThreshold);
    saveImage(ROIImage, hessianAnalyze, '3_Hessian_with_threshold.png');
    
    %%  Hessian filtered ROI -> final ROI
    [segmentation] = getTreeROI(ROIImage, hessianAnalyze);
        
    myLog('Segmentation end: %.f seconds\n', myToc);
end
