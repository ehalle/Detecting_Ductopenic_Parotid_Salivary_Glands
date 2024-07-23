function saveNewImage(image, path)
    if exist(path, 'file')
        delete(path);
    end
    imwrite(image, path);
    % myLog("New file saved as %s", path)
end