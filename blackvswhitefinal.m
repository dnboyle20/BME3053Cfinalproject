% BME 3053C Final Project
% Author: Lauren Ellis
% Course: BME 3053C Computer Applications for BME 
% Group Members: Sarah Stenber, Karley Baringer, and Delaney Boyle
% Term: Spring 2022 
% J. Crayton Pruitt Family Department of Biomedical Engineering 
% University of Florida 
% Email: lauren.ellis@ufl.edu 
% April 18, 2022

%identify white and black area in a normal lung and identify if it's normal
%proportions or not

clc;
clear;

%find the two different lungs (see other function)
%import images
I=imread('img10.png');

%create empty binary canvas
binary=false(1024,1024);
%go through and find where there is black space
for ii=180:1:900
    for jj=1:1:1024
        if I(ii,jj,:)<100 && I(ii,jj,:)>20
            binary(ii,jj)=1;
        end
    end
end
%fill holes
%first blur image then rethreshold
window=20;
kernel=ones(window)/window^2;
binary2=conv2(single(binary),kernel,'same');
binary3=binary2>.5;
%then fill any other encircled holes
binary3=imfill(binary3,'holes');
% get rid of smaller areas and create edges
binary4=bwareaopen(binary3,30000);
[rows, columns] = find(binary4);
topRow = min(rows);
bottomRow = max(rows);
leftColumn = min(columns);
rightColumn = max(columns);
%now create about left lung
for ii=topRow:1:bottomRow
    for jj=leftColumn:1:rightColumn/2
        splitleft(ii-topRow+1,jj-leftColumn+1,:)=I(ii,jj,:);
    end
end
%now create about right lung
for ii=topRow:1:bottomRow
    for jj=ceil(rightColumn/2):1:1024
        splitright(ii-topRow+1,jj-ceil(rightColumn/2)+1,:)=I(ii,jj,:);
    end
end


% now find white and black of each lung
%LEFT:
binary27=[];
blackcountleft=0;
whitecountleft=0;
[rows, columns] = find(splitleft);
topRow = min(rows);
bottomRow = max(rows);
leftColumn = min(columns);
rightColumn = max(columns);
for ii=1:1:bottomRow
    for jj=1:1:rightColumn
        if splitleft(ii,jj,:)<=50
            blackcountleft=blackcountleft+1;
        elseif splitright(ii,jj,:)>=200
            whitecountleft=whitecountleft+1;
            binary27(ii,jj)=1;
        end
    end
end
%RIGHT:
binary28=[];
blackcountright=0;
whitecountright=0;
[rows, columns] = find(splitright);
topRow = min(rows);
bottomRow = max(rows);
leftColumn = min(columns);
rightColumn = max(columns);
for ii=1:1:bottomRow
    for jj=1:1:rightColumn
        if splitright(ii,jj,:)<=50
            blackcountright=blackcountright+1;
        elseif splitright(ii,jj,:)>=200
            whitecountright=whitecountright+1;
            binary28(ii,jj)=1;
        end
    end
end

%let's try to be more hepful here with overall intensity
%left average
rgbImage=graytocolor(splitleft);
r=mean2(rgbImage(:,:,1))/(length(rgbImage)*width(rgbImage));
g=mean2(rgbImage(:,:,2))/(length(rgbImage)*width(rgbImage));
b=mean2(rgbImage(:,:,3))/(length(rgbImage)*width(rgbImage));
meanleft=(r+g+b)/3*10000000
%right average
rgbImage=graytocolor(splitright);
r=mean2(rgbImage(:,:,1))/(length(rgbImage)*width(rgbImage));
g=mean2(rgbImage(:,:,2))/(length(rgbImage)*width(rgbImage));
b=mean2(rgbImage(:,:,3))/(length(rgbImage)*width(rgbImage));
meanright=(r+g+b)/3*10000000


%FINAL THOUGHTS
%for overall counts (not very accurate tbh)
%pneumo: higher black count
%pleural: higher white count
%neither: white and black count are about consistent
%I would guess that there probably needs to be about 1000 leadway in both
%counts

%for intensity
%pneumo is >x3 intensity difference (ie meanright=1, meanleft>=3)
%effusion is ~2.5x intensity difference (ie meanright=36, meanleft=15)
%no finding: less than 1.7x intensity difference