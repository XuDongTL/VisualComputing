function varargout = homography(varargin)
% HOMOGRAPHY MATLAB code for homography.fig
%      HOMOGRAPHY, by itself, creates a new HOMOGRAPHY or raises the existing
%      singleton*.
%
%      H = HOMOGRAPHY returns the handle to a new HOMOGRAPHY or the handle to
%      the existing singleton*.
%
%      HOMOGRAPHY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOMOGRAPHY.M with the given input arguments.
%
%      HOMOGRAPHY('Property','Value',...) creates a new HOMOGRAPHY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before homography_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to homography_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help homography

% Last Modified by GUIDE v2.5 19-Sep-2017 14:25:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @homography_OpeningFcn, ...
                   'gui_OutputFcn',  @homography_OutputFcn, ...
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


% --- Executes just before homography is made visible.
function homography_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to homography (see VARARGIN)

% Choose default command line output for homography
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes homography wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = homography_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in importLeftImage.
function importLeftImage_Callback(hObject, eventdata, handles)
% hObject    handle to importLeftImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' });  
if filename~=0
    leftFilename = filename;
    setappdata(0, 'leftChessFIlename', leftFilename);
    im = imread(filename);
    axes(handles.axes1);
    imshow(im);
    setappdata(0, 'leftChess', im);
else
    disp('No image selected');
end

% --- Executes on button press in importRightImage.
function importRightImage_Callback(hObject, eventdata, handles)
% hObject    handle to importRightImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' });  
if filename~=0
    rightFilename = filename;
    setappdata(0, 'rightChessFIlename', rightFilename);
    im = imread(filename);
    axes(handles.axes2);
    imshow(im);
    setappdata(0, 'rightChess', im);
else
    disp('No image selected');
end

% --- Executes on button press in compute.
function compute_Callback(hObject, eventdata, handles)
% hObject    handle to compute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Computing homography and transform image.');
p1 = getappdata(0, 'p1'); 
p2 = getappdata(0, 'p2'); 
imLeft = getappdata(0, 'leftChess');
imRight = getappdata(0, 'rightChess');

h1 = solveHomography(p1, p2);
imout = warpImage(imLeft, h1);
axes(handles.axes1);
imshow(imout);
assignin('base','h1',h1);  % set data to workspace

h2 = solveHomography(p2, p1); % the other way
imout2 = warpImage(imRight, h2);
axes(handles.axes2);
imshow(imout2);
assignin('base','h2',h2);  % set data to workspace


% --- Executes on button press in selectPointLeft.
function selectPointLeft_Callback(hObject, eventdata, handles)
% hObject    handle to selectPointLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Please Select 4 Points from Left Image to Compute Homography.');
axes(handles.axes1);
im = getappdata(0, 'leftChess');
x1 = zeros(4,1); y1 = zeros(4,1); % define to store x y positions
for i = 1:1:4
    [x,y] = ginput(1);
    x1(i) = x; y1(i) = y;
    color = {'red','green','blue','yellow'};
    im = insertMarker(im,[x y],'*','color',color(i),'size',10);
    im = insertText(im, [x y], num2str(i), 'FontSize',round(size(im,2)/30), ...
        'BoxColor',color(i),'BoxOpacity',0.4,'TextColor','white');
    imshow(im);
end
p1 = [x1,y1];
setappdata(0,'p1', p1);  % set data in app
assignin('base','p1',p1);  % set data to workspace

% --- Executes on button press in selectPointRight.
function selectPointRight_Callback(hObject, eventdata, handles)
% hObject    handle to selectPointRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Please Select 4 Points from Left Image to Compute Homography.');
axes(handles.axes2);
axes(handles.axes1);
im = getappdata(0, 'rightChess');
x2 = zeros(4,1); y2 = zeros(4,1); % define to store x y positions
for i = 1:1:4
    [x,y] = ginput(1);
    x2(i) = x; y2(i) = y;
    color = {'red','green','blue','yellow'};
    im = insertMarker(im,[x y],'*','color',color(i),'size',10);
    im = insertText(im, [x y], num2str(i), 'FontSize',round(size(im,2)/30), ...
        'BoxColor', color(i),'BoxOpacity',0.4,'TextColor','white');
    imshow(im);
end
p2 = [x2,y2];
setappdata(0,'p2', p2);  % set data in app
assignin('base','p2',p2);  % set data to workspace
