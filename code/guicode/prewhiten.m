function varargout = prewhiten(varargin)
% PREWHITEN MATLAB code for prewhiten.fig
%      PREWHITEN, by itself, creates a new PREWHITEN or raises the existing
%      singleton*.
%
%      H = PREWHITEN returns the handle to a new PREWHITEN or the handle to
%      the existing singleton*.
%
%      PREWHITEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREWHITEN.M with the given input arguments.
%
%      PREWHITEN('Property','Value',...) creates a new PREWHITEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prewhiten_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prewhiten_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prewhiten

% Last Modified by GUIDE v2.5 12-Jun-2017 22:45:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prewhiten_OpeningFcn, ...
                   'gui_OutputFcn',  @prewhiten_OutputFcn, ...
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


% --- Executes just before prewhiten is made visible.
function prewhiten_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to prewhiten (see VARARGIN)
set(0,'Units','normalized') % set units as normalized
set(gcf,'units','norm') % set location
h=get(gcf,'Children');  % get all content
h1=findobj(h,'FontUnits','points');  % find all font units as points
set(h1,'FontUnits','norm');  % set as norm
handles.smooth_win = 0.35;  % windows for smooth 

handles.current_data = varargin{1}.current_data;
handles.data_name = varargin{1}.data_name;
xmin = min(handles.current_data(:,1));
xmax = max(handles.current_data(:,1));
handles.xrange = xmax -xmin; % length of data

handles.prewhiten_win = (xmax-xmin) * handles.smooth_win;
set(handles.edit10,'String', num2str(handles.prewhiten_win));
set(handles.slider4, 'Value', handles.smooth_win);
% Choose default command line output for prewhiten
handles.output = hObject;
handles.prewhiten_linear = 'notlinear';
handles.prewhiten_lowess = 'notlowess';
handles.prewhiten_rlowess = 'notrlowess';
handles.prewhiten_loess = 'notloess';
handles.prewhiten_rloess = 'notloess';
handles.prewhiten_polynomial2 = 'not2nd';
handles.prewhiten_polynomialmore = 'notmore';
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes prewhiten wait for user response (see UIRESUME)
% uiwait(handles.gui2);


% --- Outputs from this function are returned to the command line.
function varargout = prewhiten_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in prewhiten_select_popupmenu.
function prewhiten_select_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to prewhiten_select_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns prewhiten_select_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from prewhiten_select_popupmenu
handles.prewhiten_select_popupmenu = 'No_prewhiten';

str = get(hObject, 'String');
val = get(hObject,'Value');

% Set current data to the selected data set.
current_data1 = handles.prewhiten_data1(:,1);

switch str{val};
case 'No_prewhiten (black)' % User selects.
   prewhiten_s = 'No_prewhiten';
   current_data2 = handles.prewhiten_data1(:,2);
   trend = zeros(length(current_data2),1);
   nametype = 2;
case 'Linear (Yellow)' % User selects.
   prewhiten_s = 'Linear';
   current_data2 = handles.prewhiten_data1(:,3);
   trend = handles.prewhiten_data1(:,4);
   nametype = 1;
case 'LOWESS  (Green)' % User selects.
   prewhiten_s = 'LOWESS';
   current_data2 = handles.prewhiten_data2(:,1);
   trend = handles.prewhiten_data2(:,2);
   nametype = 0;
case 'rLOWESS (Blue)' % User selects.
   prewhiten_s = 'rLOWESS';
   current_data2 = handles.prewhiten_data2(:,3);
   trend = handles.prewhiten_data2(:,4);
   nametype = 0;
case 'LOESS      (Red)' % User selects.
   prewhiten_s = 'LOESS';
   current_data2 = handles.prewhiten_data2(:,5);
   trend = handles.prewhiten_data2(:,6);
   nametype = 0;
case 'rLOESS     (Magenta)' % User selects.
   prewhiten_s = 'rLOESS';
   current_data2 = handles.prewhiten_data2(:,7);
   trend = handles.prewhiten_data2(:,8);
   nametype = 0;
case '2nd order (dashed red)' % User selects.
   prewhiten_s = '2nd';
   current_data2 = handles.prewhiten_data2(:,9);
   trend = handles.prewhiten_data2(:,10);
   nametype = 1;
