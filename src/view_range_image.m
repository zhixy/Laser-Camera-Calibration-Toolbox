function varargout = view_range_image(varargin)
% VIEW_RANGE_IMAGE M-file for view_range_image.fig
%      VIEW_RANGE_IMAGE, by itself, creates a new VIEW_RANGE_IMAGE or raises the existing
%      singleton*.
%
%      H = VIEW_RANGE_IMAGE returns the handle to a new VIEW_RANGE_IMAGE or the handle to
%      the existing singleton*.
%
%      VIEW_RANGE_IMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEW_RANGE_IMAGE.M with the given input arguments.
%
%      VIEW_RANGE_IMAGE('Property','Value',...) creates a new VIEW_RANGE_IMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before view_range_image_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to view_range_image_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help view_range_image

% Last Modified by GUIDE v2.5 11-Feb-2005 04:55:53

%* Author: Ranjith Unnikrishnan                                          *
%* Carnegie Mellon University, Vision and Mobile Robotics Laboratory       *
%* THE MATERIAL EMBODIED IN THIS SOFTWARE IS PROVIDED TO YOU "AS-IS"     *
%* AND WITHOUT WARRANTY OF ANY KIND, EXPRESS, IMPLIED OR OTHERWISE,      *
%* INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY OR      *
%* FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT SHALL CARNEGIE MELLON  *
%* UNIVERSITY BE LIABLE TO YOU OR ANYONE ELSE FOR ANY DIRECT,            *
%* SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY         *
%* KIND, OR ANY DAMAGES WHATSOEVER, INCLUDING WITHOUT LIMITATION,        *
%* LOSS OF PROFIT, LOSS OF USE, SAVINGS OR REVENUE, OR THE CLAIMS OF     *
%* THIRD PARTIES, WHETHER OR NOT CARNEGIE MELLON UNIVERSITY HAS BEEN     *
%* ADVISED OF THE POSSIBILITY OF SUCH LOSS, HOWEVER CAUSED AND ON        *
%* ANY THEORY OF LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE     *
%* POSSESSION, USE OR PERFORMANCE OF THIS SOFTWARE.                      *
%

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @view_range_image_OpeningFcn, ...
                   'gui_OutputFcn',  @view_range_image_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before view_range_image is made visible.
function view_range_image_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to view_range_image (see VARARGIN)

% Choose default command line output for view_range_image
handles.output = hObject;
%handles.user_selected_planes={};
%handles.output= 42;

% Input arguments:
% preview_filenames{}
% mode : 0=preview (default) 1=select polygons containing plane
% nearVal
% farVal

if(length(varargin)<1)
      uiwait(errordlg('No valid scan files input for previewing'));
end
if(length(varargin)>=1 & (~iscell(varargin{1}) | isempty(varargin{1})))
      uiwait(errordlg('Invalid input. First argument must be cell of filenames'));
end

