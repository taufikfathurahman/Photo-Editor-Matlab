function varargout = photo_editor(varargin)
% PHOTO_EDITOR MATLAB code for photo_editor.fig
%      PHOTO_EDITOR, by itself, creates a new PHOTO_EDITOR or raises the existing
%      singleton*.
%
%      H = PHOTO_EDITOR returns the handle to a new PHOTO_EDITOR or the handle to
%      the existing singleton*.
%
%      PHOTO_EDITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHOTO_EDITOR.M with the given input arguments.
%
%      PHOTO_EDITOR('Property','Value',...) creates a new PHOTO_EDITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before photo_editor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to photo_editor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
global image;
global editImage;
global actions;
global actionsIndex;
global brightness;
global brightnessIndex;
global contrast;
global contrastIndex;
global resolution;
global resolutionIndex;
global rotation;
global rotationIndex;
global resize;
global resizeIndex;
global flippedH;
global flippedV;
global isCropped;
global croppedImage;

global colorType;
global imageTransformsIndex;
global imageTransforms;

global mappedImage;
global isMapped;

% Edit the above text to modify the response to help photo_editor

% Last Modified by GUIDE v2.5 12-Apr-2019 19:48:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @photo_editor_OpeningFcn, ...
                   'gui_OutputFcn',  @photo_editor_OutputFcn, ...
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


% --- Executes just before photo_editor is made visible.
function photo_editor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to photo_editor (see VARARGIN)

% Choose default command line output for photo_editor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes photo_editor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = photo_editor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
global image ;
global editImage;
global actionsIndex;
global brightness;
global brightnessIndex;
global contrast;
global contrastIndex;
global resolutionIndex;
global resolution;
global rotation;
global rotationIndex;
global resize;
global resizeIndex;
global flippedH;
global flippedV;
global isCropped;
global croppedImage;
global colorType;
global indexedY;
global indexedMap;
global imageTransformsIndex;

global mappedImage;
global isMapped;


global height ;
global width;
global whIndex;


global originalHeight ;
global originalWidth;

[filename filepath]=uigetfile({'*.jpg';'*.png';'*.bmp'; '*.tif'},'File Selector');
raw = strcat(filepath,filename);
info = imfinfo(raw);
image = imread(raw);
originalWidth = info.Height;
originalHeight = info.Width;
width(1) = originalHeight;
height(1) = originalWidth;
whIndex = 1;
editImage = image;
actionsIndex = 0;
brightness(1) = 0;
brightnessIndex = 1;
contrast(1) = 0;
contrastIndex = 1;
resolution(1) = 100;
resolutionIndex = 1;
rotationIndex = 1;
rotation(rotationIndex) = 0;
resize(1) = 100;
resizeIndex = 1;
flippedH = 0;
flippedV = 0;
isCropped = 0;
croppedImage = image;
colorType = info(1).ColorType;
mappedImage = image;
isMapped = 0;

imageTransformsIndex = 0;

isIndexed = strcmp(colorType, 'indexed');
if isIndexed == 1
    [indexedY, indexedMap] = imread(raw);
end

set(handles.image_type_txt, 'string', colorType);
axes(handles.axes1);
imshow(image);
axes(handles.axes2);
imshow(image);

set(handles.photo_width,'string',width);
set(handles.photo_height,'string',height);

isGrayscale = strcmp(colorType, 'grayscale');
isTruecolor = strcmp(colorType, 'truecolor');
isIndexed = strcmp(colorType, 'indexed');

if isGrayscale == 1
    set(handles.gray2rgb, 'Value', 1.0);
elseif isTruecolor == 1
    set(handles.rgb2gray, 'Value', 1.0);
end
% hObject    handle to browse_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function photo_width_Callback(hObject, eventdata, handles)
% hObject    handle to photo_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of photo_width as text
%        str2double(get(hObject,'String')) returns contents of photo_width as a double
global actions;
global actionsIndex;
global width;
global height;
global whIndex;

h = str2double(get(handles.photo_width, 'string'));
w = str2double(get(handles.photo_height, 'string'));
if (~isempty(w) && ~isempty(h))
    if(h<6000 || w<6000)
        whIndex = whIndex + 1;
        actionsIndex = actionsIndex + 1;
        actions(actionsIndex) = 12;
        width(whIndex) = w;
        height(whIndex) = h;
        edit(handles);
    end
end

% --- Executes during object creation, after setting all properties.
function photo_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to photo_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function photo_height_Callback(hObject, eventdata, handles)
% hObject    handle to photo_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of photo_height as text
%        str2double(get(hObject,'String')) returns contents of photo_height as a double
global actions;
global actionsIndex;
global width;
global height;
global whIndex;

h = str2double(get(handles.photo_width, 'string'));
w = str2double(get(handles.photo_height, 'string'));
if (~isempty(w) && ~isempty(h))
    if(h<6000 || w<6000)
        whIndex = whIndex + 1;
        actionsIndex = actionsIndex + 1;
        actions(actionsIndex) = 12;
        width(whIndex) = w;
        height(whIndex) = h;
        edit(handles);
    end
end

% --- Executes during object creation, after setting all properties.
function photo_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to photo_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_left.
function pushbutton_left_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global actions;
global actionsIndex;
global rotation;
global rotationIndex;

