function varargout = OptiColocalizEstimator(varargin)
% OPTICOLOCALIZESTIMATOR MATLAB code for OptiColocalizEstimator.fig
%      OPTICOLOCALIZESTIMATOR, by itself, creates a new OPTICOLOCALIZESTIMATOR or raises the existing
%      singleton*.
%
%      H = OPTICOLOCALIZESTIMATOR returns the handle to a new OPTICOLOCALIZESTIMATOR or the handle to
%      the existing singleton*.
%
%      OPTICOLOCALIZESTIMATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTICOLOCALIZESTIMATOR.M with the given input arguments.
%
%      OPTICOLOCALIZESTIMATOR('Property','Value',...) creates a new OPTICOLOCALIZESTIMATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OptiColocalizEstimator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OptiColocalizEstimator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OptiColocalizEstimator

% Last Modified by GUIDE v2.5 05-Mar-2014 20:20:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @OptiColocalizEstimator_OpeningFcn, ...
    'gui_OutputFcn',  @OptiColocalizEstimator_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% TO DO
% REVISE EXPORT TO ACCOMODATE COLOCALIZATION




% --- Executes just before OptiColocalizEstimator is made visible.
function OptiColocalizEstimator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OptiColocalizEstimator (see VARARGIN)

% Choose default command line output for OptiColocalizEstimator
handles.output = hObject;

% Start with specific Options inactivated
set(handles.optDen,'Enable','off')
set(handles.coloc,'Enable','off')
set(handles.stAnaly,'Enable','off')
set(handles.expOpts,'Enable','off')
set(handles.clearIMS,'Enable','off')
set(handles.chChoice,'Visible','off');
set(handles.zi,'Visible','off')
set(handles.zo,'Visible','off')
set(handles.pan,'Visible','off')
set(handles.optDen,'checked','off')
set(handles.coloc,'checked','off')



set(handles.imDisplay,'Visible','off')
set(handles.imDisplay,'XTickLabel',[],'YTickLabel',[],...
    'XTick',[],'YTick',[]);


handles.PixelDataOut.OD = {};
handles.CaseCount = 1;



% set(handles.infoT,'String','Load Image Files');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OptiColocalizEstimator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OptiColocalizEstimator_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in filelist.
function filelist_Callback(hObject, eventdata, handles)
% hObject    handle to filelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filelist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filelist

set(handles.fnameBox,'String','')

% Get choice from list
secChoice = get(hObject,'Value');
handles.section2use = handles.FileNames{secChoice};
handles.liveImage = imread(handles.section2use);

% Display image selected
axes(handles.imDisplay);
imshow(handles.liveImage);

% Set default to tricolor
set(handles.aC,'Value',1);

set(handles.fnameBox,'String',handles.FileNames{secChoice})



guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function filelist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%
% MENU ITEMS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE OPTIONS---------------------------------------------################
function fileOpts_Callback(hObject, eventdata, handles)
% hObject    handle to fileOpts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load Image Series--------------------------------------------------------
function loadIMS_Callback(hObject, eventdata, handles)
% hObject    handle to loadIMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Objectives:
% 1. Load folder location of image files into the workspace
% 2. Create a list variable of the file names
% 3. Load list into the listpanel
% 4. Load the first image into the main window

set(handles.fnameBox,'String','')

% 1. Get Folder location
handles.fileLoc = uigetdir;

% If user clicks 'x' button without selecting folder than option will
% reopen
while ~handles.fileLoc
    toDo = questdlg('Did you mean to exit without selecting a Folder?',...
        'Reselect Folder','Yes','No','No');
    
    switch toDo
        case 'Yes'
            break
        case 'No'
            handles.fileLoc = uigetdir;
    end
end

% cd to directory
cd(handles.fileLoc)
% Check for tif files
fileDir = [dir('*tif'); dir('*tiff')];
fileTypes = {fileDir.name};
% Get file extensions of files in folder location
[~,~,exts] = cellfun(@(x) fileparts(x), fileTypes, 'UniformOutput',false);
extTest = unique(exts);
% If neither TIF nor TIFF exist then the program will break
if isempty(extTest)
    warndlg('There are tif files in this location!')
    return
end
% If TIF or TIFF files are found then they will be loaded

% 2. Create list handle
handles.FileNames = fileTypes;
% 3. Load file names into list panel
set(handles.filelist,'String',handles.FileNames)
% 4. Load first image into Display
handles.liveImage = imread(handles.FileNames{1});

