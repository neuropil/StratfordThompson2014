testIM = imread('130929a_c1_comb.tif');

figure; imshow(testIM);

% circle of consistent diameter 
% always measure green channel
% toggle between blue and green channels
% Optical density : mean pixel intensity


% 1. Draw polygon
% 2. Calucluate area
% 3. Derive circle 1/5 of area
% 4. Click three sample sites and calculate pixel intensity

%% Draw NTS polygon
[~, Xcoords, Ycoords] = roipoly(testIM);
hold on;
plot(Xcoords, Ycoords,'-y');

% Calculate polygon area
polyArea = polyarea(Xcoords,Ycoords);

% Calculate circle with area 1/4 the area of polygon
radius = sqrt(polyArea/pi);
fourRad = radius/4;

%% User select three sample points within polygon
[ui_sel_x_coord, ui_sel_y_coord] = ginput(3);

% Round coordinates
ui_sel_x_coord = round(ui_sel_x_coord);
ui_sel_y_coord = round(ui_sel_y_coord);

%% Derive three circles from user selected points

image2use = testIM(:,:,2);

pixelInfo = cell(3,1);
for usi = 1:3
    
    cirHandle = imellipse(gca, [ui_sel_x_coord(usi,1) ui_sel_y_coord(usi,1) fourRad fourRad]);
    cirMask = createMask(cirHandle);
    delete(cirHandle)
    [Bi, ~] = bwboundaries(cirMask,'noholes');
    boxIndices = cell2mat(Bi);
    hold on;
    plot(boxIndices(:,2),boxIndices(:,1),'y')
    
    pixelInfo{usi,1} = regionprops(cirMask,image2use,'MaxIntensity','WeightedCentroid','MeanIntensity','PixelValues');
    
end

