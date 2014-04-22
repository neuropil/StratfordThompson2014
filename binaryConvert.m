function [binaryImages] = binaryConvert(imageSel, varargin)

% warndlg('This function assumes that Red channel = cfos and Green channel = beta gal');

narginchk(0,2);

p = inputParser;
validStrings = {'cfos','betagal','both'};
p.addRequired('imageSel', @(x) ischar(x) && any(validatestring(x,validStrings)));
p.addOptional('batchMode', false, @islogical);

parse(p,imageSel,varargin{:})

imageToggle = p.Results.imageSel;
batchToggle = p.Results.batchMode;

switch imageToggle
    
    case 'cfos'
        
        multichan = 0;
        chanUse = 1;
        
    case 'betagal'
        
        multichan = 0;
        chanUse = 2;
        
    case 'both'
        
        multichan = 1;
        
end

switch batchToggle
    
    case 0
 
        [fileName,fileLoc,~] = uigetfile({'*.tiff','*.tif'});
        
        cd(fileLoc);
        tempImage = imread(fileName);
        saveLoc = uigetdir('','Where to save?');
        binaryImages.saveLoc = saveLoc;
        
        if multichan
            
            sCount = 1;
            for chi = 1:2
                
                chanImage = tempImage(:,:,chi);
                imMask = ones(size(chanImage));
                imInfo = regionprops(imMask,chanImage,'PixelValues');
                imMean = mean(imInfo.PixelValues);
                imStd = std(double(imInfo.PixelValues));
                imThresh = imMean + (imStd*2);
                imfosThresh = chanImage > imThresh;
                imfosInvert = ~imfosThresh;
                
                namePiece = strsplit(fileName,'.');
                
                if chi == 1;
                    saveName = strcat(namePiece{1},'_cfosBW.tif');
                else
                    saveName = strcat(namePiece{1},'_betagalBW.tif');
                end
                
                binaryImages.filenames{sCount} = saveName;
                binaryImages.images{sCount} = imfosInvert;
                sCount = sCount + 1;
                
            end
            
        else
            
            chanImage = tempImage(:,:,chanUse);
            imMask = ones(size(chanImage));
            imInfo = regionprops(imMask,chanImage,'PixelValues');
            imMean = mean(imInfo.PixelValues);
            imStd = std(double(imInfo.PixelValues));
            imThresh = imMean + (imStd*2);
            imfosThresh = chanImage > imThresh;
            imfosInvert = ~imfosThresh;
            

            
            namePiece = strsplit(fileName,'.');
            
            if chanUse == 1;
                saveName = strcat(namePiece{1},'_cfosBW.tif');
            else
                saveName = strcat(namePiece{1},'_betagalBW.tif');
            end
            
            binaryImages.filenames = saveName;
            binaryImages.images = imfosInvert;
  
            
        end

    case 1
        
        imagesLoc = uigetdir;
        
        cd(imagesLoc);
        
        fileDir = dir;
        fileNames = {fileDir.name};
        fileNames = fileNames(3:end);
        
        saveLoc = uigetdir('','Where to save?');
        binaryImages.saveLoc = saveLoc;
        
        fCount = 1;
        for fi = 1:length(fileNames)
            
            tempImage = imread(fileNames{fi});
            fileName = fileNames{fi};
            
            if multichan
                
                for ci = 1:2
                    
                    chanImage = tempImage(:,:,ci);
                    imMask = ones(size(chanImage));
                    imInfo = regionprops(imMask,chanImage,'PixelValues');
                    imMean = mean(imInfo.PixelValues);
                    imStd = std(double(imInfo.PixelValues));
                    imThresh = imMean + (imStd*2);
                    imfosThresh = chanImage > imThresh;
                    imfosInvert = ~imfosThresh;
                    
                    namePiece = strsplit(fileName,'.');
                    if ci == 1;
                        saveName = strcat(namePiece{1},'_cfosBW.tif');
                    else
                        saveName = strcat(namePiece{1},'_betagalBW.tif');
                    end
                    
                    binaryImages.filenames{fCount} = saveName;
                    binaryImages.images{fCount} = imfosInvert;
                    
                    fCount = fCount + 1;
                    
                end
                
            else
                
                chanImage = tempImage(:,:,chanUse);
                imMask = ones(size(chanImage));
                imInfo = regionprops(imMask,chanImage,'PixelValues');
                imMean = mean(imInfo.PixelValues);
                imStd = std(double(imInfo.PixelValues));
                imThresh = imMean + (imStd*2);
                imfosThresh = chanImage > imThresh;
                imfosInvert = ~imfosThresh;
                
                namePiece = strsplit(fileName,'.');
                if chanUse == 1;
                    saveName = strcat(namePiece{1},'_cfosBW.tif');
                else
                    saveName = strcat(namePiece{1},'_betagalBW.tif');
                end
                
                binaryImages.filenames{fi} = saveName;
                binaryImages.images{fi} = imfosInvert;

            end
        end
end






