set(handles.fnameBox,'String',handles.FileNames{1})

% Show Image
set(handles.imDisplay,'Visible','on')
axes(handles.imDisplay);
imshow(handles.liveImage)
% Show Color Channel Options
set(handles.chChoice,'Visible','on');
set(handles.aC,'Value',1);
% Turn off Load Image Series
set(handles.loadIMS,'Enable','off')
% Turn on Analysis Start
set(handles.stAnaly,'Enable','on')
% Turn on toolbar
set(handles.zi,'Visible','on')
set(handles.zo,'Visible','on')
set(handles.pan,'Visible','on')

guidata(hObject, handles);

% Clear Image Series-------------------------------------------------------
function clearIMS_Callback(hObject, eventdata, handles)
% hObject    handle to clearIMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% Exit Program-------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exitquest = questdlg('Are you sure you want to EXIT the program?','Exit?',...
    'Yes','No','Yes');

switch exitquest
    case 'Yes'
        delete(handles.figure1);
    case 'No'
        return
end

% Exit And Reload----------------------------------------------------------
function exReload_Callback(hObject, eventdata, handles)
% hObject    handle to exReload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exitquest = questdlg('Are you sure you want to RESTART the program?','Restart?',...
    'Yes','No','Yes');

switch exitquest
    case 'Yes'
        delete(handles.figure1);
        OptiColocalizEstimator;
    case 'No'
        return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANALYSIS OPTIONS-----------------------------------------################
function analOpts_Callback(hObject, eventdata, handles)
% hObject    handle to analOpts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Start Analysis-----------------------------------------------------------
function stAnaly_Callback(hObject, eventdata, handles)
% hObject    handle to stAnaly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

analyCheck = questdlg('Are you sure you want to start an analysis?','Analysis?',...
    'Yes','No','Yes');

switch analyCheck
    case 'Yes'
        
        set(handles.stAnaly,'checked','on')
        set(handles.stAnaly,'Enable','off')
        set(handles.optDen,'Enable','on')
        set(handles.coloc,'Enable','on')
        set(handles.filelist,'Enable','off')
        set(handles.chChoice','Visible','off')
        set(handles.filelist,'Value',1);
        
        set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
        
    case 'No'
        return
end

guidata(hObject, handles);

% Optical Density----------------------------------------------------------
function optDen_Callback(hObject, eventdata, handles)
% hObject    handle to optDen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.dataTable,'Data',0,'ColumnName','MeanIntensity',...
    'ColumnWidth',{100});

cla(handles.imDisplay);
set(handles.dataTable,'Data','');
% 3. Load file names into list panel
imageNames = get(handles.filelist,'String');
% 4. Load first image into Display
handles.liveImage = imread(imageNames{1});

set(handles.coloc,'checked','off')
set(handles.optDen,'checked','on')
set(handles.analOpts,'Enable','off')
set(handles.mesText,'String','Draw Polygon');

% User choose Display Channel
axes(handles.imDisplay);
chanToggle = 1;
while chanToggle
    
    dispChan = questdlg('Choose channel to trace ROI','TRACE RGB','R','G','B','B');
    
    switch dispChan
        case 'R'
            choseDChan = 1;
        case 'G'
            choseDChan = 2;
        case 'B'
            choseDChan = 3;
    end
    
    [dim1,dim2,~] = size(handles.liveImage);
    blankImage = uint8(zeros(dim1,dim2,3));
    blankImage(:,:,choseDChan) = handles.liveImage(:,:,choseDChan);
    chan2disp = blankImage;
    imshow(chan2disp)
    
    chanAccept = questdlg('Accept RGB channel for ROI trace?','Accept channel?','Yes',...
        'No','Yes');
    
    switch chanAccept
        case 'Yes'
            chanToggle = 0;
        case 'No'
            chanToggle = 1;
    end
end

% User choose Analyze Channel
analyzeChan = questdlg('Choose channel to Analyze Optical Density','ANALYZE RGB','R','G','B','B');

switch analyzeChan
    case 'R'
        choseAChan = 1;
    case 'G'
        choseAChan = 2;
    case 'B'
        choseAChan = 3;
end


