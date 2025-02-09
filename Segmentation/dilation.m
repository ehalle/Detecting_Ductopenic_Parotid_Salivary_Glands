function imageDilated = dilation(ROIImage, hessianImage)
    dilateBeforeCC = [6, 6, 2];

    logical_hessian_img = logical(hessianImage);
    imageDilated = imdilate(logical_hessian_img, getSeSphere(dilateBeforeCC));
    saveImage(ROIImage, imageDilated, '4_DilateBefore.png');
end

