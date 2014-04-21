

dirOfinterest = uigetdir;

cd(dirOfinterest)

fDir = dir('*.tiff');
fNames = {fDir.name};

betaPV = [];
cfosPV = [];
for i = 1:length(fNames)
    
    forsize = imread(fNames{i});
    [dim1,dim2,~] = size(forsize);
    
    [~, PolyXC, PolyYC] = roipoly(fNames{i});
    polyMask = poly2mask(PolyXC,PolyYC,dim1,dim2);
    
    cfosImage = forsize(:,:,1);
    betagalImage = forsize(:,:,3);
    
    cfosPixelVals = regionprops(polyMask,cfosImage,'PixelValues');
    betaPixelVals = regionprops(polyMask,betagalImage,'PixelValues');
    
    cfosPV = [cfosPV ; cfosPixelVals.PixelValues];
    betaPV = [betaPV ; betaPixelVals.PixelValues];
    
    
    close all;
end


meanGT = mean(betaPV);
meanCP = mean(cfosPV);

sdGT = std(double(betaPV));
sdCP = std(double(cfosPV));

threshGT = meanGT + (sdGT*2);
threshCP = meanCP + (sdCP*2);

thresholds.Green = threshGT;
thresholds.Red = threshCP;

save('Nall_threshold.mat','thresholds');