axes(handles.imDisplay);
for imI = 1:length(imageNames)
    
    set(handles.fnameBox,'String',imageNames{imI})
    set(handles.filelist,'Value',imI);
    
    cla(handles.imDisplay);
    handles.liveImage = imread(imageNames{imI});
    [dim1,dim2,~] = size(handles.liveImage);
    
    % Make inverted image
    image2invert = handles.liveImage(:,:,choseDChan);
    invertImInterest = 255-image2invert;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    
    chan2disp = invertImInterest;
    
    imshow(chan2disp)
    
    hold on;
    polyToggle = 1;
    while polyToggle
        
        % Draw NTS polygon
        [~, handles.PolyXC, handles.PolyYC] = roipoly(chan2disp);
        plot(handles.PolyXC, handles.PolyYC,'-y');
        
        polyAccept = questdlg('Accept Traced ROI POLYGON?','Accept ROI?','Yes',...
            'No','Yes');
        
        switch polyAccept
            case 'Yes'
                polyToggle = 0;
            case 'No'
                polyToggle = 1;
        end
    end
    
    image2analyze = handles.liveImage(:,:,choseAChan);
    
    % User choose Analyze Channel
    polyChan = questdlg('Analyze Whole Polygon or Separate Squares','Polygon?','Polygon','Squares','Polygon');
    
    switch polyChan
        case 'Polygon'
            polyToggle = 1;
        case 'Squares'
            polyToggle = 0;
    end
    
    if polyToggle
        wholePolymask = poly2mask(handles.PolyXC,handles.PolyYC,dim1,dim2); % Get mask
        handles.pixelInfo = regionprops(wholePolymask,image2analyze,'MaxIntensity','WeightedCentroid','MeanIntensity','PixelValues','Area');
        
        % Calculate pixel threshold
        pixelThreshold = mean(handles.pixelInfo.PixelValues) + (std(double(handles.pixelInfo.PixelValues))*2);
        % Copy original image
        image2thresh = image2analyze;
        % Exclude all pixels outside polygon
        image2thresh(~wholePolymask) = 0;
        finalImage = image2thresh > pixelThreshold;
        densityArea = bwarea(finalImage);
        handles.pixelInfo.fracDenArea = densityArea/handles.pixelInfo.Area;
        
        
    else
        
        % Calculate polygon area
        polyArea = polyarea(handles.PolyXC, handles.PolyYC);
        
        % Calculate circle with area 1/4 the area of polygon
        radius = sqrt(polyArea/pi);
        handles.fourRad = radius/4;
        
        set(handles.mesText,'String','Click mouse three times in POLYGON');
        
        % User select three sample points within polygon
        [handles.XCoords, handles.YCoords] = ginput(3);
        % Round coordinates
        handles.XCoords  = round(handles.XCoords);
        handles.YCoords  = round(handles.YCoords);
        
        % Derive three circles from user selected points
        
        % Set IMAGE Layer to analyze by User
        
        totPixels = dim1*dim2;
        onePercent = totPixels*0.002;
        boxDim = round(sqrt(onePercent));
        halfBD = round(boxDim/2);
        
        sYcoords = cell(1,3);
        sXcoords = cell(1,3);
        for si = 1:length(handles.XCoords)
            sXcoords{1,si} = round([handles.XCoords(si) - halfBD , handles.XCoords(si) + halfBD, handles.XCoords(si) + halfBD, handles.XCoords(si) - halfBD]);
            sYcoords{1,si} = round([handles.YCoords(si) - halfBD , handles.YCoords(si) - halfBD, handles.YCoords(si) + halfBD, handles.YCoords(si) + halfBD]);
        end
        
        pixelBox = cell(3,1);
        pixelsPerbox = cell(1,3);
        hold on
        boxPlotsS = cell(1,3);
        for sti = 1:3
            samplebox = roipoly(dim1,dim2,sYcoords{1,sti},sXcoords{1,sti});
            square_mask = poly2mask(sXcoords{1,sti},sYcoords{1,sti},dim1,dim2);
            pixelsPerbox{1,sti} = image2analyze(square_mask);
            [Bi, ~] = bwboundaries(samplebox,'noholes');
            boxIndices = cell2mat(Bi);
            boxPlotsS{1,sti} = boxIndices;
            plot(boxPlotsS{1,sti}(:,1),boxPlotsS{1,sti}(:,2),'y')
            pixelBox{sti,1} = regionprops(square_mask,image2analyze,'MaxIntensity','WeightedCentroid','MeanIntensity','PixelValues','Area');
        end
        
        handles.pixelInfo.MaxIntensity = mean([pixelBox{1}.MaxIntensity , pixelBox{2}.MaxIntensity , pixelBox{3}.MaxIntensity]);
        handles.pixelInfo.MeanIntensity = mean([pixelBox{1}.MeanIntensity , pixelBox{2}.MeanIntensity , pixelBox{3}.MeanIntensity]);
        handles.pixelInfo.PixelValues = [pixelBox{1}.PixelValues , pixelBox{2}.PixelValues , pixelBox{3}.PixelValues];
        handles.pixelInfo.Area = mean([pixelBox{1}.Area , pixelBox{2}.Area , pixelBox{3}.Area]);
        
        % Calculate pixel threshold
        pixelThreshold = mean(handles.pixelInfo.PixelValues) + (std(double(handles.pixelInfo.PixelValues))*2);
        % Copy original image
        image2thresh = image2analyze;
        % Exclude all pixels outside polygon
        wholePolymask = poly2mask(handles.PolyXC,handles.PolyYC,dim1,dim2); % Get mask
        image2thresh(~wholePolymask) = 0;
        finalImage = image2thresh > pixelThreshold;
        densityArea = bwarea(finalImage);
        handles.pixelInfo.fracDenArea = densityArea/handles.pixelInfo.Area;
        
    end
    
    % Save data from each section
    handles.PixelDataOut.OD{imI} = handles.pixelInfo;
    currentData = get(handles.dataTable,'Data');
    currentData{imI,1} = ceil(handles.pixelInfo.MeanIntensity*100)/100;
    set(handles.dataTable,'Data',currentData);
    
