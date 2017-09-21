function varargout = part4(varargin)
% PART4 MATLAB code for part4.fig
%      PART4, by itself, creates a new PART4 or raises the existing
%      singleton*.
%
%      H = PART4 returns the handle to a new PART4 or the handle to
%      the existing singleton*.
%
%      PART4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PART4.M with the given input arguments.
%
%      PART4('Property','Value',...) creates a new PART4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before part4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to part4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help part4

% Last Modified by GUIDE v2.5 19-Sep-2017 13:48:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @part4_OpeningFcn, ...
                   'gui_OutputFcn',  @part4_OutputFcn, ...
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


% --- Executes just before part4 is made visible.
function part4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to part4 (see VARARGIN)

% Choose default command line output for part4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes part4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = part4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
q1 = getappdata(0, 'q1'); 
q2 = getappdata(0, 'q2'); 
im = getappdata(0, 'rightImage');

hlr = solveHomography(q1, q2);
hrl = solveHomography(q2, q1); % change second image to first image
imout2 = warpImage(im, hrl);
axes(handles.axes2);
imshow(imout2);
assignin('base','hlr',hlr);
assignin('base','hrl',hrl);  % set data to workspace
assignin('base','tranImg',imout2);

% --- Executes on button press in importLeftImage.
function importLeftImage_Callback(hObject, eventdata, handles)
% hObject    handle to importLeftImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' });  
if filename~=0
    leftFilename = filename;
    setappdata(0, 'leftFIlename', leftFilename);
    im = imread(filename);
    axes(handles.axes1);
    imshow(im);
    setappdata(0, 'leftImage', im);
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
    setappdata(0, 'rightFilename', rightFilename);
    im = imread(filename);
    axes(handles.axes2);
    imshow(im);
    setappdata(0, 'rightImage', im);
else
    disp('No image selected');
end


% --- Executes on button press in selectPointLeft.
function selectPointLeft_Callback(hObject, eventdata, handles)
% hObject    handle to selectPointLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Please Select 4 Points from Left Image to Compute Homography.');
axes(handles.axes1);
im = getappdata(0, 'leftImage');
x1 = zeros(4,1); y1 = zeros(4,1); % define to store x y positions
for i = 1:1:4
    [x,y] = ginput(1);
    x1(i) = x; y1(i) = y;
    color = {'red','green','blue','white'};
    im = insertMarker(im, [x y],'*','color',color(i),'size',6);
    im = insertText(im, [x y], num2str(i), 'FontSize',18,'BoxColor', ...
        color(i),'BoxOpacity',0.4,'TextColor','white');
    imshow(im);
end
q1 = [x1,y1];
setappdata(0,'q1', q1);  % set data in app
assignin('base','q1',q1);  % set data to workspace


% --- Executes on button press in selectPointsRight.
function selectPointsRight_Callback(hObject, eventdata, handles)
% hObject    handle to selectPointsRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Please Select 4 Points from Left Image to Compute Homography.');
axes(handles.axes2);
axes(handles.axes1);
im = getappdata(0, 'rightImage');
x2 = zeros(4,1); y2 = zeros(4,1); % define to store x y positions
for i = 1:1:4
    [x,y] = ginput(1);
    x2(i) = x; y2(i) = y;
    color = {'red','green','blue','white'};
    im = insertMarker(im,[x y],'*','color',color(i),'size',6);
    im = insertText(im, [x y], num2str(i), 'FontSize',18,'BoxColor', ...
        color(i),'BoxOpacity',0.4,'TextColor','white');
    imshow(im);
end
q2 = [x2,y2];
setappdata(0,'q2', q2);  % set data in app
assignin('base','q2',q2);  % set data to workspace
