function [] = createBWimages(binaryImages, handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if ischar(binaryImages.filenames);
    binaryImages.filenames = cellstr(binaryImages.filenames);
    binaryImages.images = {binaryImages.images};
end

imageNames = binaryImages.filenames;
axes(handles.imDisplay);
for iims = 1:length(imageNames);
    cd(binaryImages.saveLoc)
    
    cla(handles.imDisplay);

    ImS = imshow(binaryImages.images{iims});
    saveas(ImS,binaryImages.filenames{iims});
    close ImF
end