end

set(handles.fnameBox,'String','')
set(handles.expOpts,'Enable','on')
cla(handles.imDisplay)
set(handles.mesText,'String','EXPORT YOUR DATA to EXCEL');

guidata(hObject, handles);



% Colocalization-----------------------------------------------------------
function coloc_Callback(hObject, eventdata, handles)
% hObject    handle to coloc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.dataTable,'Data',{0 , 0},'ColumnName',{'Ch1 % Overlap',...
    'Ch1 % Overlap'},'ColumnWidth',{90 90});

cla(handles.imDisplay);
set(handles.dataTable,'Data','');
% 3. Load file names into list panel
imageNames = get(handles.filelist,'String');
% 4. Load first image into Display
handles.liveImage = imread(imageNames{1});

set(handles.optDen,'checked','off')
set(handles.coloc,'checked','on')
set(handles.analOpts,'Enable','off')
set(handles.mesText,'String','Draw Polygon');

% User choose Display Channel
axes(handles.imDisplay);
chanToggle = 1;
while chanToggle
    
    dispChan = questdlg('Choose channel to trace ROI','TRACE RGB','R','G','B','B');
    
    switch dispChan
        case 'R'
            choseDChan = 1;
        case 'G'
            choseDChan = 2;
        case 'B'
            choseDChan = 3;
    end
    
    [dim1,dim2,~] = size(handles.liveImage);
    blankImage = uint8(zeros(dim1,dim2,3));
    blankImage(:,:,choseDChan) = handles.liveImage(:,:,choseDChan);
    chan2disp = blankImage;
    imshow(chan2disp)
    
    chanAccept = questdlg('Accept RGB channel for ROI trace?','Accept channel?','Yes',...
        'No','Yes');
    
    switch chanAccept
        case 'Yes'
            chanToggle = 0;
        case 'No'
            chanToggle = 1;
    end
end

% Choose which channels to analyze for overlap/colocalization
analyzChan = inputdlg({'Channel 1','Channel 2'}, 'Channel ID', [1 50; 1 50],{'Green','Red'});

for fi2 = 1:2
    switch analyzChan{fi2,1}
        case 'Red'
            handles.CLch(fi2) = 1;
        case 'Green'
            handles.CLch(fi2) = 2;
        case 'Blue'
            handles.CLch(fi2) = 3;
    end
end

% ADD Ground truth toggle and control flow to switch


gUse = questdlg('Expand area around ground truth lablel?','Use Ground Truth?','Yes',...
    'No','Yes');

switch gUse
    case 'Yes'
        gtChoose = 1;
        gtruthToggle = 1;
    case 'No'
        gtChoose = 0;
        gtruthToggle = 0;
end

