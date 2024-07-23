clear
clc
close all
% [file,path] = uigetfile('*.mat');
% fullPathName = append(path, file);
% load(fullPathName);
% load("F:\Elia\Code\Out\DataAll0.01_3_7_7\DeepLearningDataSegment\Output\resnet\adam\net_1.000000e-04_64_.mat",...
%     "imdsValidation", "YPred", "probs")
folderName = "F:\Elia\NewCode\Out\Data0.015\DeepLearningDataSegment\Output\resnet\adam\net_1.000000e-04_64_.mat";
load(folderName, "imdsValidation", "YPred", "probs")

mltable = listImage(imdsValidation, YPred, probs);
