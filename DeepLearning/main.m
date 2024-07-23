clear
clc
close all

addpath(genpath(fullfile(pwd,'Utils')));

pixelRange = [-30 30];
RotationRange = [-30 30];
scaleRange = [0.8 1.2];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange, ...
    'RandRotation',RotationRange ...
    ); 
options.solverName = ["sgdm"];
options.initialLearnRate = [0.0001];
options.miniBatchSize = [64];
% options.imageAugmenter = [];
options.imageAugmenter = imageDataAugmenter('RandXReflection', true);

[parentFolder, ~, ~] = fileparts(pwd);

mainDirectory= uigetdir(fullfile(parentFolder, 'out'));

disp('Start Deep Learning Resnet')
tic
deepLearningResnet(mainDirectory, options);
toc