if gtChoose
    
    gtChannel = questdlg('Choose ground truth channel','Channel?',analyzChan{1,1},analyzChan{2,1},analyzChan{1,1});
    
    comChannel = analyzChan{~ismember(analyzChan,gtChannel)};
    
    switch gtChannel
        case 'Red'
            handles.gtCHAN = 1;
        case 'Green'
            handles.gtCHAN = 2;
        case 'Blue'
            handles.gtCHAN = 3;
    end
    
    switch comChannel
        case 'Red'
            handles.cmpCHAN = 1;
        case 'Green'
            handles.cmpCHAN = 2;
        case 'Blue'
            handles.cmpCHAN = 3;
    end
end


if gtruthToggle
    
    t_fname = uigetfile;
    load(t_fname)
    threshCP = thresholds.Red;
    threshGT = thresholds.Green;
    
    axes(handles.imDisplay);
    for imI = 1:length(imageNames)
        
        set(handles.fnameBox,'String',imageNames{imI})
        set(handles.filelist,'Value',imI);
        
        cla(handles.imDisplay);
        handles.liveImage = imread(imageNames{imI});
        [dim1,dim2,~] = size(handles.liveImage);
        % Make inverted image
        image2invert = handles.liveImage(:,:,choseDChan);
        invertImInterest = 255-image2invert;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%
        
        chan2disp = invertImInterest;
        imshow(chan2disp)
        
        hold on;
        polyToggle = 1;
        while polyToggle
            
            % Draw NTS polygon
            [~, handles.PolyXC, handles.PolyYC] = roipoly(chan2disp);
            plot(handles.PolyXC, handles.PolyYC,'-y');
            
            polyAccept = questdlg('Accept Traced ROI POLYGON?','Accept ROI?','Yes',...
                'No','Yes');
            
            switch polyAccept
                case 'Yes'
                    polyToggle = 0;
                case 'No'
                    polyToggle = 1;
            end
        end
        
        %%%% NEW STUFF 4/17/2014
        
        groundTimage = handles.liveImage(:,:,handles.gtCHAN); %betagal
        compareImage = handles.liveImage(:,:,handles.cmpCHAN); %cfos
        
        polyMask = poly2mask(handles.PolyXC,handles.PolyYC,dim1,dim2); % Get mask
        
        gtPixelVals = regionprops(polyMask,groundTimage,'PixelValues','Area');
        cmpPixelVals = regionprops(polyMask,compareImage,'PixelValues');
        
        meanGT = mean(gtPixelVals.PixelValues);
        meanCP = mean(cmpPixelVals.PixelValues);
        
        sdGT = std(double(gtPixelVals.PixelValues));
        sdCP = std(double(cmpPixelVals.PixelValues));
        
%         threshGT = meanGT + (sdGT*2);
%         threshCP = meanCP + (sdCP*2);
        
        %%% LOAD THRESHOLDS
        
        compareImage(~polyMask) = 0;
        compareImage = compareImage > threshCP;
        cpArea = bwarea(compareImage)/gtPixelVals.Area;

        groundTimage(~polyMask) = 0; 
        groundTimage = groundTimage > threshGT;
        gtArea = bwarea(groundTimage)/gtPixelVals.Area; % gtPixelVals.Area = area of polygon
        
        [x,y] = find(groundTimage == 1);

