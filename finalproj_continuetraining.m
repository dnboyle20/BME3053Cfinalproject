% This code will continue the training of the CNNs to see if it will
% improve accuracy

% Author: Karley Baringer 
% Group Members: Lauren Ellis, Delaney Boyle, Sarah Stenberg
% Course: BME 3053C Computer Applications for BME 
% Term: Spring 2022 
% J. Crayton Pruitt Family Department of Biomedical Engineering 
% University of Florida 
% Email: kbaringer@ufl.edu 
% April 14, 2022

%% Googlenet: 30 epochs to 45 epochs

clc;clear;close all

load('bestlosstrainedgnet_414_30epoch.mat')

opts = trainingOptions("adam","ExecutionEnvironment","auto","InitialLearnRate",0.0001,"LearnRateSchedule", "piecewise","LearnRateDropPeriod",5,"LearnRateDropFactor",0.5,"MaxEpochs",15,"MiniBatchSize",44,"Shuffle","every-epoch","ValidationFrequency",89,"Plots","training-progress","ValidationData",augvalset,"OutputNetwork","best-validation-loss", "OutputFcn", @(info)stopfunction(info,5));

bestlosslgraph = layerGraph(bestlosstrainedgnet_414_30epoch);

[trained_gnet, traininfo] = trainNetwork(augtrainset,bestlosslgraph,opts);

bestlosstrainedgnet_414_45epoch = trained_gnet;
save bestlosstrainedgnet_414_45epoch % save workspace variables to file (named for trained network) to enable continued training (but also keep the individual trained network)



%% Googlenet: 45 epochs to 60 epochs

clc;clear;close all

load('bestlosstrainedgnet_414_45epoch.mat')

opts = trainingOptions("adam","ExecutionEnvironment","auto","InitialLearnRate",0.0001,"LearnRateSchedule", "piecewise","LearnRateDropPeriod",5,"LearnRateDropFactor",0.5,"MaxEpochs",15,"MiniBatchSize",44,"Shuffle","every-epoch","ValidationFrequency",89,"Plots","training-progress","ValidationData",augvalset,"OutputNetwork","best-validation-loss", "OutputFcn", @(info)stopfunction(info,5));

bestlosslgraph = layerGraph(bestlosstrainedgnet_414_45epoch);

[trained_gnet, traininfo] = trainNetwork(augtrainset,bestlosslgraph,opts);

bestlosstrainedgnet_414_60epoch = trained_gnet;
save bestlosstrainedgnet_414_60epoch % save workspace variables to file (named for trained network) to enable continued training (but also keep the individual trained network)


%% Inceptionv3 15 to 30 epoch

clc;clear;close all

load('bestlosstrainedinceptnet_414_15epoch.mat')

opts = trainingOptions("adam","ExecutionEnvironment","auto","InitialLearnRate",0.00005,"LearnRateSchedule", "piecewise","LearnRateDropPeriod",5,"LearnRateDropFactor",0.5,"MaxEpochs", 15,"MiniBatchSize",11,"Shuffle","every-epoch","ValidationFrequency",357,"Plots","training-progress","ValidationData",augvalset, "OutputFcn", @(info)stopfunction(info,5), "OutputNetwork", "best-validation-loss");

bestlosslgraph = layerGraph(bestlosstrainedinceptnet_415_15epoch);

[trained_inceptnet, traininfo] = trainNetwork(augtrainset,bestlosslgraph,opts);

bestlosstrainedinceptnet_416_30epoch = trained_inceptnet;
save bestlosstrainedinceptnet_416_30epoch % save workspace variables to file (named for trained network) to enable continued training (but also keep the individual trained network)

%% Inceptionv3 30 t0 45 epoch

clc;clear; close all

load('bestlosstrainedinceptnet_416_30epoch.mat')

opts = trainingOptions("adam","ExecutionEnvironment","auto","InitialLearnRate",0.00005,"LearnRateSchedule", "piecewise","LearnRateDropPeriod",5,"LearnRateDropFactor",0.5,"MaxEpochs", 15,"MiniBatchSize",11,"Shuffle","every-epoch","ValidationFrequency",357,"Plots","training-progress","ValidationData",augvalset, "OutputFcn", @(info)stopfunction(info,5), "OutputNetwork", "best-validation-loss");

bestlosslgraph = layerGraph(bestlosstrainedinceptnet_416_30epoch);

[trained_inceptnet, traininfo] = trainNetwork(augtrainset,bestlosslgraph,opts);

bestlosstrainedinceptnet_416_45epoch = trained_inceptnet;
save bestlosstrainedinceptnet_416_45epoch % save workspace variables to file (named for trained network) to enable continued training (but also keep the individual trained network)



%% Stop function: a local function that will stop training of the network if the validation accuracy is not improving.
% copy/pasted from original training script

function [stop] = stopfunction(info, N)

stop = false; % stop is false initially

% need to keep best validation accuracy and count of how many times the
% bestvalaccuracy has not been reached in a row
persistent bestValAccuracy
persistent lag
% global bestaccuracy_trained_gnet

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

