% BME 3053C Final Project
% Author: Lauren Ellis
% Course: BME 3053C Computer Applications for BME 
% Group Members: Sarah Stenberg, Karley Baringer, and Delaney Boyle
% Term: Spring 2022 
% J. Crayton Pruitt Family Department of Biomedical Engineering 
% University of Florida 
% Email: lauren.ellis@ufl.edu 
% April 18, 2022

function rgbImage = gray2rgb(I)
cmap = jet(256); % Or whatever one you want.
rgbImage = ind2rgb(I, cmap);
end
