function createMIPS(image, name, folderMipsName, type)
    global outputPath;

    angles = dataAugmentation(3);
    % angles = [0; 90; 0];
    
    dirName = fullfile(outputPath, folderMipsName);
    if(not(isfolder(dirName)))
        mkdir(dirName)
    end

    h = waitbar(0,'Please wait...');
    nameForWaitBar = strrep(name, ['' ...
        '], '');

    for i = 1:length(angles)
        angle = angles(:, i);
        mipPngPath = fullfile(dirName, sprintf('%s_A%d_%d_%d_%s.png', name, ...
            angle(1), angle(2), angle(3), type));
        createMIP(image, angle, mipPngPath);
        waitbar(i / length(angles), h, sprintf('Processing %s ... %d%%', ...
            nameForWaitBar, round(i / length(angles) * 100)));
    end

    close(h)
end

% the function takes a step size as input and generates a matrix of 3D
% angles by discretizing the X, Y, and Z dimensions within specified ranges. 
function angles = dataAugmentation(step)
    x = -9:step:9;
    y = 81:step:99;
    z = -9:step:9;
    [X, Y, Z] = meshgrid(x, y, z);
    angles = [X(:), Y(:), Z(:)]';
end
