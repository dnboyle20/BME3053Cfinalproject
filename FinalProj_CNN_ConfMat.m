% Confusion Matrices for CNN Models

% Final Project 
% Sarah Stenberg
% Group Members: Delaney Boyle, Karley Baringer, Lauren Ellis
% BME 3053C
% April 20, 2022

clc; clear;


load('cnn_results_final.mat');

subplot(6,1,1);
C_g30 = confusionchart(testimgs.Labels,Pred_g30);
title("GoogleNet - 30 Epochs");

subplot(6,1,2);
C_g45 = confusionchart(testimgs.Labels,Pred_g45);
title("GoogleNet - 45 Epochs");

subplot(6,1,3);
C_g60 = confusionchart(testimgs.Labels,Pred_g60);
title("GoogleNet - 60 Epochs");

subplot(6,1,4);
C_i15 = confusionchart(testimgs.Labels,Pred_i15);
title("Inceptionv3 - 15 Epochs");

subplot(6,1,5);
C_i30 = confusionchart(testimgs.Labels,Pred_i30);
title("Inceptionv3 - 30 Epochs");

subplot(6,1,6);
C_i45 = confusionchart(testimgs.Labels,Pred_g45);
title("Inceptionv3 - 45 Epochs");



