function varargout = ROIPixelCount(varargin)
% ROIPIXELCOUNT MATLAB code for ROIPixelCount.fig
%      ROIPIXELCOUNT, by itself, creates a new ROIPIXELCOUNT or raises the existing
%      singleton*.
%
%      H = ROIPIXELCOUNT returns the handle to a new ROIPIXELCOUNT or the handle to
%      the existing singleton*.
%
%      ROIPIXELCOUNT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROIPIXELCOUNT.M with the given input arguments.
%
%      ROIPIXELCOUNT('Property','Value',...) creates a new ROIPIXELCOUNT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ROIPixelCount_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ROIPixelCount_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ROIPixelCount

% Last Modified by GUIDE v2.5 24-Apr-2014 21:38:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ROIPixelCount_OpeningFcn, ...
    'gui_OutputFcn',  @ROIPixelCount_OutputFcn, ...
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

% FIX EXPORT




% --- Executes just before ROIPixelCount is made visible.
function ROIPixelCount_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ROIPixelCount (see VARARGIN)

% Choose default command line output for ROIPixelCount
handles.output = hObject;

% Start with specific Options inactivated
set(handles.pixNum,'Enable','off')
set(handles.stAnaly,'Enable','off')
set(handles.expOpts,'Enable','off')
set(handles.clearIMS,'Enable','off')
set(handles.chChoice,'Visible','off');
set(handles.zi,'Visible','off')
set(handles.zo,'Visible','off')
set(handles.pan,'Visible','off')
set(handles.pixNum,'checked','off')



set(handles.imDisplay,'Visible','off')
set(handles.imDisplay,'XTickLabel',[],'YTickLabel',[],...
    'XTick',[],'YTick',[]);

set(handles.dataTable,'ColumnName',{'LabelOne','LabelTwo','Overlap'},...
    'ColumnWidth',{60 60 55});

handles.PixelDataOut.OD = {};
handles.CaseCount = 1;



