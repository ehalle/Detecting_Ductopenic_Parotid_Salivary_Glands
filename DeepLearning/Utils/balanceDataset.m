function imdsTrain = balanceDataset(imdsTrain)
    % BALANCEDATASET Balances an image datastore by oversampling minority classes.
    % This function duplicates images in classes that have fewer samples
    % than the majority class to achieve class balance.

    % Get the number of classes in the dataset
    classCounts = countEachLabel(imdsTrain);
    numClasses = height(classCounts);
    
    % Find the maximum number of samples in any class
    maxClassCount = max(classCounts.Count);
    
    % Extract labels and file paths
    labels = imdsTrain.Labels;
    files = imdsTrain.Files;
    
    % Iterate over each class to balance the dataset
    for classIndex = 1:numClasses
        % Get the class label
        classLabel = classCounts.Label(classIndex);
        
        % Find the indices of images belonging to the current class
        indices = find(imdsTrain.Labels == classLabel);
        numSamples = numel(indices);
        
        % Calculate how many additional samples are needed
        numDuplicates = maxClassCount - numSamples;
        
        if numDuplicates > 0
            % Ensure we do not exceed the available samples when duplicating
            numDuplicates = min(numDuplicates, numSamples);
            
            % Select samples randomly for duplication
            duplicatedIndices = indices(randperm(numSamples, numDuplicates));
            
            % Duplicate file paths and labels
            duplicatedFiles = files(duplicatedIndices);
            duplicatedLabels = repmat(classLabel, numDuplicates, 1);
            
            % Append duplicated samples to the dataset
            files = [files; duplicatedFiles];
            labels = [labels; duplicatedLabels];
        end
    end
    
    % Create a new balanced imageDatastore
    imdsTrain = imageDatastore(files, 'Labels', labels);
end
