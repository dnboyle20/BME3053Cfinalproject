% BME 3053C Final Project
% Author: Lauren Ellis
% Course: BME 3053C Computer Applications for BME 
% Group Members: Sarah Stenber, Karley Baringer, and Delaney Boyle
% Term: Spring 2022 
% J. Crayton Pruitt Family Department of Biomedical Engineering 
% University of Florida 
% Email: lauren.ellis@ufl.edu 
% April 18, 2022

clc; clear;

%import images
I=imread('img18.png');

%create empty binary canvas
binary=false(1024,1024);
%go through and find where there is black space
for ii=180:1:900
    for jj=50:1:950
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
binary5=edge(binary4);

%cut off not edges
binary6=false(1024,1024);
for ii=1:1:1024
    for jj=length(binary4):-1:1
        if binary5(jj,ii)==1
            binary6(jj,ii)=1;
            break
        end
    end
end

%connect edges by dialating
binary6=imdilate(binary6,strel('disk',4));

%once again remove smaller items
binary6=bwareaopen(binary6,600);

%see if the two corners are relatively even
%first find overall corners
[rows, columns] = find(binary4);
topRow = min(rows);
bottomRow = max(rows);
leftColumn = min(columns);
rightColumn = max(columns);
%now create about left lung
binarysplitleft=[];
for ii=topRow:1:bottomRow
    for jj=leftColumn:1:rightColumn/2
        binarysplitleft(ii,jj)=binary4(ii,jj);
    end
end
%now create about right lung
binarysplitright=[];
for ii=topRow:1:bottomRow
    for jj=ceil(rightColumn/2):1:1024
        binarysplitright(ii,jj)=binary4(ii,jj);
    end
end
%now find bottom points of both
[rows, columns] = find(binarysplitleft);
bottomRowleft = max(rows);
[rows, columns] = find(binarysplitright);
bottomRowright = max(rows);


%FINAL THOUGHTS
%if bottom row left and bottom row right are over 200ish apart, there is a
%pleural effusion. Not very helpful for pneumothorax.


