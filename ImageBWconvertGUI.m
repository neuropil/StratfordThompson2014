function varargout = ImageBWconvertGUI(varargin)
% IMAGEBWCONVERTGUI MATLAB code for ImageBWconvertGUI.fig
%      IMAGEBWCONVERTGUI, by itself, creates a new IMAGEBWCONVERTGUI or raises the existing
%      singleton*.
%
%      H = IMAGEBWCONVERTGUI returns the handle to a new IMAGEBWCONVERTGUI or the handle to
%      the existing singleton*.
%
%      IMAGEBWCONVERTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEBWCONVERTGUI.M with the given input arguments.
%
%      IMAGEBWCONVERTGUI('Property','Value',...) creates a new IMAGEBWCONVERTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageBWconvertGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageBWconvertGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageBWconvertGUI

% Last Modified by GUIDE v2.5 21-Apr-2014 17:02:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageBWconvertGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageBWconvertGUI_OutputFcn, ...
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


% --- Executes just before ImageBWconvertGUI is made visible.
function ImageBWconvertGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageBWconvertGUI (see VARARGIN)

% Choose default command line output for ImageBWconvertGUI
handles.output = hObject;

set(handles.convert,'Enable','off');
set(handles.create,'Enable','off');
set(handles.imageS,'Enable','off');
set(handles.bimages,'Value',0);
set(handles.simages,'Value',0);
set(handles.message,'String','Select Batch Option');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageBWconvertGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImageBWconvertGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in convert.
function convert_Callback(hObject, eventdata, handles)
% hObject    handle to convert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.convert,'Enable','off');

set(handles.message,'String','Working...');

handles.binaryImages = binaryConvert(handles.selectionID, handles.bchoice);

set(handles.message,'String','');

set(handles.create,'Enable','on');
set(handles.message,'String','Select Create Image');

guidata(hObject, handles);


% --- Executes on button press in create.
function create_Callback(hObject, eventdata, handles)
% hObject    handle to create (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

binaryImages = handles.binaryImages;

if ischar(binaryImages.filenames);
    binaryImages.filenames = cellstr(binaryImages.filenames);
    binaryImages.images = {binaryImages.images};
end

imageNames = binaryImages.filenames;
cd(binaryImages.saveLoc)
for iims = 1:length(imageNames);
    cd(binaryImages.saveLoc)

    imwrite(binaryImages.images{iims},binaryImages.filenames{iims})
end

set(handles.batchPanel,'Visible','on');
set(handles.create,'Enable','off');
    
guidata(hObject, handles);

% --- Executes on selection change in imageS.
function imageS_Callback(hObject, eventdata, handles)
% hObject    handle to imageS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns imageS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imageS

selection = get(hObject,'Value');
selections = cellstr(get(hObject,'String'));

if selection == 1;
    set(handles.convert,'Enable','off');
    set(handles.create,'Enable','off');
    return
else
    handles.selectionID = selections{selection};
    set(handles.convert,'Enable','on');
    set(handles.create,'Enable','off');
    set(handles.message,'String','Select Convert Image');
    set(handles.imageS,'Enable','off');
end




guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function imageS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in batchPanel.
function batchPanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in batchPanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

set(handles.imageS,'Enable','on');
set(handles.message,'String','Select Image Option');

newVal = get(eventdata.NewValue,'Tag');

switch newVal % Get Tag of selected object.
    case 'simages'
        handles.bchoice = false;
    case 'bimages'
        handles.bchoice = true;
    otherwise
        % Code for when there is no match.
end

set(handles.batchPanel,'Visible','off');

guidata(hObject, handles);
