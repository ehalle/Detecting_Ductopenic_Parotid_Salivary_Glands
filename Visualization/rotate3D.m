function img = rotate3D(img, angles)
    method = 'bilinear';
    use_gpu = canUseGPU();
    
    if length(angles) ~= 3, error('angles length must be 3 (one for each dimension'); end
    
    orig_img = img;
    if use_gpu
        if isa(orig_img, 'double'), img = single(img);end
        if isa(orig_img, 'int16')
            img_min = min(img(:));
            img = img - img_min;
            img = uint16(img);
        end
    end
    
    % padding for rotation
    maxSize = max([size(img,1), size(img,2), size(img,3)]);
    padSizeX = round((maxSize-size(img,1))/2);
    padSizeY = round((maxSize-size(img,2))/2);
    padSizeZ = round((maxSize-size(img,3))/2);
    pad_val = min(img(:));
    
    img = padarray(img, [padSizeX,padSizeY,padSizeZ], pad_val);
    gImg = img;
    
    if use_gpu
        gImg = gpuArray(gImg);
    end
    
    for dim=1:3
        gImg = rotateCT(gImg, angles(dim), dim, method);
    end
    
    if use_gpu
        gImg = gather(gImg);
    end
    img = gImg;
    
    if use_gpu
        if isa(orig_img, 'int16')
            img = int16(img);
            img = img + img_min;
        end
    end
end