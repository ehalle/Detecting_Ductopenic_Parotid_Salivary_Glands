clc
clear
close all
load("F:\Elia\Code\Out\DataAll0.01_3_7_7\DeepLearningData\Output\resnet\adam\net_1.000000e-04_64_.mat", "YValidation", "imdsValidation", "YPred")
categories = unique(YValidation);
accuracy = 0;
specificity = 0;
sensitivity = 0;
for i = 1: size(categories,1)
    currentCategory = categories(i);
    TP = sum(imdsValidation.Labels == currentCategory & YPred == currentCategory);
    FP = sum(imdsValidation.Labels ~= currentCategory & YPred == currentCategory);
    TN = sum(imdsValidation.Labels == currentCategory & YPred ~= currentCategory);
    FN = sum(imdsValidation.Labels == currentCategory & YPred ~= currentCategory);
    accuracy = accuracy + (TP + TN) / (TP + TN + FP + FN);
    specificity = specificity + TN / (TN + FP);
    sensitivity = sensitivity + TP / (TP + FN);
end

accuracy = accuracy / 3;
specificity = specificity / 3;
sensitivity = sensitivity / 3;
table(accuracy, specificity, sensitivity)