function displayImage(imdsValidation,YPred,probs)
    % Display simple
    idx = randperm(numel(imdsValidation.Files),4);
    figure
    for i = 1:4
        subplot(2,2,i)
        [I,INFO] = readimage(imdsValidation,idx(i));
        imshow(I)
        label = YPred(idx(i));
        matchStr = regexp(INFO.Filename, 'I(\d)*_([a-zA-Z])*', 'match');
        name = matchStr{1};
        name = replace(name, "_", "\_");
        title(name + ", " + string(label) + ", " + num2str(100*max(probs(idx(i),:)),3) + "%");
    end
end