case '3+ order (Dashed blue)' % User selects.
   prewhiten_s = '3+Order';
   current_data2 = handles.prewhiten_data2(:,11);
   trend = handles.prewhiten_data2(:,12);
   nametype = 1;
end

handles.prewhiten_select_popupmenu = prewhiten_s;
new_data = [current_data1,current_data2];
handles.new_data = new_data;
current_trend = [current_data1,trend];
win = handles.prewhiten_win;

handles.prewhiten_select_popupmenu = {};

% cd(handles.working_folder)
data_name = handles.data_name;
[~,dat_name,ext] = fileparts(data_name);
if nametype == 0
    handles.name1 = [dat_name,'-',num2str(win),'-',prewhiten_s,ext];
    name2 = [dat_name,'-',num2str(win),'-',prewhiten_s,'trend',ext];
else
    handles.name1 = [dat_name,'-',prewhiten_s,ext];
    name2 = [dat_name,'-',prewhiten_s,'trend',ext];
end
if nametype < 2
    CDac_pwd; % cd ac_pwd dir
    dlmwrite(handles.name1, new_data, 'delimiter', ',', 'precision', 9);
    dlmwrite(name2, current_trend, 'delimiter', ',', 'precision', 9);
    disp('Refresh main AC window for trend and detrended data')
    cd(pre_dirML); % return to matlab view folder
end
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function prewhiten_select_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prewhiten_select_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in prewhiten_lowess_checkbox.
function prewhiten_lowess_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to prewhiten_lowess_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prewhiten_lowess_checkbox
handles.prewhiten_lowess = get(handles.prewhiten_lowess_checkbox,'string');

prewhitenok = get(handles.prewhiten_lowess_checkbox,'Value');
if prewhitenok == 1
    set(handles.prewhiten_lowess_checkbox,'Enable','on')
else
    handles.prewhiten_lowess = 'notlowess';
end

guidata(hObject, handles);

% --- Executes on button press in prewhiten_rlowess_checkbox.
function prewhiten_rlowess_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to prewhiten_rlowess_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prewhiten_rlowess_checkbox
handles.prewhiten_rlowess = get(handles.prewhiten_rlowess_checkbox,'string');

prewhitenok = get(handles.prewhiten_rlowess_checkbox,'Value');
if prewhitenok == 1
    set(handles.prewhiten_linear_checkbox,'Enable','on')
else
    handles.prewhiten_rlowess = 'notrlowess';
end

guidata(hObject, handles);

% --- Executes on button press in prewhiten_loess_checkbox.
function prewhiten_loess_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to prewhiten_loess_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prewhiten_loess_checkbox
handles.prewhiten_loess = get(handles.prewhiten_loess_checkbox,'string');

prewhitenok = get(handles.prewhiten_loess_checkbox,'Value');
if prewhitenok == 1
    set(handles.prewhiten_linear_checkbox,'Enable','on')
else
    handles.prewhiten_loess = 'notloess';
end

guidata(hObject, handles);


% --- Executes on button press in prewhiten_rloess_checkbox.
function prewhiten_rloess_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to prewhiten_rloess_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prewhiten_rloess_checkbox
handles.prewhiten_rloess = get(handles.prewhiten_rloess_checkbox,'string');

prewhitenok = get(handles.prewhiten_rloess_checkbox,'Value');
if prewhitenok == 1
    set(handles.prewhiten_linear_checkbox,'Enable','on')
else
    handles.prewhiten_rloess = 'notloess';
end

guidata(hObject, handles);


function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
% read data
prewhiten_win_edit1 = str2double(get(hObject,'String'));
handles.prewhiten_win = prewhiten_win_edit1;
% smooth win 
handles.smooth_win = prewhiten_win_edit1/handles.xrange;  % windows for smooth 

prewhitenwinpercent = 100*(handles.smooth_win);

set(handles.edit11, 'String', num2str(prewhitenwinpercent));
set(handles.slider4, 'Value', handles.smooth_win);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prewhiten_linear_checkbox.
function prewhiten_linear_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to prewhiten_linear_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.prewhiten_linear = get(hObject,'string');
prewhitenok = get(hObject,'Value');
if prewhitenok == 1
    set(handles.prewhiten_pushbutton,'Enable','on')
