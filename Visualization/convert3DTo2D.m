function mip = convert3DTo2D(img)
    % create a 2D mip image of the 3D input image, after rotation by the input
    % parameters
    global windowCenter;
    global windowWidth;

    imageMaxValue = 220;
    [mip, ~] = max(img,[],3);
    mip = double(mip);
    maxMip = windowCenter + windowWidth / 2;
    minMip = windowCenter - windowWidth / 2;
    mip = (mip-minMip)*imageMaxValue/(maxMip-minMip);
end