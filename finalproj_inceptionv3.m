% This script will use the inceptionV3 convolutional neural network to
% identify pleural effusion and pneumothorax from chest X-rays.

% Much of the code for setting up and training the model was adapted from the exported code from the Deep
% Network Designer, though I also had to write a lot from scratch for validation testing
% and final model testing.

% Author: Karley Baringer 
% Group Members: Lauren Ellis, Delaney Boyle, Sarah Stenberg
% Course: BME 3053C Computer Applications for BME 
% Term: Spring 2022 
% J. Crayton Pruitt Family Department of Biomedical Engineering 
% University of Florida 
% Email: kbaringer@ufl.edu 
% April 2, 2022 

clc;clear;close all

%% Network setup:

imgsdir = 'C:\Users\karle\Documents\FinalProjectImagesRGBTrain\'; % directory to training images folders

images = imageDatastore(imgsdir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames'); % import training data; use subfolder names as labels
[trainset,valset] = splitEachLabel(images,0.7, "randomize"); % split into training and validation sets

imageAugmenter = imageDataAugmenter("RandRotation",[-90 90],"RandScale",[0.5 1.5],"RandXReflection",true,"RandYReflection",true); % I read a study that showed that image augmentation improved network accuracy; these parameters are a bit arbitrary

% Resize the images to match the network input layer.
augtrainset = augmentedImageDatastore([299 299 3],trainset, "DataAugmentation", imageAugmenter);
augvalset = augmentedImageDatastore([299 299 3],valset);

% Specify training options:
opts = trainingOptions("adam","ExecutionEnvironment","auto","InitialLearnRate",0.00005,"LearnRateSchedule", "piecewise","LearnRateDropPeriod",5,"LearnRateDropFactor",0.5,"MaxEpochs", 15,"MiniBatchSize",22,"Shuffle","every-epoch","ValidationFrequency",179,"Plots","training-progress","ValidationData",augvalset, "OutputFcn", @(info)stopfunction(info,5), "OutputNetwork", "best-validation-loss");
% ^^ initial learn rate reduced because that enabled it to run; mini batch
% size reduced and validation frequency adjusted so that entire training
% set used each epoch.

% Actual network construction: The exported code does a lot of layer
% creation and connecting, but I'm going to try to be more efficient and
% just replace the layers from the pretrained network.

inceptnet = inceptionv3;

newfclayer = fullyConnectedLayer(3, 'Name', 'fullyconned_chestxray',"BiasLearnRateFactor",10,"WeightLearnRateFactor",10); % create new layers with new parameters; increasing learn rates makes the network learn faster
newclasslayer = classificationLayer("Name",'classify_chestxray');
newinputlayer = imageInputLayer([299 299 3], 'Name', 'new_input', 'Normalization', 'zscore');

inceptnetlgraph = layerGraph(inceptnet); % need to make a layer graph so we can replace the layers

inceptnetlgraph = replaceLayer(inceptnetlgraph, 'predictions', newfclayer); % replace last learnable layer 
inceptnetlgraph = replaceLayer(inceptnetlgraph, 'ClassificationLayer_predictions', newclasslayer); % replace classification layer
inceptnetlgraph = replaceLayer(inceptnetlgraph, 'input_1', newinputlayer); % replace input layer with one that will normalize using z score

%% Train network:

[trained_inceptnet, traininfo] = trainNetwork(augtrainset,inceptnetlgraph,opts);

bestlosstrainedinceptnet_415_15epoch = trained_inceptnet;
save bestlosstrainedinceptnet_414_15epoch % save workspace variables to file (named for trained network) to enable continued training (but also keep the individual trained network)



%% Stop function: a local function that will stop training of the network if the validation accuracy is not improving.
% Originally tried to use ValidationPatience in trainOptions, but that
% stops based on increases in loss, not decreases in validation accuracy.
% Therefore, it resulted in a less accurate trained network. 

% idea for stop function found here: https://www.mathworks.com/help/deeplearning/ug/customize-output-during-deep-learning-training.html
% stop function itself based on pseudocode from Dr. Shickel

function stop = stopfunction(info, N)

stop = false; % stop is false initially

% need to keep best validation accuracy and count of how many times the
% bestvalaccuracy has not been reached in a row
persistent bestValAccuracy
persistent lag

if info.State == "start" % at the start of training
    bestValAccuracy = 0;
    lag = 0;

elseif ~isempty(info.ValidationLoss) % if there is a value for validationLoss
    % compare current validation accuracy to bestvalaccuracy
    if info.ValidationAccuracy > bestValAccuracy
        bestValAccuracy = info.ValidationAccuracy;
        lag = 0;
    else
        lag = lag + 1;
    end

    if lag > N % if the network has not improved in the set number of epochs
        stop = true;
    end
end



end

