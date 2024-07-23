function createMIPSWithOutROI(image, folderName)
    saveImage(image, image, '0_original.png');
    createMIPS(image, folderName, 'WithoutROI');
end