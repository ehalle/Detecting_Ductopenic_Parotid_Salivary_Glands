function mltable = listImage(imdsValidation,YPred,probs)
counter = 1;
    for i = 1:size(imdsValidation.Files, 1)
        currentPrecent = 100*max(probs(i,:));
        currentModelClassification = YPred(i);
        currentRealClassification = imdsValidation.Labels(i);
        % if not(currentModelClassification == currentRealClassification)
            splitName = split(imdsValidation.Files(i), '\');
            name{counter,:} = splitName{end};
            precent(counter,:) = currentPrecent;
            prediction(counter,:) = YPred(i);
            classification(counter,:) = imdsValidation.Labels(i);
            counter = counter + 1;
        % end
    end
    mltable = table(classification, prediction, precent,'RowNames',name);
    splitName = split(name{1}, '_A');
    firstName = splitName{1};
    counter = 1;
    for i = 2:size(name,1)
        splitName = split(name{i}, '_A');
        currentName = splitName{1};
        if(strcmp(firstName,currentName))
            counter = counter + 1;
        else
            % Create the table
            disp(['Name: ', firstName])
            disp(['Number of files: ', num2str(counter)])
            disp(['Classification: ', char(mltable.classification(i-1))])
            disp(['Last prediction: ', char(mltable.prediction(i-1))])
            disp('----------------------------')
            firstName = currentName;
            counter = 1;
        end
    end
    disp(['Name: ', firstName])
    disp(['Number of files: ', num2str(counter)])
    disp(['Classification: ', char(mltable.classification(i))])
    disp(['Last prediction: ', char(mltable.prediction(i))])