%         expandGTimage = false(size(groundTimage));
%         for ppi = 1:length(x)
%             tempX = [repmat(x(ppi)-1,3,1) ; repmat(x(ppi),3,1) ; repmat(x(ppi)+1,3,1)];
%             tempY = repmat(y(ppi)-1:1:y(ppi)+1,1,3)';
%             
%             expandGTimage(tempX,tempY) = 1;
%             
%         end
        expandGTimage = groundTimage;

        [L, NUM] = bwlabeln(compareImage);
        allCCS = zeros(NUM,1);
        for i = 1:NUM
            tempL = L == i;
            allCCS(i) = sum(sum(tempL));
            
            if allCCS(i) < 30
                [x,y] = find(tempL == 1);
                
                compareImage(x,y) = 0;
                
            end
        end
        
        % Fraction BetaGal 
        % Fraction Cfos
        % Fraction of Overlap

        overlap = compareImage & expandGTimage;
        
        betaGalRatio = sum(sum(overlap))/sum(sum(expandGTimage));
        cfosRatio = sum(sum(overlap))/sum(sum(compareImage));
        
        
        cfos_numPixels = sum(sum(compareImage)) 
        
        beta_numPixels = sum(sum(expandGTimage))
        
        overlap_numPixels = sum(sum(overlap))
        % double label/betagal
        
        % Revise SAVE DATA
        
        % SET THRESHOLD on STIMULATED CASE
        
        % Save data from each section 4/17/2014
        
        currentData = get(handles.dataTable,'Data');
        currentData{imI,1} = nan;
        currentData{imI,2} = ceil(betaGalRatio*100)/100;
        set(handles.dataTable,'Data',currentData);
        
        overlay = imoverlay(chan2disp, overlap, [1 0 0]);
        overlayCfos = imoverlay(chan2disp, compareImage, [0 0 1]);
        overlayBeta = imoverlay(chan2disp, expandGTimage, [0 1 0]);
        
        handles.pixelInfo.betaGalratio = gtArea;
        handles.pixelInfo.cfosratio = cpArea;
        handles.pixelInfo.colocratio = betaGalRatio;
        handles.pixelInfo.imageBW = invertImInterest;
        handles.pixelInfo.imageID = imageNames{imI};
        handles.pixelInfo.overlayImage = overlap;
        handles.pixelInfo.overlayPlot = overlay;
        handles.pixelInfo.betaGalImage = expandGTimage;
        handles.pixelInfo.betaGalPlot = overlayBeta;
        handles.pixelInfo.cfosImage = compareImage;
        handles.pixelInfo.cfosPlot = overlayCfos;
        
        handles.PixelDataOut.OD{imI} = handles.pixelInfo;
        
    end

else
    
    axes(handles.imDisplay);
    for imI = 1:length(imageNames)
        
        set(handles.fnameBox,'String',imageNames{imI})
        set(handles.filelist,'Value',imI);
        
        cla(handles.imDisplay);
        handles.liveImage = imread(imageNames{imI});
        [dim1,dim2,~] = size(handles.liveImage);
        % Make inverted image
        image2invert = handles.liveImage(:,:,choseDChan);
        invertImInterest = 255-image2invert;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%
        
        chan2disp = invertImInterest;
        imshow(chan2disp)
        
        hold on;
        polyToggle = 1;
        while polyToggle
            
            % Draw NTS polygon
            [~, handles.PolyXC, handles.PolyYC] = roipoly(chan2disp);
            plot(handles.PolyXC, handles.PolyYC,'-y');
            
            polyAccept = questdlg('Accept Traced ROI POLYGON?','Accept ROI?','Yes',...
                'No','Yes');
            
            switch polyAccept
                case 'Yes'
                    polyToggle = 0;
                case 'No'
                    polyToggle = 1;
            end
        end
        
        colocImage1 = handles.liveImage(:,:,handles.CLch(1));
        colocImage2 = handles.liveImage(:,:,handles.CLch(2));
        
        polyMask = poly2mask(handles.PolyXC,handles.PolyYC,dim1,dim2); % Get mask
        
        CL1 = regionprops(polyMask,colocImage1,'PixelValues');
        CL2 = regionprops(polyMask,colocImage2,'PixelValues');
        
        meanPixCL1 = mean(CL1.PixelValues);
        meanPixCL2 = mean(CL2.PixelValues);
        
        sdPixCL1 = std(double(CL1.PixelValues));
        sdPixCL2 = std(double(CL2.PixelValues));
        
        threshCL1 = meanPixCL1 + (sdPixCL1*2);
        threshCL2 = meanPixCL2 + (sdPixCL2*2);
        
        colocImage1(~polyMask) = 0; % use inverse of mask to get rid of out poly pixels
        colocAbovThresh1 = colocImage1 > threshCL1;
        
        colocImage2(~polyMask) = 0;
        colocAbovThresh2 = colocImage2 > threshCL2;
        
        overlap = colocAbovThresh1 & colocAbovThresh2;
        
        colocRatio1 = sum(sum(overlap))/sum(sum(colocAbovThresh1));
        colocRatio2 = sum(sum(overlap))/sum(sum(colocAbovThresh2));
        
        
        % Save data from each section
        
        currentData = get(handles.dataTable,'Data');
        currentData{imI,1} = ceil(colocRatio1*100)/100;
        currentData{imI,2} = ceil(colocRatio2*100)/100;
        set(handles.dataTable,'Data',currentData);
        
        handles.pixelInfo.Channel1Ratio = colocRatio1;
        handles.pixelInfo.Channel2Ratio = colocRatio2;
        handles.pixelInfo.Channel1ID = handles.CLch(1);
        handles.pixelInfo.Channel2ID = handles.CLch(2);
        
        handles.PixelDataOut.OD{imI} = handles.pixelInfo;
        
    end
    
