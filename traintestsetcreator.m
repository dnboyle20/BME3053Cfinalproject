% This script will establish training and test sets from the images. These
% training and test sets will be used on both the CNN and segmentation/thresholding sides of our
% project. It will create an 80/20 train/test split, within the 80, there
% will be a validation set.

% NOTE THAT THIS CODE DELETES FILES! CAN ONLY BE RUN ONCE.
% Code run successfully on 3/27/22; test and train sets isolated.

% Author: Karley Baringer 
% Group Members: Lauren Ellis, Delaney Boyle, Sarah Stenberg
% Course: BME 3053C Computer Applications for BME 
% Term: Spring 2022 
% J. Crayton Pruitt Family Department of Biomedical Engineering 
% University of Florida 
% Email: kbaringer@ufl.edu 
% March 26, 2022 

clc;clear;close all

path = 'C:\Users\karle\Documents\FinalProjectImagesRGBTrain\';
savepath = 'C:\Users\karle\Documents\FinalProjectImagesRGBTest\';

% Effusion Set:

effpath = strcat(path, 'Effusion\');
effsavepath = strcat(savepath, 'Effusion\');

for i = 5:5:1337 % for 1/5 (20%) of the effusion images
    file = strcat(effpath, 'img', string(i), '.jpg'); % create path to image
    img = imread(file); % import image
    imwrite(img, strcat(effsavepath, 'img', string(i), '.jpg')); % save image to test folder
    delete(file) % deletes image from training set; keeps test and train sets completely isolated
end

% No Finding Set:

nofindpath = strcat(path, 'NoFinding\');
nofindsavepath = strcat(savepath, 'NoFinding\');

for i = 5:5:2674 % for 1/5 (20%) of the no finding images
    file = strcat(nofindpath, 'img', string(i), '.jpg'); % create path to image
    img = imread(file); % import image
    imwrite(img, strcat(nofindsavepath, 'img', string(i), '.jpg')) % save image to test folder and keep original numbers from train set, helpful if we need to move things around
    delete(file) % deletes image from training set; keeps test and train sets completely isolated
end

% Pneumo Set:

pneumopath = strcat(path, 'Pneumo\');
pneumosavepath = strcat(savepath, 'Pneumo\');

for i = 5:5:1337 % for 1/5 (20%) of the pneumo images
    file = strcat(pneumopath, 'img', string(i), '.jpg');
    img = imread(file); % import image
    imwrite(img, strcat(pneumosavepath, 'img', string(i), '.jpg'));
    delete(file)
end







