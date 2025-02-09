% create a 2D mip image of the 3D input image, after rotation by the input
% parameters
function mip = createMIP(img, angles, pngPath)
    img = rotate3D(img, angles);
    mip = convert3DTo2D(img);
    saveNewImage(uint8(mip), pngPath)
end