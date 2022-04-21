% This code will load all the trained CNNs and test them using the test
% set.

% Author: Karley Baringer 
% Group Members: Lauren Ellis, Delaney Boyle, Sarah Stenberg
% Course: BME 3053C Computer Applications for BME 
% Term: Spring 2022 
% J. Crayton Pruitt Family Department of Biomedical Engineering 
% University of Florida 
% Email: kbaringer@ufl.edu 
% April 2, 2022 

clc;clear;close all

%% GoogleNet

testdir = "C:\Users\karle\Documents\FinalProjectImagesRGBTest\";
testimgs = imageDatastore(testdir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

resizetestimgs = augmentedImageDatastore([224 224 3],testimgs);

load('bestlosstrainedgnet_414_30epoch.mat');

[Pred_g30] = classify(bestlosstrainedgnet_414_30epoch,resizetestimgs);
accuracy_g30 = mean(Pred_g30 == testimgs.Labels);

load('bestlosstrainedgnet_414_45epoch.mat');

[Pred_g45] = classify(bestlosstrainedgnet_414_45epoch,resizetestimgs);
accuracy_g45 = mean(Pred_g45 == testimgs.Labels);

load('bestlosstrainedgnet_414_60epoch.mat');

[Pred_g60] = classify(bestlosstrainedgnet_414_60epoch,resizetestimgs);
accuracy_g60 = mean(Pred_g60 == testimgs.Labels);




%% Inceptionv3

inceptresizetestimgs = augmentedImageDatastore([299 299 3],testimgs);

load('bestlosstrainedinceptnet_414_15epoch.mat');

[Pred_i15] = classify(bestlosstrainedinceptnet_415_15epoch,inceptresizetestimgs);
accuracy_i15 = mean(Pred_i15 == testimgs.Labels);

load('bestlosstrainedinceptnet_416_30epoch.mat');

[Pred_i30] = classify(bestlosstrainedinceptnet_416_30epoch,inceptresizetestimgs);
accuracy_i30 = mean(Pred_i30 == testimgs.Labels);

load('bestlosstrainedinceptnet_416_45epoch.mat');

[Pred_i45] = classify(bestlosstrainedinceptnet_416_45epoch,inceptresizetestimgs);
accuracy_i45 = mean(Pred_i45 == testimgs.Labels);


