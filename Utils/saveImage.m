function saveImage(originalImage, newImage, imageName)
    global savePlotsPath;

    if(savePlotsPath)
        if(islogical(newImage))
            newImage = int16(newImage) .* originalImage;
        end
        createMIP(newImage, [0;90;0], strcat(savePlotsPath, '\', imageName));
    end
end

