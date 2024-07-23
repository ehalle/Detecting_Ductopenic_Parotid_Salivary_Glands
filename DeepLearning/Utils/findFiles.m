clear
clc

[file,path] = uigetfile('F:\Elia\Thesis\deep-learning\*.mat');
matNetPath = fullfile(path,file);
load(matNetPath,'imdsValidation','probs','YPred');
splitFilesName = split(imdsValidation.Files, '\');
size = size(splitFilesName);
Names = splitFilesName(:,size(2));
BasicProbs = probs(:,1);
ModerateProbs = probs(:,2);
SevereProbs = probs(:,3);
TrueClass = imdsValidation.Labels;
PredictedClass = YPred;
table1 = table(Names,TrueClass,PredictedClass,BasicProbs,ModerateProbs,SevereProbs);
rows = imdsValidation.Labels ~= YPred;
Tbl2 = table1(rows,:);

filePath = fullfile(path,'validationData.xlsx');
writetable(Tbl2,filePath,'Sheet','MyNewSheet');