% Make a truecolor all-green image.


overlay = imoverlay(chan2disp, overlap, [1 0 0]);
figure;imshow(overlay)

overlayCfos = imoverlay(chan2disp, compareImage, [0 0 1]);
figure;imshow(overlayCfos)

overlayBeta = imoverlay(chan2disp, expandGTimage, [0 1 0]);
figure;imshow(overlayBeta)






figure;imagesc(compareImage)





sum(sum(compareImage))

sum(sum(expandGTimage))

sum(sum(overlap))