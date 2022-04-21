function rgbImage = gray2rgb(I)
cmap = jet(256); % Or whatever one you want.
rgbImage = ind2rgb(I, cmap);
end