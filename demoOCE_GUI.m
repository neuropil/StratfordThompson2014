function varargout = demoOCE_GUI(varargin)
% DEMOOCE_GUI MATLAB code for demoOCE_GUI.fig
%      DEMOOCE_GUI, by itself, creates a new DEMOOCE_GUI or raises the existing
%      singleton*.
%
%      H = DEMOOCE_GUI returns the handle to a new DEMOOCE_GUI or the handle to
%      the existing singleton*.
%
%      DEMOOCE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMOOCE_GUI.M with the given input arguments.
%
%      DEMOOCE_GUI('Property','Value',...) creates a new DEMOOCE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before demoOCE_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to demoOCE_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help demoOCE_GUI

% Last Modified by GUIDE v2.5 04-Mar-2014 19:37:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @demoOCE_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @demoOCE_GUI_OutputFcn, ...
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


% --- Executes just before demoOCE_GUI is made visible.
function demoOCE_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to demoOCE_GUI (see VARARGIN)

% Choose default command line output for demoOCE_GUI
handles.output = hObject;


set(handles.axes1,'XTickLabel',[],'YTickLabel',[],...
    'XTick',[],'YTick',[]);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes demoOCE_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = demoOCE_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd('C:\Users\Dr. JT\Documents\GitHub\OpticalEstimator\testImages\OpticalDTest')
handles.Image = imread('130929a_c1_comb.tif');
axes(handles.axes1)
imshow(handles.Image)

guidata(hObject, handles);




% --- Executes on button press in draw.
function draw_Callback(hObject, eventdata, handles)
% hObject    handle to draw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load Image
axes(handles.axes1);
hold on;
[dim1,dim2,~] = size(handles.Image);
blankImage = uint8(zeros(dim1,dim2,3));
blankImage(:,:,3) = handles.Image(:,:,3);
chan2disp = blankImage;
imshow(chan2disp)


% Draw Polygon

% axes(handles.axes1);
[~, handles.PolyXC, handles.PolyYC] = roipoly(chan2disp);
plot(handles.PolyXC, handles.PolyYC,'-y');
% Calculate polygon area
polyArea = polyarea(handles.PolyXC, handles.PolyYC);
% Calculate circle with area 1/4 the area of polygon
radius = sqrt(polyArea/pi);
handles.fourRad = radius/4;


% Create Cross Hair
% User select three sample points within polygon
[handles.XCoords, handles.YCoords] = ginput(3);
% Round coordinates
handles.XCoords  = round(handles.XCoords);
handles.YCoords  = round(handles.YCoords);

guidata(hObject, handles);




% --- Executes on button press in circle.
function circle_Callback(hObject, eventdata, handles)
% hObject    handle to circle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[dim1,dim2,~] = size(handles.Image);

% EITHER GET THE MEAN FROM THE POLYGON OR THE BOXES


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

injThreshImage = handles.Image(:,:,1);

pixelInfo = cell(3,1);
pixelsPerbox = cell(1,3);
hold on
boxPlotsS = cell(1,3);
for sti = 1:3
    samplebox = roipoly(dim1,dim2,sYcoords{1,sti},sXcoords{1,sti});
    square_mask = poly2mask(sXcoords{1,sti},sYcoords{1,sti},dim1,dim2);
    pixelsPerbox{1,sti} = injThreshImage(square_mask);
    [Bi, ~] = bwboundaries(samplebox,'noholes');
    boxIndices = cell2mat(Bi);
    boxPlotsS{1,sti} = boxIndices;
    pixelInfo{sti,1} = regionprops(square_mask,injThreshImage,'MaxIntensity','WeightedCentroid','MeanIntensity','PixelValues');
end

hold on
for ip = 1:3
    plot(boxPlotsS{1,ip}(:,1),boxPlotsS{1,ip}(:,2),'y')
end


guidata(hObject, handles);













% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes1)
clc
guidata(hObject, handles);


% --- Executes on button press in restart.
function restart_Callback(hObject, eventdata, handles)
% hObject    handle to restart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.figure1);
clc
demoOCE_GUI;
