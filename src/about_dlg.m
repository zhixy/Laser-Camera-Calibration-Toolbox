function varargout = about_dlg(varargin)
% ABOUT_DLG M-file for about_dlg.fig
%      ABOUT_DLG, by itself, creates a new ABOUT_DLG or raises the existing
%      singleton*.
%
%      H = ABOUT_DLG returns the handle to a new ABOUT_DLG or the handle to
%      the existing singleton*.
%
%      ABOUT_DLG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ABOUT_DLG.M with the given input arguments.
%
%      ABOUT_DLG('Property','Value',...) creates a new ABOUT_DLG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before about_dlg_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to about_dlg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help about_dlg

% Last Modified by GUIDE v2.5 14-Nov-2005 01:26:22

%* Author: Ranjith Unnikrishnan                                          *
%* Carnegie Mellon University, Vision and Mobile Robotics Laboratory     *
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
                   'gui_OpeningFcn', @about_dlg_OpeningFcn, ...
                   'gui_OutputFcn',  @about_dlg_OutputFcn, ...
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


% --- Executes just before about_dlg is made visible.
function about_dlg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to about_dlg (see VARARGIN)

% Choose default command line output for about_dlg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes about_dlg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = about_dlg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ok_bn.
function ok_bn_Callback(hObject, eventdata, handles)
% hObject    handle to ok_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);