end

set(handles.fnameBox,'String','')
set(handles.expOpts,'Enable','on')
cla(handles.imDisplay)
set(handles.mesText,'String','EXPORT YOUR DATA to EXCEL');
set(handles.optDen,'checked','on')


guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXPORT OPTIONS-------------------------------------------################
function expOpts_Callback(hObject, eventdata, handles)
% hObject    handle to expOpts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Export to Excel----------------------------------------------------------
function expExcel_Callback(hObject, eventdata, handles)
% hObject    handle to expExcel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exitquest = questdlg('Are you sure you want EXPORT to EXCEL?','Export?',...
    'Yes','No','Yes');

switch exitquest
    case 'Yes'
        
        odCheck = get(handles.optDen,'checked');
        colCheck = get(handles.coloc,'checked');
        
        if strcmp(odCheck,'on') && strcmp(colCheck,'off')
            
            secNames = handles.FileNames;
            
            saveDir = uigetdir;
            cd(saveDir);
            
            sectionNum = cell(length(handles.PixelDataOut.OD),1);
            maxIn = cell(length(handles.PixelDataOut.OD),1);
            meanIn = cell(length(handles.PixelDataOut.OD),1);
            areaOut = cell(length(handles.PixelDataOut.OD),1);
            fracOut = cell(length(handles.PixelDataOut.OD),1);
            for i = 1:length(handles.PixelDataOut.OD)
                sectionNum{i} = secNames{i};
                maxIn{i} = handles.PixelDataOut.OD{i}.MaxIntensity;
                meanIn{i} = handles.PixelDataOut.OD{i}.MeanIntensity;
                areaOut{i} = handles.PixelDataOut.OD{i}.Area;
                fracOut{i} = handles.PixelDataOut.OD{i}.fracDenArea;
            end
            
            DS = dataset(sectionNum, maxIn, meanIn, areaOut, fracOut, 'VarNames', {'Section','MaxIntensity','MeanIntensity','PolyArea','FractionPixelsAboveArea'});
            
            saveFname = inputdlg('Choose a savename','Save Name',1,{'case 1'});
            
            filename = strcat(char(saveFname),'.xlsx');
            
            export(DS,'XLSfile',filename);
            
        elseif strcmp(odCheck,'off') && strcmp(colCheck,'on')
            
            secNames = handles.FileNames;
            
            saveDir = uigetdir;
            cd(saveDir);
            
            chanOutID = struct;
            for cchi = 1:2
                tempVal = handles.PixelDataOut.OD{1,1}.(strcat('Channel',num2str(cchi),'ID'));
                switch tempVal
                    case 1
                        chanOutID.(strcat('chan',num2str(cchi))) = 'Red';
                    case 2
                        chanOutID.(strcat('chan',num2str(cchi))) = 'Green';
                    case 3
                        chanOutID.(strcat('chan',num2str(cchi))) = 'Blue';
                end
            end
            
            chanID = cell(length(handles.FileNames)*2,1);
            sectionNum = cell(length(handles.FileNames)*2,1);
            chanColoc = cell(length(handles.FileNames)*2,1);
            counter = 1;
            secC1 = 1;
            secC2 = 2;
            for sei = 1:length(handles.FileNames)
                sectionNum(secC1:secC2) = secNames(sei);
                secC1 = secC1 + 2;
                secC2 = secC2 + 2;
                
                for chi = 1:2
                    chanID{counter} = chanOutID.(strcat('chan',num2str(chi)));
                    chanColoc{counter} = handles.PixelDataOut.OD{1,sei}.(strcat('Channel',num2str(chi),'Ratio'));
                    counter = counter + 1;
                end
            end
            
            DS = dataset(sectionNum, chanID, chanColoc, 'VarNames', {'Section','ChannelID','FracColocalize'});
            
            %%%% INPUT NAME
            
            saveFname = inputdlg('Choose a savename','Save Name',1,{'case 1'});
            
            filename = strcat(char(saveFname),'.xlsx');
            
            export(DS,'XLSfile',filename);
            
        end
        
    case 'No'
        return
end



