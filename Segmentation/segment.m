function segmentation = segment(ROIImage, imageName)
    tic
    myLog('Segmenting : %s , start: %.f seconds\n', imageName, myToc);

    %% Step 1: Frangi Filter
    hessianAnalyze = frangiFilter(ROIImage, imageName);
   
    %% Step 2: Dilation
    imageDilated = dilation(ROIImage, hessianAnalyze);

    %% Step 3: Best Connected Component Analysis
    segmentation = getBCC(ROIImage, imageDilated);
        
    myLog('Segmentation end: %.f seconds\n', myToc);
end
