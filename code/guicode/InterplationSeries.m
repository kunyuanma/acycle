function varargout = InterplationSeries(varargin)
% INTERPLATIONSERIES MATLAB code for InterplationSeries.fig
%      INTERPLATIONSERIES, by itself, creates a new INTERPLATIONSERIES or raises the existing
%      singleton*.
%
%      H = INTERPLATIONSERIES returns the handle to a new INTERPLATIONSERIES or the handle to
%      the existing singleton*.
%
%      INTERPLATIONSERIES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERPLATIONSERIES.M with the given input arguments.
%
%      INTERPLATIONSERIES('Property','Value',...) creates a new INTERPLATIONSERIES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before InterplationSeries_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to InterplationSeries_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help InterplationSeries

% Last Modified by GUIDE v2.5 23-Feb-2020 10:20:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InterplationSeries_OpeningFcn, ...
                   'gui_OutputFcn',  @InterplationSeries_OutputFcn, ...
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


% --- Executes just before InterplationSeries is made visible.
function InterplationSeries_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to InterplationSeries (see VARARGIN)

% Choose default command line output for InterplationSeries
handles.output = hObject;
handles.listbox_acmain = varargin{1}.listbox_acmain; % save path
handles.unit = varargin{1}.unit;
handles.edit_acfigmain_dir = varargin{1}.edit_acfigmain_dir;

%
handles.hmain = gcf;
set(handles.hmain,'Name', 'Acycle: Interpolation Plus')
% GUI settings
set(0,'Units','normalized') % set units as normalized
h=get(gcf,'Children');  % get all content
h1=findobj(h,'FontUnits','norm');  % find all font units as points
set(h1,'FontUnits','points','FontSize',11.5);  % set as norm
h2=findobj(h,'FontUnits','points');  % find all font units as points
set(h2,'FontUnits','points','FontSize',11.5);  % set as norm

set(handles.hmain,'position',[0.38,0.2,0.6,0.25]) % set position
set(handles.uipanel1,'position',[0.025,0.286,0.947,0.649]) % Data
set(handles.text2,'position',[0.015,0.849,0.24,0.15])
set(handles.text3,'position',[0.015,0.28,0.24,0.15])
set(handles.edit1,'position',[0.125,0.547,0.88,0.208])
set(handles.edit2,'position',[0.125,0.03,0.88,0.208])

set(handles.pushbutton3,'position',[0.015,0.557,0.1,0.208]) % plot
set(handles.pushbutton4,'position',[0.015,0.03,0.1,0.208]) % plot

set(handles.pushbutton1,'position',[0.1,0.1,0.16,0.168]) % plot
set(handles.pushbutton2,'position',[0.5,0.1,0.25,0.168]) % plot


% Read list
GETac_pwd;
set(handles.edit1,'string',ac_pwd)
set(handles.edit2,'string',ac_pwd)
% Default settings
handles.nplot = 2;  % number of data series
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes InterplationSeries wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = InterplationSeries_OutputFcn(hObject, eventdata, handles) 
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
try
    handles.plot_s{1} = get(handles.edit1,'string');
    handles.plot_s{2} = get(handles.edit2,'string');
    guidata(hObject, handles);
    PlotAdv(handles);
catch
    errordlg('Selected Series Format NOT Supported or NOT Existed')
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pre_dirML = pwd;
handles.plot_s{1} = get(handles.edit1,'string');
handles.plot_s{2} = get(handles.edit2,'string');
% dat1: reference
% dat2: target
try
    dat1 = load(handles.plot_s{1});
    dat2 = load(handles.plot_s{2});
catch
    fid = fopen(handles.plot_s{1});
    data_ft = textscan(fid,'%f%f','EmptyValue', Inf);
    dat1 = cell2mat(data_ft);
    fclose(fid);
    fid = fopen(handles.plot_s{2});
    data_ft = textscan(fid,'%f%f','EmptyValue', Inf);
    dat2 = cell2mat(data_ft);
    fclose(fid);
end

xmin = min( min(dat1(:,1), min(dat2(:,1))));
xmax = max( max(dat1(:,1), max(dat2(:,1))));

dat2int2 = interp1(dat2(:,1),dat2(:,2),dat1(:,1));
dat2int  = [dat1(:,1),dat2int2];

figure;
set(gcf,'Name', 'Acycle: Interpolation Plus Results')
subplot(3,1,1)

plot(dat1(:,1),dat1(:,2),'b--o')
xlim( [xmin, xmax] )
title('Reference')
subplot(3,1,2)
plot(dat2(:,1),dat2(:,2),'r-s')
xlim( [xmin, xmax] )
title('Target')
subplot(3,1,3)
plot(dat2int(:,1),dat2int(:,2),'r-o')
xlim( [xmin, xmax] )
xlabel([handles.unit])
title('Target Interpolated')

CDac_pwd; % cd ac_pwd dir
[~,name1,~] = fileparts(handles.plot_s{1});
[~,name2,ext2] = fileparts(handles.plot_s{2});
name1 = [name2,'-IntP-',name1,ext2];
dlmwrite(name1, dat2int, 'delimiter', ',', 'precision', 9);
d = dir; %get files
set(handles.listbox_acmain,'String',{d.name},'Value',1) %set string
refreshcolor;
cd(pre_dirML); % return to matlab view folder

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pre_dirML = pwd;
CDac_pwd; % cd ac_pwd dir
[file,path] = uigetfile({'*.*',  'All Files (*.*)'},...
                        'Select a Reference Series');
if isequal(file,0)
    disp('User selected Cancel')
else
    set(handles.edit1,'string',fullfile(path,file))
end
cd(pre_dirML); 
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pre_dirML = pwd;
CDac_pwd; % cd ac_pwd dir
[file,path] = uigetfile({'*.*',  'All Files (*.*)'},...
                        'Select a Reference Series');
if isequal(file,0)
    disp('User selected Cancel')
else
    set(handles.edit2,'string',fullfile(path,file))
end
cd(pre_dirML); 
% Update handles structure
guidata(hObject, handles);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