else
    handles.prewhiten_linear = 'notlinear';
end

guidata(hObject, handles);


function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double
prewhiten_win_edit2 = str2double(get(hObject,'String'));

% smooth win 
handles.smooth_win = prewhiten_win_edit2/100;  % windows for smooth 

handles.prewhiten_win = handles.xrange * prewhiten_win_edit2/100;

set(handles.edit10, 'String', num2str(handles.prewhiten_win));
set(handles.slider4, 'Value', handles.smooth_win);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prewhiten_all_checkbox.
function prewhiten_all_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to prewhiten_all_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prewhiten_all_checkbox
prewhitenok = get(handles.prewhiten_all_checkbox,'Value');

if prewhitenok == 1
    set(handles.prewhiten_linear_checkbox,'Enable','on')
    set(handles.prewhiten_lowess_checkbox,'Value',1)
    set(handles.prewhiten_rlowess_checkbox,'Value',1)
    set(handles.prewhiten_linear_checkbox,'Value',1)
    set(handles.prewhiten_loess_checkbox,'Value',1)
    set(handles.prewhiten_rloess_checkbox,'Value',1)
    set(handles.checkbox11,'Value',1)
    set(handles.checkbox13,'Value',1)
    
    handles.prewhiten_linear = '1 order (Linear)';
    handles.prewhiten_polynomial2 = '2 order';
    handles.prewhiten_polynomialmore = 'more order';
    handles.prewhiten_lowess = 'LOWESS (Weighted Average)';
    handles.prewhiten_rlowess = 'rLOWESS';
    handles.prewhiten_loess = 'LOESS';
    handles.prewhiten_rloess = 'rLOESS';
end

guidata(hObject, handles);

% --- Executes on button press in prewhiten_clear_pushbutton.
function prewhiten_clear_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to prewhiten_clear_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.prewhiten_linear = 'notlinear';
handles.prewhiten_lowess = 'notlowess';
handles.prewhiten_rlowess = 'notrlowess';
handles.prewhiten_loess = 'notloess';
handles.prewhiten_rloess = 'notloess';
handles.prewhiten_polynomial2 = 'not2nd';
handles.prewhiten_polynomialmore = 'notmore';

% set checkbox
set(handles.prewhiten_lowess_checkbox,'Value',0)
set(handles.prewhiten_loess_checkbox,'Value',0)
set(handles.prewhiten_linear_checkbox,'Value',0)
set(handles.prewhiten_rlowess_checkbox,'Value',0)
set(handles.prewhiten_rloess_checkbox,'Value',0)
set(handles.prewhiten_all_checkbox,'Value',0)
set(handles.checkbox11,'Value',0)
set(handles.checkbox13,'Value',0)
set(handles.prewhiten_pushbutton,'Enable','off')
guidata(hObject, handles);

% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
win_ratio = get(hObject,'Value');

handles.prewhiten_win = handles.xrange * win_ratio;

handles.smooth_win = win_ratio;  % windows for smooth 

set(handles.edit10,'String',num2str(handles.prewhiten_win))
set(handles.edit11,'String',num2str(win_ratio*100))

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11
handles.prewhiten_polynomial2 = get(hObject,'string');
prewhitenok = get(hObject,'Value');
if prewhitenok == 1
    set(handles.prewhiten_linear_checkbox,'Enable','on')
else
    handles.prewhiten_polynomial2 = 'not2nd';
end

guidata(hObject, handles);

% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13
handles.prewhiten_polynomialmore = get(handles.edit23,'string');
prewhitenok = get(hObject,'Value');
if prewhitenok == 1
    set(handles.prewhiten_pushbutton,'Enable','on')
else
    handles.prewhiten_polynomialmore = 'notmore';
end
guidata(hObject, handles);


function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in prewhiten_pushbutton.
function prewhiten_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to prewhiten_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% current data for estimate trends
current_data = handles.current_data;
smooth_win = handles.smooth_win;

datax=current_data(:,1);
datay=current_data(:,2);
npts=length(datax);

if npts > 2000
    disp('>> Large dataset, wait ...')
    fwarndlg = warndlg('Large dataset, wait');
end