% set(handles.infoT,'String','Load Image Files');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ROIPixelCount wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ROIPixelCount_OutputFcn(hObject, eventdata, handles)
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
        ROIPixelCount;
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
        set(handles.pixNum,'Enable','on')
        set(handles.filelist,'Enable','off')
        set(handles.chChoice','Visible','off')
        set(handles.filelist,'Value',1);
        
        set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
        
    case 'No'
        return
end

guidata(hObject, handles);


% Colocalization-----------------------------------------------------------
function pixNum_Callback(hObject, eventdata, handles)
% hObject    handle to pixNum (see GCBO)
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

set(handles.pixNum,'checked','on')
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
labelChan = inputdlg({analyzChan{1},analyzChan{2}}, 'Label', [1 50; 1 50],{'betaGal','cfos'});

for fi2 = 1:2
    switch analyzChan{fi2,1}
        case 'Red'
            handles.CLch{fi2,1} = 1;
            handles.CLch{fi2,2} = labelChan{fi2};
        case 'Green'
            handles.CLch{fi2,1} = 2;
            handles.CLch{fi2,2} = labelChan{fi2};
        case 'Blue'
            handles.CLch{fi2,1} = 3;
            handles.CLch{fi2,2} = labelChan{fi2};
    end
end

% Choose which channels to analyze for overlap/colocalization

% ADD PROGRAM to CALCULATE THRESHOLD

% set(handles.mesText,'String','Trace POLYGON ROI for THRESHOLD');
% 
% labelonePV = []; %betagal
% labeltwoPV = []; %cfos
% for i = 1:length(imageNames)
%     
%     forsize = imread(imageNames{i});
%     [dim1,dim2,~] = size(forsize);
%     
%     [~, PolyXC, PolyYC] = roipoly(imageNames{i});
%     polyMask = poly2mask(PolyXC,PolyYC,dim1,dim2);
%     
%     labeloneImage = forsize(:,:,handles.CLch{1,1});
%     labeltwoImage = forsize(:,:,handles.CLch{2,1});
%     
%     lbonePixelVals = regionprops(polyMask,labeloneImage,'PixelValues');
%     lbtwoPixelVals = regionprops(polyMask,labeltwoImage,'PixelValues');
%     
%     labelonePV = [labelonePV ; lbtwoPixelVals.PixelValues];
%     labeltwoPV = [labeltwoPV ; lbonePixelVals.PixelValues];
%     
%     cla(handles.imDisplay);
% end

fileneed = uigetfile;

load(fileneed);



% meanTlbone = mean(labelonePV);
% meanTlbtwo = mean(labeltwoPV);
% 
% sdTlbone = std(double(labelonePV));
% sdTlbtwo = std(double(labeltwoPV));
% 
% lbonethresh = meanTlbone + (sdTlbone*2);
% lbtwothresh = meanTlbtwo + (sdTlbtwo*2);

lbonethresh = thresholds.Green;
lbtwothresh = thresholds.Red;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    
    labelone = handles.liveImage(:,:,handles.CLch{1,1}); %betagal
    labeltwo = handles.liveImage(:,:,handles.CLch{2,1}); %cfos
    
    polyMask = poly2mask(handles.PolyXC,handles.PolyYC,dim1,dim2); % Get mask
    
    labelonePixelVals = regionprops(polyMask,labelone,'PixelValues','Area');
    labeltwoPixelVals = regionprops(polyMask,labeltwo,'PixelValues','Area');
    
    %%% LOAD THRESHOLDS
    
    labeltwo(~polyMask) = 0;
    labeltwoPolyCut = labeltwo;
    labeltwo = labeltwo > lbtwothresh;
    labeltwoPolyCut(~labeltwo) = 0;
    labeltwoArea = bwarea(labeltwo)/labeltwoPixelVals.Area;
    
    labelone(~polyMask) = 0;
    labelonePolyCut = labelone;
    labelone = labelone > lbonethresh;
    labelonePolyCut(~labelone) = 0;
    labeloneArea = bwarea(labelone)/labelonePixelVals.Area; % gtPixelVals.Area = area of polygon
    
    overlap = labeltwo & labelone;
    
    labeloneRatio = sum(sum(overlap))/sum(sum(labelone));
    labeltwoRatio = sum(sum(overlap))/sum(sum(labeltwo));
    
    labeltwo_numPixels = sum(sum(labeltwo));
    
    labelone_numPixels = sum(sum(labelone));
    
    overlap_numPixels = sum(sum(overlap));

    % SET THRESHOLD on STIMULATED CASE
    
    % Save data from each section 4/17/2014
    
    set(handles.dataTable,'ColumnName',{handles.CLch{1,2},handles.CLch{2,2},'Overlap'},...
    'ColumnWidth',{60 60 55});
    
    currentData = get(handles.dataTable,'Data');
    currentData{imI,1} = labelone_numPixels;
    currentData{imI,2} = labeltwo_numPixels;
    currentData{imI,3} = overlap_numPixels;
    set(handles.dataTable,'Data',currentData);
    
    handles.pixelInfo.Image = invertImInterest;
    handles.pixelInfo.labeloneImage = labelone;
    handles.pixelInfo.labeloneImageP = labelonePolyCut;
    handles.pixelInfo.labeltwoImageP = labeltwoPolyCut;
    handles.pixelInfo.labeltwoImage = labeltwo;
    handles.pixelInfo.overlayImage = overlap;
    handles.pixelInfo.labeloneName = handles.CLch{1,2};
    handles.pixelInfo.labeloneRatio = labeloneRatio;
    handles.pixelInfo.labeloneArea = labeloneArea;
    handles.pixelInfo.labelone_numPixels = labelone_numPixels;
    handles.pixelInfo.labeltwoName = handles.CLch{2,2};
    handles.pixelInfo.labeltwoRatio = labeltwoRatio;
    handles.pixelInfo.labeltwoArea = labeltwoArea;
    handles.pixelInfo.labeltwo_numPixels = labeltwo_numPixels;
    handles.pixelInfo.imageID = imageNames{imI};
    
    handles.PixelDataOut.OD{imI} = handles.pixelInfo;
    
end


set(handles.fnameBox,'String','')
set(handles.expOpts,'Enable','on')
cla(handles.imDisplay)
set(handles.mesText,'String','EXPORT YOUR DATA to EXCEL');


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

        saveDir = uigetdir;
        cd(saveDir);
       
        sectionNum = cell(length(handles.FileNames),1);
        labelonePC = zeros(length(handles.FileNames),1);
        labeltwoPC = zeros(length(handles.FileNames),1);
        for sei = 1:length(handles.FileNames)
            sectionNum{sei} = handles.FileNames{sei};
            labelonePC(sei) = handles.PixelDataOut.OD{1,sei}.labelone_numPixels;
            labeltwoPC(sei) = handles.PixelDataOut.OD{1,sei}.labeltwo_numPixels;
        end
        
        DS = dataset(sectionNum, labelonePC, labeltwoPC, 'VarNames',...
            {'Section',handles.PixelDataOut.OD{1,1}.labeloneName,handles.PixelDataOut.OD{1,1}.labeltwoName});
        
        %%%% INPUT NAME
        
        saveFname = inputdlg('Choose a savename','Save Name',1,{'case 1'});
        
        filename = strcat(char(saveFname),'.xlsx');
        
        export(DS,'XLSfile',filename);

    case 'No'
        return
end



% Export to Matlab---------------------------------------------------------
function expMatlab_Callback(hObject, eventdata, handles)
% hObject    handle to expMatlab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exitquest = questdlg('Are you sure you want EXPORT to MATLAB?','Export?',...
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

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.pixNum,'checked'),'on')
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

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.pixNum,'checked'),'on')
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

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.pixNum,'checked'),'on')
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

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.pixNum,'checked'),'on')
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

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.pixNum,'checked'),'on')
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

if strcmp(get(handles.optDen,'checked'),'on') || strcmp(get(handles.pixNum,'checked'),'on')
    set(handles.mesText,'String','Draw Polygon');
elseif strcmp(get(handles.stAnaly,'checked'),'off')
    set(handles.mesText,'String','Choose Analysis START From Options');
else
    set(handles.mesText,'String','Choose Analysis Option From Drop Down Menu');
end
