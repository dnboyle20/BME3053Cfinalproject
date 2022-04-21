% I have made a mistake. All the images are grayscale but they need to be
% rgb for the CNNs to take them as input. This script will fix that. It
% will also change them all to .jpgs because I read somewhere that that
% would help with an error I'm having

% this code will also rescale/normalize the images so that they are between 0 and 1
% instead of between 0 and 255

% Author: Karley Baringer 
% Group Members: Lauren Ellis, Delaney Boyle, Sarah Stenberg
% Course: BME 3053C Computer Applications for BME 
% Term: Spring 2022 
% J. Crayton Pruitt Family Department of Biomedical Engineering 
% University of Florida 
% Email: kbaringer@ufl.edu 
% March 26, 2022 

clc;clear;close all

path = 'C:\Users\karle\Documents\FinalProjectImages\'; % path to main folder containing grayscale images
outpath = 'C:\Users\karle\Documents\FinalProjectImagesRGBTrain\'; % path to output folder

% Effusion images:
effpath = strcat(path, 'Effusion\');
effoutpath = strcat(outpath, 'Effusion\');

for i = 1:1671 % for each image in Effusion folder
    img = imread(strcat(effpath, 'img', string(i), '.png')); %read each image
    img2 = img(:,:,[1 1 1]); % make into 3 channel
    img2 = rescale(img2); % rescale image to be between 0 and 1 instead of 0 and 255
    imwrite(img2, fullfile(effoutpath, strcat('img', string(i), '.jpg'))); % save each image
end


% No Finding images:
nofindpath = strcat(path, 'NoFinding\');
nofindoutpath = strcat(outpath, 'NoFinding\');

for i = 1:3342 % for each no finding image
    img = imread(strcat(nofindpath, 'img', string(i), '.png')); %read each image
    img2 = img(:,:,[1 1 1]); % make into 3 channel
    img2 = rescale(img2); % rescale image to be between 0 and 1 instead of 0 and 255
    imwrite(img2, fullfile(nofindoutpath, strcat('img', string(i), '.jpg'))); % save each image
end

% Pneumo images:
pneumopath = strcat(path, 'Pneumo\');
pneumooutpath = strcat(outpath, 'Pneumo\');

for i = 1:1671 % for every pneumo image
    img = imread(strcat(pneumopath, 'img', string(i), '.png')); %read each image
    img2 = img(:,:,[1 1 1]); % make into 3 channel
    img2 = rescale(img2); % rescale image to be between 0 and 1 instead of 0 and 255
    imwrite(img2, fullfile(pneumooutpath, strcat('img', string(i), '.jpg'))); % save each image
end