figure;
plot(datax,datay,'-k');
axis([min(datax) max(datax) min(datay) max(datay)])
fig = gcf;

hold on;
prewhiten_list = 1;
prewhiten = {};
prewhiten(prewhiten_list,1)={'No_prewhiten (black)'};

if strcmp(handles.prewhiten_linear,'1 order (Linear)')
    sdat=polyfit(datax,datay,1);
    datalinear=datax*sdat(1)+sdat(2);
    plot(datax,datalinear,'-y','Linewidth',1)
    prewhiten_list = prewhiten_list + 1;
    prewhiten(prewhiten_list,1) = {'Linear (Yellow)'};
end

if strcmp(handles.prewhiten_polynomial2,'2 order')
    sdat=polyfit(datax,datay,2);
    data2nd=polyval(sdat,datax);
    plot(datax,data2nd,':r','Linewidth',1)
    prewhiten_list = prewhiten_list + 1;
    prewhiten(prewhiten_list,1) = {'2nd order (dashed red)'};
end

polynomialmore = get(handles.checkbox13,'Value');
if polynomialmore == 1
    polynomial_value = str2double(get(handles.edit23,'String'));
    sdat=polyfit(datax,datay,polynomial_value);
    datamore=polyval(sdat,datax);
    plot(datax,datamore,'b-.','Linewidth',1)
    prewhiten_list = prewhiten_list + 1;
    prewhiten(prewhiten_list,1) = {'3+ order (Dashed blue)'};
end

if strcmp(handles.prewhiten_lowess,'LOWESS (Weighted Average)')
    datalowess=smooth(datax,datay, smooth_win,'lowess');
    plot(datax,datalowess,'-g','Linewidth',1)
    prewhiten_list = prewhiten_list + 1;
    prewhiten(prewhiten_list,1) = {'LOWESS  (Green)'};
end

if strcmp(handles.prewhiten_rlowess,'rLOWESS')
    datarlowess=smooth(datax,datay, smooth_win,'rlowess');
    plot(datax,datarlowess,':b','Linewidth',1)
    prewhiten_list = prewhiten_list + 1;
    prewhiten(prewhiten_list,1) = {'rLOWESS (Blue)'};
end

if strcmp(handles.prewhiten_loess,'LOESS')
    dataloess=smooth(datax,datay, smooth_win,'loess');
    plot(datax,dataloess,'--r','Linewidth',1)
    prewhiten_list = prewhiten_list + 1;
    prewhiten(prewhiten_list,1) = {'LOESS      (Red)'};
end

if strcmp(handles.prewhiten_rloess,'rLOESS')
    datarloess=smooth(datax,datay, smooth_win,'rloess');
    plot(datax,datarloess,'--m','Linewidth',1)
    prewhiten_list = prewhiten_list + 1;
    prewhiten(prewhiten_list,1) = {'rLOESS     (Magenta)'};
end

hold off
legendlist = [];
for j = 1: prewhiten_list
    legendlist = [legendlist, prewhiten(j,1)];
end
legend(legendlist)
% prepare data for export
if exist('datalinear')
else
    datalinear = zeros(npts,1);
end
if exist('data2nd')
else
    data2nd = zeros(npts,1);
end
if exist('datamore')
else
    datamore = zeros(npts,1);
end
if exist('datalowess')
else
    datalowess = (zeros(npts,1));
end
if exist('datarlowess')
else
    datarlowess = (zeros(npts,1));
end
if exist('dataloess')
else
    dataloess = (zeros(npts,1));
end
if exist('datarloess')
else
    datarloess = (zeros(npts,1));
end

fig.Color = [.95 .95 .95];
set(handles.prewhiten_select_popupmenu,'String',prewhiten,'Value',1);
% if isgraphics(fwarndlg)
%     close(fwarndlg);
% end
handles.prewhiten_data1 = [datax,datay,(datay-datalinear),datalinear];
handles.prewhiten_data2 = [(datay-datalowess),datalowess,(datay-datarlowess),datarlowess,...
    (datay-dataloess),dataloess,(datay-datarloess),datarloess,...
    (datay-data2nd),data2nd,(datay-datamore),datamore];
%set(handles.pushbutton14,'Enable','on')
guidata(hObject, handles);