% Make a truecolor all-green image.


overlay = imoverlay(chan2disp, overlap, [1 0 0]);
figure;imshow(overlay)

overlayCfos = imoverlay(chan2disp, labeltwo, [0 0 1]);
figure;imshow(overlayCfos)

overlayBeta = imoverlay(chan2disp, expandGTimage, [0 1 0]);
figure;imshow(overlayBeta)



for ii = 1:length(toSave.OD)
    
    overll = imoverlay(toSave.OD{1,ii}.Image, toSave.OD{1,ii}.labeltwoImage, [1 0 0]);
    
    figure;imshow(overll)
    set(gcf,'name',toSave.OD{1,ii}.imageID,'numbertitle','off')




end

I = imread('rice.png');

surf(double(toSave.OD{1,ii}.labeltwoImageP))
shading interp % removes gridlines



figure;imagesc(compareImage)


saveas(gcf,'140123c_150mM_MSG_perf_5h_post_stim_c1.tif')


sum(sum(compareImage))

sum(sum(expandGTimage))

sum(sum(overlap))