% Set UP direction vector here (e.g if z-axis points up away from the
% ground, use [0 0 1]'
handles.up_vector = [0 0 1]';

% Choose a right and forward vector appropriately
handles.right_vector = ...
    [handles.up_vector(3) handles.up_vector(2) -handles.up_vector(1)]';
handles.forward_vector = ...
    cross(handles.up_vector, handles.right_vector);

%% Load arguments
% Arg 1: Cell of filenames with xyz ladar data to be previews
if(length(varargin)>=1 & iscell(varargin{1}) & ~isempty(varargin{1}))
    % Load names of scan files
    handles.preview_filenames=varargin{1};
    % Set number of current file
    handles.preview_file_num=1;
    handles.preview_nfiles=length(handles.preview_filenames);
    handles.user_selected_planes=cell(1,handles.preview_nfiles);
    % Load current file and filename
    handles.current_scanfilename=handles.preview_filenames{1};
    handles.current_scan=load(handles.current_scanfilename);
    % Disable "Prev" button
    set(handles.prev_bn,'Visible','Off');
    set(handles.prev_bn,'Enable','Off');
    % If there is only one file to preview, disable "Next" button
    if(handles.preview_nfiles<=1)
        set(handles.next_bn,'Visible','Off');
        set(handles.next_bn,'Enable','Off');
    end
else
    set(handles.prev_bn,'Visible','Off');
    set(handles.next_bn,'Visible','Off');
    set(handles.prev_bn,'Enable','Off');
    set(handles.next_bn,'Enable','Off');
    set(handles.nearVal_slider,'Enable','Off');
    set(handles.farVal_slider,'Enable','Off');
    handles.preview_nfiles=0;
end    

% Arg 2: Mode
% 0 = preview mode (default)
% 1 = select plane mode
if(length(varargin)<2)
    handles.viewer_mode=0; % Preview mode (default)
else
    handles.viewer_mode=varargin{2};
end

% Arg 3: Info about previously selected polygons for the files
% This is considered optional only if we are in preview mode. Otherwise
% previous selection info will be overwritten
if(length(varargin)<3)
    handles.user_selected_planes={};
else
    handles.user_selected_planes=varargin{3};
end

% Arg 4: Distance to near clipping plane
if(length(varargin)<4)
    handles.nearVal=1.0;
else
    handles.nearVal=varargin{4};
end
set(handles.nearVal_slider,'Value',handles.nearVal);
set(handles.nearVal_stext,'String',['Near: ' num2str(handles.nearVal,'%.1f')]);

% Arg 5: Distance to far clipping plane
if(length(varargin)<5)
    handles.farVal=15.0;
else
    handles.farVal=varargin{5};
end
set(handles.farVal_slider,'Value',handles.farVal);
set(handles.farVal_stext,'String',['Far: ' num2str(handles.farVal,'%.1f')]);


% If in preview mode, disable select_plane_bn
if(handles.viewer_mode==0)
    set(handles.select_plane_bn,'Visible','Off');
    set(handles.cancel_bn,'Visible','Off');
else
    %% Change text on "close" button to say "Save and Exit"
    set(handles.close_bn,'String','Save & quit');
    temp=get(handles.close_bn,'Position'); temp(3)=0.12;
    set(handles.close_bn,'Position',temp);
end

if(handles.preview_nfiles)
    disp([' Viewing file: ' handles.current_scanfilename]);
    % Draw range fig
    draw_range_fig(hObject, eventdata, handles);
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes view_range_image wait for user response (see UIRESUME)
uiwait(handles.view_range_figure);


% --- Outputs from this function are returned to the command line.
function varargout = view_range_image_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.user_selected_planes;

%---------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function nearVal_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nearVal_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%---------------------------------------------------------------------
% --- Executes on slider movement.
function nearVal_slider_Callback(hObject, eventdata, handles)
% hObject    handle to nearVal_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

modifiedFlag=0;

% Assure that nearVal on slider is less than farVal on slider
temp=get(handles.nearVal_slider,'Value');
if(temp>get(handles.farVal_slider,'Value'))
    temp=get(handles.nearVal_stext,'String');
    temp=str2double(temp(7:end));
    set(handles.nearVal_slider,'Value',temp);
else
    set(handles.nearVal_stext,'String',...
        ['Near: ' num2str(get(handles.nearVal_slider,'Value'),'%.1f')]);
    modifiedFlag=1;
end
handles.nearVal=get(handles.nearVal_slider,'Value');
% Update handles structure
guidata(hObject, handles);

if(modifiedFlag & handles.preview_nfiles>0)
    % Draw range fig
    draw_range_fig(hObject, eventdata, handles);
end

%---------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function farVal_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to farVal_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%---------------------------------------------------------------------
% --- Executes on slider movement.
function farVal_slider_Callback(hObject, eventdata, handles)
% hObject    handle to farVal_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

modifiedFlag=0;
% Assure that farVal on slider is less than farVal on slider
temp=get(handles.farVal_slider,'Value');
if(temp<get(handles.nearVal_slider,'Value'))
    temp=get(handles.farVal_stext,'String');
    temp=str2double(temp(6:end));
    set(handles.farVal_slider,'Value',temp);
else
    set(handles.farVal_stext,'String',...
        ['Far: ' num2str(get(handles.farVal_slider,'Value'),'%.1f')]);
    modifiedFlag=1;
end
handles.farVal=get(handles.farVal_slider,'Value');

if(modifiedFlag  & handles.preview_nfiles>0)
    % Draw range fig
    draw_range_fig(hObject, eventdata, handles);
    drawnow;
end
% Update handles structure
guidata(hObject, handles);

%---------------------------------------------------------------------
% --- Executes on button press in prev_bn.
function prev_bn_Callback(hObject, eventdata, handles)
% hObject    handle to prev_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Over protection
if(handles.preview_file_num==1)
    set(handles.prev_bn,'Enable','Off');
    guidata(hObject, handles);
    return;
end
%% Choose next file in selection
% Set number of current file
handles.preview_file_num=handles.preview_file_num-1;
% Load current file and filename
handles.current_scanfilename=handles.preview_filenames{handles.preview_file_num};
handles.current_scan=load(handles.current_scanfilename);
disp([' Viewing file: ' handles.current_scanfilename]);

%% Over protection
if(handles.preview_file_num==1)
    set(handles.prev_bn,'Visible','Off');
    set(handles.prev_bn,'Enable','Off');
end
% Enable "Prev" button if there is more than one file to view
if(handles.preview_nfiles>1)
    set(handles.next_bn,'Visible','On');
    set(handles.next_bn,'Enable','On');
end

if(handles.preview_nfiles)
    % Draw range fig
    draw_range_fig(hObject, eventdata, handles); drawnow;
end
% Update handles structure
guidata(hObject, handles);


%---------------------------------------------------------------------
% --- Executes on button press in next_bn.
function next_bn_Callback(hObject, eventdata, handles)
% hObject    handle to next_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Over protection
if(handles.preview_file_num==handles.preview_nfiles)
    %set(handles.next_bn,'Enable','Off');
    %guidata(hObject, handles);
    return;
end
%% Choose next file in selection
% Set number of current file
handles.preview_file_num=handles.preview_file_num+1;
% Load current file and filename
handles.current_scanfilename=handles.preview_filenames{handles.preview_file_num};
handles.current_scan=load(handles.current_scanfilename);
disp([' Viewing file: ' handles.current_scanfilename]);

%% Over protection
if(handles.preview_file_num==handles.preview_nfiles)
    set(handles.next_bn,'Visible','Off'); %%
    set(handles.next_bn,'Enable','Off'); %%
end
% Enable "Prev" button if there is more than one file to view
if(handles.preview_nfiles>1)
    set(handles.prev_bn,'Visible','On');
    set(handles.prev_bn,'Enable','On');
end
guidata(hObject, handles);

if(handles.preview_nfiles)
    % Draw range fig
    draw_range_fig(hObject, eventdata, handles); drawnow;
end
% Update handles structure
guidata(hObject, handles);


%---------------------------------------------------------------------
% --- Executes on button press in close_bn.
function close_bn_Callback(hObject, eventdata, handles)
% hObject    handle to close_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume;

%---------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function nearVal_stext_etext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nearVal_stext_etext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



%---------------------------------------------------------------------
function nearVal_stext_etext_Callback(hObject, eventdata, handles)
% hObject    handle to nearVal_stext_etext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nearVal_stext_etext as text
%        str2double(get(hObject,'String')) returns contents of nearVal_stext_etext as a double


%---------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function range_image_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to range_image_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate range_image_axis

%---------------------------------------------------------------------
% --- Executes when view_range_figure window is resized.
function view_range_figure_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to view_range_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if(handles.preview_nfiles)
if isfield(handles,'preview_nfiles')
    % Draw range fig
    draw_range_fig(hObject, eventdata, handles);
end


%---------------------------------------------------------------------
% --- Executes on button press in select_plane_bn.
function select_plane_bn_Callback(hObject, eventdata, handles)
% hObject    handle to select_plane_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Disable other gui buttons to avoid handling unexpected user input
set([ handles.nearVal_slider, handles.farVal_slider, handles.close_bn,...
        handles.cancel_bn], 'Enable','Off');
% Check status of next and prev bns and see whether they are to be restored
if(strcmp(get(handles.next_bn,'Enable'),'on'))
    set(handles.next_bn,'Enable','off');
    restoreNextBnFlag=1;
    %disp('Next button is on');
else
    restoreNextBnFlag=0;
end
if( strcmp(get(handles.prev_bn,'Enable'),'on'))
    set(handles.prev_bn,'Enable','off');
    %disp('Prev button is on');
    restorePrevBnFlag=1;
else
    restorePrevBnFlag=0;
end

% Select and compute parameters from figure
[theta,alpha,e,vertices3d,vertices2d,inliers]=...
    select_from_range_fig(hObject, eventdata, handles);

% Store parameters in structure at index associated with image order
handles.user_selected_planes{handles.preview_file_num}...
    =struct('theta',theta,'alpha',alpha,'e',e,'vertices3d',vertices3d,...
            'vertices2d',vertices2d,'inliers',inliers);
        
% Update handles structure
guidata(hObject, handles);
% Restore buttons
if (restoreNextBnFlag)
    set(handles.next_bn,'Enable','on');
end
if (restorePrevBnFlag)
    set(handles.prev_bn,'Enable','on');
end
set([ handles.nearVal_slider, handles.farVal_slider, handles.close_bn,...
        handles.cancel_bn], 'Enable','On');

%---------------------------------------------------------------------
% --- Executes on button press in cancel_bn.
function cancel_bn_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.user_selected_planes=cell(1);
% Update handles structure
guidata(hObject, handles);

uiresume;

