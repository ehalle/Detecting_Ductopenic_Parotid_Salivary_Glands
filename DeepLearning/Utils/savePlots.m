function savePlots(folderDataName, netName, solverName, initialLearningRate, miniBatchSize, splitType, YTrue, YPred)
    % Save training and evaluation plots (confusion matrix & training progress)

    % Create output directory
    outputFolder = fullfile(folderDataName, 'Output', netName, solverName);
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end    

    % Generate confusion matrix
    cm = confusionchart(YTrue, YPred);
    cm.Title = sprintf("Salivary Glands Classification Using %s With %s", netName, capitalizeFirstLetter(solverName));

    % Define file names
    paramStr = sprintf('lr_%g_bs_%d_%s', initialLearningRate, miniBatchSize, splitType);
    confusionChartFile = fullfile(outputFolder, strcat(paramStr, '_confusionchart.png'));
    trainingPlotFile = fullfile(outputFolder, strcat(paramStr, '_trainingPlot.png'));

    try
        % Find all figures and capture the training plot figure
        figHandles = findall(0, 'Type', 'figure');
        
        % Ensure there are at least 2 figures (assuming second one is training plot)
        if numel(figHandles) >= 2
            trainingPlotFigure = figHandles(2);
            frame = getframe(trainingPlotFigure);
            imwrite(frame.cdata, trainingPlotFile);
        else
            warning('Expected figure for training plot not found.');
        end

        % Save confusion matrix figure
        saveas(cm, confusionChartFile);

        % Close figures after saving
        close all;

    catch exception
        fprintf('Error occurred: %s\n', exception.message);
        fprintf('Error ID: %s\n', exception.identifier);
    end
end

function capitalizedStr = capitalizeFirstLetter(str)
    % Capitalize the first letter of a string
    if ischar(str)
        capitalizedStr = lower(str);
        if ~isempty(capitalizedStr)
            capitalizedStr(1) = upper(capitalizedStr(1));
        end
    else
        capitalizedStr = str;
    end
end
