function mltable = listImage(imdsValidation,YPred,probs)
counter = 0;
    for i = 1:size(imdsValidation.Files, 1)
        currentPrecent = 100*max(probs(i,:));
        currentModelClassification = YPred(i);
        currentRealClassification = imdsValidation.Labels(i);
        if not(currentModelClassification == currentRealClassification)
            counter = counter + 1;
            splitName = split(imdsValidation.Files(i), '\');
            name{counter,:} = splitName{end};
            precent(counter,:) = currentPrecent;
            modelClassification(counter,:) = YPred(i);
            realClassification(counter,:) = imdsValidation.Labels(i);
        end
    end
    mltable = table(realClassification, modelClassification, precent,'RowNames',name);
    splitName = split(name{1}, '_A');
    firstName = splitName{1};
    counter = 1;
    for i = 2:size(name,1)
        splitName = split(name{i}, '_A');
        currentName = splitName{1};
        if(strcmp(firstName,currentName))
            counter = counter + 1;
        else
            disp(firstName)
            disp(counter)
            disp(mltable.modelClassification(i-1))
            disp(mltable.realClassification(i-1))
            firstName = currentName;
            counter = 1;
        end
    end
    disp(firstName)
    disp(counter)
    disp(mltable.modelClassification(i))
    disp(mltable.realClassification(i))
end