angle = get(handles.rotation_edit,'Value');
angle = angle - 5;
if angle >= 0
    rotationIndex = rotationIndex + 1;
    rotation(rotationIndex) = angle;
    actionsIndex = actionsIndex + 1;
    actions(actionsIndex) = 4;
    set(handles.rotation_edit,'string',angle);
    set(handles.rotation_edit,'Value',angle);
    edit(handles);
end


function rotation_edit_Callback(hObject, eventdata, handles)
% hObject    handle to rotation_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotation_edit as text
%        str2double(get(hObject,'String')) returns contents of rotation_edit as a double


% --- Executes during object creation, after setting all properties.
function rotation_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotation_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_right.
function pushbutton_right_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global actions;
global actionsIndex;
global rotation;
global rotationIndex;

angle = get(handles.rotation_edit,'Value');
angle = angle + 5;
if angle <= 360
    rotationIndex = rotationIndex + 1;
    rotation(rotationIndex) = angle;
    actionsIndex = actionsIndex + 1;
    actions(actionsIndex) = 4;
    set(handles.rotation_edit,'string',angle);
    set(handles.rotation_edit,'Value',angle);
    edit(handles);
end

% --- Executes on button press in checkbox_flip_vertical.
function checkbox_flip_vertical_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_flip_vertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_flip_vertical
global flippedV;

if flippedV == 0
    flippedV = 1;
else
    flippedV = 0;
end

edit(handles);

% --- Executes on button press in checkbox_flip_horizontal.
function checkbox_flip_horizontal_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_flip_horizontal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_flip_horizontal
global flippedH;

if flippedH == 0
    flippedH = 1;
else
    flippedH = 0;
end

edit(handles);

% --- Executes on button press in pushbutton_brightness_l.
function pushbutton_brightness_l_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_brightness_l (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global actions;
global actionsIndex;
global brightness;
global brightnessIndex;

k =get(handles.edit5,'Value');
if k > -6
    k = (k - 1);
    set(handles.edit5,'Value',k);
    set(handles.edit5,'string',k);
    brightnessIndex = brightnessIndex + 1;
    brightness(brightnessIndex) = k;
    actionsIndex = actionsIndex + 1;
    actions(actionsIndex) = 1;
    edit(handles);
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_brightness_r.
function pushbutton_brightness_r_Callback(hObject, eventdata, handles)
global actionsIndex;
global actions;
global brightness;
global brightnessIndex;

k =get(handles.edit5,'Value');
if k < 6
    k = (k + 1);
    set(handles.edit5,'Value',k);
    set(handles.edit5,'string',k);
    brightnessIndex = brightnessIndex + 1;
    brightness(brightnessIndex) = k;
    actionsIndex = actionsIndex + 1;
    actions(actionsIndex) = 1;
    edit(handles);
end
% hObject    handle to pushbutton_brightness_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_contrast_l.
function pushbutton_contrast_l_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_contrast_l (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global actions;
global actionsIndex;
global contrast;
global contrastIndex;

k =get(handles.edit6,'Value');
if k > -10
    k = (k - 1);
    set(handles.edit6,'Value',k);
    set(handles.edit6,'string',k);
    contrastIndex = contrastIndex + 1;
    contrast(contrastIndex) = k;
    actionsIndex = actionsIndex + 1;
    actions(actionsIndex) = 2;
    edit(handles);
end


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_contrast_r.
function pushbutton_contrast_r_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_contrast_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global actions;
global actionsIndex;
global contrast;
global contrastIndex;

k = get(handles.edit6,'Value');
if k < 10
    k = (k + 1);
    set(handles.edit6,'Value',k);
    set(handles.edit6,'string',k);
    contrastIndex = contrastIndex + 1;
    contrast(contrastIndex) = k;
    actionsIndex = actionsIndex + 1;
    actions(actionsIndex) = 2;
    edit(handles);
end

% --- Executes on button press in apply_color_btn.
function apply_color_btn_Callback(hObject, eventdata, handles)
global imageTransformsIndex;
global imageTransforms;
global actions;
global actionsIndex;

u = get(get(handles.image_type_group,'SelectedObject'), 'string');
switch u
    case 'RGB to Gray'
        imageTransformsIndex = imageTransformsIndex + 1;
        imageTransforms(imageTransformsIndex) = 8;
        actionsIndex = actionsIndex + 1;
        actions(actionsIndex) = 8;
    case 'Gray to RGB'
        imageTransformsIndex = imageTransformsIndex + 1;
        imageTransforms(imageTransformsIndex) = 9;
        actionsIndex = actionsIndex + 1;
        actions(actionsIndex) = 9;
end
edit(handles);
% hObject    handle to apply_color_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in color_map_menu.
function color_map_menu_Callback(hObject, eventdata, handles)
% hObject    handle to color_map_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns color_map_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from color_map_menu
global isMapped;

isMapped = 1;

edit(handles);

% --- Executes during object creation, after setting all properties.
function color_map_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to color_map_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in image_type_group.
function image_type_group_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in image_type_group 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in crop_button.
function crop_button_Callback(hObject, eventdata, handles)
% hObject    handle to crop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isCropped;
global image;
global croppedImage;
isCropped = 1;
axes(handles.axes1);
croppedImage = imcrop(image);
edit(handles);
