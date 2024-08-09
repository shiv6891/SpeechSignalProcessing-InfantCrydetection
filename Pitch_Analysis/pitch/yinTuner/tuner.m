function varargout = tuner(varargin)
% TUNER A general purpose tuner
%      TUNER, by itself, runs the application. Tuner can identify the note 
%      of any sound, given to mic input, in real time. Can be used to tune 
%      any musical instrument in the 12TET system. For f0 estimation it 
%      uses the YIN implementation presented in the text.
%
%      Copyright (c) 2015 Dalatsis Antonios
%      ICSD, University of the Aegean


% Begin initialization - GUIDE auto generated code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tuner_OpeningFcn, ...
                   'gui_OutputFcn',  @tuner_OutputFcn, ...
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
% End initialization



% --- Executes just before tuner is made visible.
function tuner_OpeningFcn(hObject, eventdata, handles, varargin)
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tuner (see VARARGIN)

% LOAD images
% leds
handles.gled=imread(['leds' filesep 'gled.jpg']);
handles.rled=imread(['leds' filesep 'rled.jpg']);
handles.oled=imread(['leds' filesep 'oled.jpg']);
handles.a=handles.rled(:,:,3)<200; %transparency

% scale
scale=imread(['needle' filesep 'scale.png']);
sa=scale(:,:,3)<230;

% needles
n=cell(1,41); na=cell(1,41);
for i=1:41
    handles.n{i}=imread(['needle' filesep num2str(i-1) '.png']);
    handles.na{i}=handles.n{i}(:,:,3)<230;
end

% DISPLAY
axes(handles.saxes);image(scale,'AlphaData',sa),axis off;
switchoff(handles);

% Choose default command line output for tuner
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = tuner_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in toggle_onoff.
function toggle_onoff_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_onoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uicontrol(handles.text_note); %change focus

if get(hObject,'Value') == get(hObject,'Max')
    switchon(handles);
    yint(hObject, handles);
else
    switchoff(handles);
end
if ishandle(hObject), guidata(hObject, handles); end



function switchoff(handles)
% leds off
axes(handles.laxes);image(handles.oled,'AlphaData',handles.a),axis off;
axes(handles.maxes);image(handles.oled,'AlphaData',handles.a),axis off;
axes(handles.raxes);image(handles.oled,'AlphaData',handles.a),axis off;

% hide needle
axes(handles.naxes);cla,axis off;

% text defaults
set(handles.text_diff, 'String', '0');
set(handles.text_note, 'String', 'A4');
set(handles.text_freq, 'String', '440');



function switchon(handles)
% show needle
axes(handles.naxes);image(handles.n{1},'AlphaData',handles.na{1}),axis off;

% leds flashing effect
axes(handles.laxes);image(handles.rled,'AlphaData',handles.a),axis off;
axes(handles.maxes);image(handles.gled,'AlphaData',handles.a),axis off;
axes(handles.raxes);image(handles.rled,'AlphaData',handles.a),axis off;
pause(0.05)
axes(handles.laxes);image(handles.oled,'AlphaData',handles.a),axis off;
axes(handles.maxes);image(handles.oled,'AlphaData',handles.a),axis off;
axes(handles.raxes);image(handles.oled,'AlphaData',handles.a),axis off;