% BME 3053C Final Project: Decision Tree & Confusion Matrix

% Name: Sarah Stenberg and Delaney Boyle
% Group Members: Karley Baringer and Lauren Ellis
% Course: BME3052C Computer Applications for BME
% Term: Spring 2022
% J.Crayton Pruitt Family Department of Biomedical Engineering
% University of Florida
% Email: s.stenberg@ufl.edu
% April 20, 2022

clc; clear;

% 1 : Effusion
% 2 : No Finding
% 3 : Pneumo

%__________Master Matrix for Decision Tree_____________%
% Only use odds for training set, evens for testing set
mat = zeros(624,3);
mat(1:208,1) = 1;       % Effusion Label
mat(209:416,1) = 2;     % No Finding Label
mat(417:624,1) = 3;     % Pneumo Label
mat(:,2) = 0;
mat(:,3) = 0;

%___________Find 2 Features For Each Image And Add To Master Mat__________%

path = 'Z:\Final Project\FinalProjectImages\DTtest\';
       % Shape feature:
for kk = 1:1:624 %change final value to the total number of images in the folder
%import images

file = strcat(path, 'img', string(kk), '.png'); % create path to image
I = imread(file); % import image

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

diff = abs(bottomRowleft - bottomRowright);

if isempty(diff)     % to compensate for error producing empty vectors
    diff = 0;
end

mat(kk,2) = diff;
end

       % Black/white feature:
for pp = 1:1:624
    
file = strcat(path, 'img', string(pp), '.png'); % create path to image
I = imread(file); % import image
    
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
meanleft=(r+g+b)/3*10000000;
%right average
rgbImage=graytocolor(splitright);
r=mean2(rgbImage(:,:,1))/(length(rgbImage)*width(rgbImage));
g=mean2(rgbImage(:,:,2))/(length(rgbImage)*width(rgbImage));
b=mean2(rgbImage(:,:,3))/(length(rgbImage)*width(rgbImage));
meanright=(r+g+b)/3*10000000;

ratio = meanright/meanleft;

if isempty(ratio)
    ratio = 0;
end

mat(pp,3) = ratio;
end

% Now we have a 624 x 3 matrix with 2 feature columns and 1 label column

%______________Decision Tree_________________%

tree = fitctree([mat(1:2:624,2),mat(1:2:624,3)], mat(1:2:624,1),'PredictorNames',{'shape','blackvwhite'});
view(tree,'mode','graph');


%______________Test Decision Tree_______________%

for mm = 2:2:624
    file = strcat(path, 'img', string(mm), '.png'); % create path to image
    I = imread(file); % import image
    label = predict(tree,mat(mm,2:3));
    mat(mm,4) = label;
end


%_____________Confusion Matrix for Decision Tree_____________%

confMat = confusionchart(mat(:,1),mat(:,4));
