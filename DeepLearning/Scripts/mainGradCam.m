function mainGradCam()
    numberGroups = "TwoGroups";
    caseName = "‏‏24386_Left";
    stageName = "original";
    
    name = splitName(caseName);
    [img, gradCAMMap] = gradCam(numberGroups, caseName, stageName);
    subplot(2,2,1)
    imshow(img);
    title(sprintf("%s %s", name, stageName));
    subplot(2,2,2)
    visualization(img, gradCAMMap, stageName);
    
    stageName = "roi";
    name = splitName(caseName);
    [img, gradCAMMap] = gradCam(numberGroups, caseName, stageName);
    subplot(2,2,3)
    imshow(img)
    title(sprintf("%s %s", name, stageName));
    subplot(2,2,4)
    visualization(img, gradCAMMap, stageName);
end

function visualization(img, gradCAMMap, stageName) 
    % figure;
    imshow(img);
    hold on;
    imagesc(gradCAMMap, 'AlphaData', 0.5);
    colormap jet;
    colorbar;
    title(sprintf('Grad-CAM Visualization %s', stageName));
    hold off;
end

function name = splitName(name)
    name = regexprep(name, '(_[A0-9_]+$)', '');
    name = strrep(name, '_', ' '); 
end

function [img, gradCAMMap] = gradCam(numberGroups, caseName, stageName)

    load(sprintf("Nets/%s/net_1.000000e-04_64_%s.mat", numberGroups, stageName), "net");
    
    img = imread(sprintf("Examples/%s/%s_%s.png", numberGroups, caseName, stageName)); 
    % Preprocess the image
    inputSize = net.Layers(1).InputSize;
    img = imresize(img, [inputSize(1), inputSize(2)]);
    
    featureLayer = 'res5c_relu'; 
    classificationLayer = 'new_classoutput'; 
    
    % Ensure the image has the correct number of channels
    if size(img, 3) ~= inputSize(3)
        if inputSize(3) == 1
            img = rgb2gray(img);
        elseif inputSize(3) == 3
            img = cat(3, img, img, img);
        end
    end
    
    scores = activations(net, single(img), classificationLayer);
    [~, classIdx] = max(scores);
    
    classes = net.Layers(347,1).Classes;
    gradCAMMap = gradCAM(net, img, classIdx, 'FeatureLayer', featureLayer);

end