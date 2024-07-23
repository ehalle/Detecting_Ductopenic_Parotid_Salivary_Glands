function savePlots(folderName,net,netName,solverName,initialLearningRate,miniBatchSize,YTrue,YPred)

    % Cretae folder
    nameFolder = fullfile(folderName,'Output',netName,solverName);
    createFolder(nameFolder);
    
    % Confusion matrix
    cm = confusionchart(YTrue,YPred);
    cm.Title = strcat("Salivary Glands Classification Using ", netName, " With ", capitalFirstLetter(solverName));
%     cm.RowSummary = 'row-normalized';
%     cm.ColumnSummary = 'column-normalized';
    
    % Save data
    paramters = sprintf('%d_%d_%d',initialLearningRate,miniBatchSize);
    figures = findall(0,'Type','figure');
    trainingPlotFigure = figures(2);
    confusionChartName = strcat(paramters,'confusionchart.png');
    trainingPlotName = strcat(paramters,'trainingPlot.png');

    try 
        figFrame = getframe(trainingPlotFigure);
        figImage = figFrame.cdata;
        
        % Save the captured image as a PNG image
        imwrite(figImage, fullfile(nameFolder, trainingPlotName))

        saveas(figures(1),fullfile(nameFolder,confusionChartName));

        % Close all open windows
        delete(findall(0));
    catch e
        disp(e.identifier);
        disp(e.message);
    end
end