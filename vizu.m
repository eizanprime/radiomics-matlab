function varargout = vizu(varargin)
% vizu MATLAB code for vizu.fig
%      vizu, by itself, creates a new vizu or raises the existing
%      singleton*.
%
%      H = vizu returns the handle to a new vizu or the handle to
%      the existing singleton*.
%
%      vizu('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in vizu.M with the given input arguments.
%
%      vizu('Property','Value',...) creates a new vizu or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vizu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vizu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vizu_OpeningFcn, ...
                   'gui_OutputFcn',  @vizu_OutputFcn, ...
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

% --- Executes just before vizu is made visible.
function vizu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vizu (see VARARGIN)

% Choose default command line output for vizu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

workSpace = evalin('base','who'); % load workspace
noms = char(workSpace);
ind = [];
for i = 1:size(noms,1)
    tmp = evalin('base', noms(i,:));
    
    if ndims(tmp)~=3
        ind = [ind, i];
    end
end
noms(ind, :) = [];

set(handles.BoiteRepertoire,'String',noms); % display in listbox

% --- Outputs from this function are returned to the command line.
function varargout = vizu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in BoiteRepertoire.
function BoiteRepertoire_Callback(hObject, eventdata, handles)
workSpace = evalin('base','who'); % load workspace
noms = char(workSpace);
ind = [];
for i = 1:size(noms,1)
    tmp = evalin('base', noms(i,:));
    
    if ndims(tmp)~=3
        ind = [ind, i];
    end
end
noms(ind, :) = [];

set(handles.BoiteRepertoire,'String',noms); % display in listbox

files = noms(get(hObject,'Value'),:); % load active variable name
filesValue = evalin('base', files); % load active variable values

set(handles.BoiteRepertoire,'UserData',filesValue);

sliderBound = [1, size(filesValue,3)];
sliderStep = [1, 1] / (sliderBound(2) - sliderBound(1)); % major and minor steps of 1

set(handles.slider1, 'Min', sliderBound(1));
set(handles.slider1, 'Max', sliderBound(2));
set(handles.slider1, 'SliderStep', sliderStep);
set(handles.slider1, 'Value', 1);

slice = round(get(handles.slider1, 'Value'));

h1 = handles.Visu;
imagesc(h1, filesValue(:,:,slice));
colormap(h1, 'gray');
colorbar(h1);
caxis(h1, [0 max(filesValue(:))]);
title(['Slice number ', num2str(slice)]);


% --- Executes during object creation, after setting all properties.
function BoiteRepertoire_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BoiteRepertoire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filesValue = get(handles.BoiteRepertoire,'UserData');
slice = round(get(handles.slider1, 'Value'));

h1 = handles.Visu;
imagesc(h1, filesValue(:,:,slice));
colormap(h1, 'gray');
colorbar(h1);
caxis(h1, [0 max(filesValue(:))]);
title(['Slice number ', num2str(slice)]);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