% Export to Matlab---------------------------------------------------------
function expMatlab_Callback(hObject, eventdata, handles)
% hObject    handle to expMatlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exitquest = questdlg('Are you sure you want EXPORT to EXCEL?','Export?',...
    'Yes','No','Yes');

switch exitquest
    case 'Yes'
        saveDir = uigetdir;
        cd(saveDir);
        
        saveFname = inputdlg('Choose a savename','Save Name',1,{'case 1'});
        
        filename = strcat(char(saveFname),'.mat');
        
        toSave = handles.PixelDataOut;
        
        save(filename,'toSave');
        
    case 'No'
        return
end





function chChoice_SelectionChangeFcn(hObject,eventdata, handles)

newVal = get(eventdata.NewValue,'Tag');

switch newVal % Get Tag of selected object.
    case 'rC'
        [dim1,dim2,~] = size(handles.liveImage);
        blankImage = uint8(zeros(dim1,dim2,3));
        blankImage(:,:,1) = handles.liveImage(:,:,1);
        newChImage = blankImage;
        axes(handles.imDisplay)
        imshow(newChImage)
    case 'gC'
        [dim1,dim2,~] = size(handles.liveImage);
        blankImage = uint8(zeros(dim1,dim2,3));
        blankImage(:,:,2) = handles.liveImage(:,:,2);
        newChImage = blankImage;
        axes(handles.imDisplay)
        imshow(newChImage)
    case 'bC'
        [dim1,dim2,~] = size(handles.liveImage);
        blankImage = uint8(zeros(dim1,dim2,3));
        blankImage(:,:,3) = handles.liveImage(:,:,3);
        newChImage = blankImage;
        axes(handles.imDisplay)
        imshow(newChImage)
    case 'aC'
        axes(handles.imDisplay)
        imshow(handles.liveImage)
    otherwise
        % Code for when there is no match.
end
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOOLBAR OPTIONS------------------------------------------################

% Zoom In On---------------------------------------------------------------
function zi_OnCallback(hObject, eventdata, handles)
% hObject    handle to zi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.mesText,'String','');

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.coloc,'checked'),'on')
    set(handles.mesText,'String','Click on Zoom In again to DRAW POLYGON');
elseif strcmp(get(handles.stAnaly,'checked'),'off')
    set(handles.mesText,'String','Choose Analysis START From Options');
else
    set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
end

% Zoom In Off--------------------------------------------------------------
function zi_OffCallback(hObject, eventdata, handles)
% hObject    handle to zi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.mesText,'String','');

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.coloc,'checked'),'on')
    set(handles.mesText,'String','Draw Polygon');
elseif strcmp(get(handles.stAnaly,'checked'),'off')
    set(handles.mesText,'String','Choose Analysis START From Options');
else
    set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
end

% Zoom Out On--------------------------------------------------------------
function zo_OnCallback(hObject, eventdata, handles)
% hObject    handle to zo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.mesText,'String','');

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.coloc,'checked'),'on')
    set(handles.mesText,'String','Click on Zoom In again to DRAW POLYGON');
elseif strcmp(get(handles.stAnaly,'checked'),'off')
    set(handles.mesText,'String','Choose Analysis START From Options');
else
    set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
end

% Zoom Out Off-------------------------------------------------------------
function zo_OffCallback(hObject, eventdata, handles)
% hObject    handle to zo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.mesText,'String','');

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.coloc,'checked'),'on')
    set(handles.mesText,'String','Draw Polygon');
elseif strcmp(get(handles.stAnaly,'checked'),'off')
    set(handles.mesText,'String','Choose Analysis START From Options');
else
    set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
end

% Pan On-------------------------------------------------------------------
function pan_OnCallback(hObject, eventdata, handles)
% hObject    handle to pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.mesText,'String','');

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.coloc,'checked'),'on')
    set(handles.mesText,'String','Draw Polygon');
elseif strcmp(get(handles.stAnaly,'checked'),'off')
    set(handles.mesText,'String','Choose Analysis START From Options');
else
    set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
end

% Pan Off-------------------------------------------------------------------
function pan_OffCallback(hObject, eventdata, handles)
% hObject    handle to pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.mesText,'String','');

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.coloc,'checked'),'on')
    set(handles.mesText,'String','Draw Polygon');
elseif strcmp(get(handles.stAnaly,'checked'),'off')
    set(handles.mesText,'String','Choose Analysis START From Options');
else
    set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
end
