function varargout = lasercamcalib(varargin)
% LASERCAMCALIB M-file for lasercamcalib.fig
%      LASERCAMCALIB, by itself, creates a new LASERCAMCALIB or raises the existing
%      singleton*.
%
%      H = LASERCAMCALIB returns the handle to a new LASERCAMCALIB or the handle to
%      the existing singleton*.
%
%      LASERCAMCALIB('Property','Value',...) creates a new LASERCAMCALIB using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to lasercamcalib_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      LASERCAMCALIB('CALLBACK') and LASERCAMCALIB('CALLBACK',hObject,...) call the
%      local function named CALLBACK in LASERCAMCALIB.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lasercamcalib

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
                   'gui_OpeningFcn', @lasercamcalib_OpeningFcn, ...
                   'gui_OutputFcn',  @lasercamcalib_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before lasercamcalib is made visible.
function lasercamcalib_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for lasercamcalib
handles.output = hObject;

%% Initialization of variables
% Has user selected a camera calib file (0/1) ?
handles.userSelectedCameraCalibFile = 0;
% Current camera calib file
handles.cameraCalibFile = '';
% Indices of current active scan/image pairs
handles.ind_active_pairs=[];
% Parameters related to user selected planes
handles.user_selected_planes={};
% Flag for whether user saved the calibration result file
handles.user_saved_results = 1;

set(handles.load_calib_file_bn,'Enable','On');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lasercamcalib wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lasercamcalib_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in select_calibfile_bn.
function select_calibfile_bn_Callback(hObject, eventdata, handles)
% hObject    handle to select_calibfile_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(0,'UseNativeSystemDialogs',false);
[cameraCalibFile,cameraCalibFilePath]=uigetfile('*.mat',...
    'Select the MCCT calibration file (.mat) of the camera');
% If nothing was selected, then return
if(cameraCalibFile==0) 
    return;
end
disp(['Selected file: ' strcat(cameraCalibFilePath,cameraCalibFile)]);

% Store filename of camera calibration file
handles.cameraCalibFile=strcat(cameraCalibFilePath,cameraCalibFile);
handles.cameraCalibFilePath=cameraCalibFilePath;
% Set flag to indicate user has selected a calib file
handles.userSelectedCameraCalibFile=1;
% Load camera calibration file into a struct
handles.camcalibparams=load(handles.cameraCalibFile);

% Enable other buttons
set(handles.list_active_bn,'Enable','On');
set(handles.search_scans_bn,'Enable','On');

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in list_active_bn.
function list_active_bn_Callback(hObject, eventdata, handles)
% hObject    handle to list_active_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(isempty(handles.ind_active_pairs))
    disp('No scan/image pairs loaded at this time');
else
    disp('List of active scan/image pairs: ');
    disp(int2str(handles.ind_active_pairs));
end


% --- Executes on button press in search_scans_bn.
function search_scans_bn_Callback(hObject, eventdata, handles)
% hObject    handle to search_scans_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Query base name of scans
temp=input('Enter base name of scans (without numbers or suffix): ','s');
if(isempty(temp))
    disp('Invalid entry. Try again.');
    return;
end
handles.scanBaseName=temp;
% Query suffix name of scans
temp=input('Enter suffix of scan files ([] = "xyz"): ','s');
if(isempty(temp))
    temp = 'xyz';
end 
handles.scanSuffix=temp;
handles.ind_active_pairs=[];

% Find scan files in current directory whose indices match
% ind_active
d=dir([handles.scanBaseName '*.' handles.scanSuffix]);
nFiles=size(d,1);
if(~nFiles)
    disp(['Found no files named ' handles.scanBaseName ...
        '*.' handles.scanSuffix '! Check your input and try again.']);
    return;
end
% MCCT stores an image_numbers list containing actual numbers from
% the filenames. ind_active contains index locations of the active
% numbers. active_images is a binary vector with ones corresponding to
% locations of numbers in image_numbers that are active.
% We create a list of active_image_numbers as
handles.active_image_numbers= sort(...
    handles.camcalibparams.image_numbers(find(handles.camcalibparams.active_images)));

for i=1:nFiles
    % Strip path free version scanBaseName 
    s=findstr('/',handles.scanBaseName);
    if(~isempty(s))
        scanBaseName_nopath=handles.scanBaseName(max(s)+1:end);
    else
        scanBaseName_nopath=handles.scanBaseName;
    end
    s=findstr('\',scanBaseName_nopath);
    if(~isempty(s))
        scanBaseName_nopath=scanBaseName_nopath(max(s)+1:end);
    end
    % Extract number from filename
    s=findstr(d(i).name,scanBaseName_nopath);
    ss=findstr(d(i).name,['.' handles.scanSuffix]);
    filenum=str2num(d(i).name(s+length(scanBaseName_nopath):(ss-1)));
    % If number is in active_image_numbers from camera calibration
    if(~isempty(find(handles.active_image_numbers==filenum)))
        % Add it to current active list
        handles.ind_active_pairs=[handles.ind_active_pairs filenum];
    end
end
handles.ind_active_pairs=sort(handles.ind_active_pairs);
handles.user_selected_planes=cell(1,length(handles.active_image_numbers));
disp('--- Loaded list of active scan/image pairs ---');
disp(int2str(handles.ind_active_pairs));

% Update handles structure
guidata(hObject, handles);

set(handles.add_remove_scans_bn,'Enable','On');
set(handles.preview_bn,'Enable','On');
set(handles.select_planes_bn,'Enable','On');

% --- Executes on button press in exit_bn.
function exit_bn_Callback(hObject, eventdata, handles)
% hObject    handle to exit_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.user_saved_results)
 delete(handles.figure1);
 return;
end
% % Get the current position of the GUI from the handles structure
% % to pass to the modal dialog.
% pos_size = get(handles.figure1,'Position');
% % Call modaldlg with the argument 'Position'.
user_response = exit_modaldlg('Title','Confirm Close');
switch user_response
case {'No'}
    % take no action
case 'Yes'
    % Prepare to close GUI application window
    delete(handles.figure1)
end


% --- Executes on button press in add_remove_scans_bn.
function add_remove_scans_bn_Callback(hObject, eventdata, handles)
% hObject    handle to add_remove_scans_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

modifiedFlag=0;
% If ind_active_pairs is empty, go to scan-addition mode
if(isempty(handles.ind_active_pairs))
    selection=0;
else
    selection=input('Add/Remove scans (0=add, other=remove): ');
    if(selection) selection=1; end;
end
if(selection==0) 
    disp('--- Chose to add scans ---');
    ind_to_add=input('Enter indices to add to list: ');
    for i=1:length(ind_to_add)
        % Dont add indices that are already in list
        if(~isempty(find(handles.ind_active_pairs==ind_to_add(i))))
            continue;
        end
        % Check to see if there is a correspondingly numbered scan file
        % and an entry in camcalibparams.ind_active
        d=dir([handles.scanBaseName int2str(ind_to_add(i)) '.' handles.scanSuffix]);
        if(~size(d,1))
            disp(['No scan file found with number ' int2str(ind_to_add(i)) '. Skipping...']);
            continue;
        end
        if(isempty(find(handles.active_image_numbers==ind_to_add(i))))
            disp(['Image #' int2str(ind_to_add(i)) ...
                    'was not used in calibrating the camera. Skipping...']);
        end
        handles.ind_active_pairs=[handles.ind_active_pairs ind_to_add(i)];
        modifiedFlag=1;
    end
else
    %% Removal of image/scan indices
    disp('--- Chose to remove scans ---');
    disp('List of active scan/image pairs: ');
    disp(int2str(handles.ind_active_pairs));
    ind_to_remove=input('Enter indices to remove from list: ');
    for i=1:length(ind_to_remove)
        handles.ind_active_pairs(find(handles.ind_active_pairs==ind_to_remove(i)))=[];
        modifiedFlag=1;
    end
    disp('Modified list of active scan/image pairs: ');
    disp(int2str(handles.ind_active_pairs));
end

if(modifiedFlag)
    handles.ind_active_pairs=sort(handles.ind_active_pairs);
    disp('--- Loaded list of active scan/image pairs ---');
    disp(int2str(handles.ind_active_pairs));
end
% Update handles structure
guidata(hObject, handles);

% ===============================================================================
% --- Executes on button press in preview_bn.
function preview_bn_Callback(hObject, eventdata, handles)
% hObject    handle to preview_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Preview a set of range images in separate window
ind_preview=input('Enter indices of range images to preview ([]=all active): ');
if(isempty(ind_preview))
    if(isempty(handles.ind_active_pairs))
        disp('No active images to preview');
        return;
    end
    ind_preview=handles.ind_active_pairs;
end
% Create cell array containing valid filenames for preview
preview_filenames={};
nvalid=0;
for i=1:length(ind_preview)
    % Check to see if it is a valid range image file
    d=dir([handles.scanBaseName int2str(ind_preview(i)) '.' handles.scanSuffix]);
    if(~size(d,1))
        continue;
    end
    nvalid=nvalid+1;
    preview_filenames{nvalid}=[handles.scanBaseName int2str(ind_preview(i)) '.' handles.scanSuffix];
end

r_or_p = input('use range image (r) or 3D point cloud (p) to select checkboard plane? (default:p): ','s');

disp('Starting range image viewer... please wait');
% View range images in preview mode

if strcmp(r_or_p,'r')
    temp=view_range_image(preview_filenames,0,[],1,10);
    delete(temp);
else
    preview_point_cloud(preview_filenames);
end

% =========================================================================
% --- Executes on button press in select_planes_bn.
function select_planes_bn_Callback(hObject, eventdata, handles)
% hObject    handle to select_planes_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Preview a set of range images in separate window
ind_preview=input('Enter indices of range images to preview ([]=all active): ');
if(isempty(ind_preview))
    if(isempty(handles.ind_active_pairs))
        disp('No active images to preview');
        return;
    end
    ind_preview=handles.ind_active_pairs;
end
% Create cell array containing valid filenames for preview
preview_filenames={};
nvalid=0;
for i=1:length(ind_preview)
    % Check to see if it is a valid range image file
    d=dir([handles.scanBaseName int2str(ind_preview(i)) '.' handles.scanSuffix]);
    if(~size(d,1))
        continue;
    end
    nvalid=nvalid+1;
    preview_filenames{nvalid}=[handles.scanBaseName int2str(ind_preview(i)) '.' handles.scanSuffix];
end

% Construct a cell containing info about previously selected planes
old_selected_planes=cell(1,length(ind_preview));
for i=1:length(ind_preview)
    arrayPos=find(handles.active_image_numbers==ind_preview(i));
    old_selected_planes{i}=...
        handles.user_selected_planes{arrayPos};
end

r_or_p = input('use range image (r) or 3D point cloud (p) to select checkboard plane? (default:p): ','s');

disp('Starting range image viewer... please wait');

if r_or_p == 'r'
    % View range images in "select planes" mode
    [h, temp]=view_range_image(preview_filenames,1,old_selected_planes,1,10);
    delete(h);
    clear old_selected_planes;

    % If user pushed the "Cancel" button
    if(isempty(temp))
        return;
    end
    % Update the contents of handles.user_selected_plane with the new info
    for i=1:length(temp)
        if(~isempty(temp{i}))
            arrayPos=find(handles.active_image_numbers==ind_preview(i));
            handles.user_selected_planes{arrayPos}=temp{i};
        end
    end
else
    handles = select_plane_from_point_cloud(handles,preview_filenames,ind_preview);
end
% Update handles structure
guidata(hObject, handles);

% Enable some buttons
set(handles.calibrate_bn,'Enable','On');

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% =========================================================================
% --- Executes on button press in calibrate_bn.
function calibrate_bn_Callback(hObject, eventdata, handles)
% hObject    handle to calibrate_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Camera part:
% Store the indices of images that were used in the calibration and are in
% the ind_active_pairs list.
% Store the R,t matrices for the calibration targets in those images (these
% relate the target grid to the camera coord system.
% Compute the equivalent [theta,alpha] rep of the planes

% Variables: calib_name[eg: image] format_image[eg: jpg]
% ind_active (eg [3 4 ... 13]) - indices of the "active" images used
% in calibration
% External plane: Rc_3 Tc_3 ...
thetac=[]; alphac=[];
for i=1:length(handles.ind_active_pairs)
    % If we haven't got information for the laser yet, dont do the
    % calibration
    arrayPos=find(handles.active_image_numbers==handles.ind_active_pairs(i));
    if(isempty(handles.user_selected_planes{arrayPos}))
        disp(['No input data given for scan' handles.scanBaseName ...
            num2str(handles.ind_active_pairs(i)) '.' ...
            handles.scanSuffix]);
        disp('Enter all data before running calibration routine');
        return;
    end
    
    % Get Rotation matrix and Translation vector corresponding to the
    % camera image
    Rname=strcat('handles.camcalibparams.Rc_',...
        int2str(handles.camcalibparams.ind_active(arrayPos)));
        %int2str(handles.ind_active_pairs(i)));
    R=eval(Rname);
    Tname=strcat('handles.camcalibparams.Tc_',...
        int2str(handles.camcalibparams.ind_active(arrayPos)));
        %int2str(handles.ind_active_pairs(i)));
    T=eval(Tname);
    theta=R(:,3); alpha=T'*theta;
    if(alpha<0)
        theta=-theta; alpha=-alpha;
    end
    thetac=[thetac theta]; alphac=[alphac alpha];
end
% Conversion from mm (MCCT fomat) to metres (ladar data format)
alphac=alphac.*1.0e-3;

% Laser part:
% For each laser scan corresponding to the used images
% Select the 3d points corresponding to the target from the range image
% Fit a plane to the points and get [theta,alpha] wrt the laser 
n_scans=length(handles.ind_active_pairs);

thetal=[]; alphal=[];
planePoints=[];
n_planePoints=[];
%weight=[];

for j=1:n_scans
    i=find(handles.active_image_numbers==handles.ind_active_pairs(j));
    fprintf(1,'Processing %s\n',[handles.scanBaseName ...
        int2str(handles.ind_active_pairs(j)) '.' handles.scanSuffix]);
    % theta and alpha in laser frame
    thetal=[thetal handles.user_selected_planes{i}.theta];
    alphal=[alphal handles.user_selected_planes{i}.alpha];
    % inliers in selected plane points
    planePoints=[planePoints; handles.user_selected_planes{i}.inliers];
    % number of inliers in selected plane points
    n=size(handles.user_selected_planes{i}.inliers,1);
    n_planePoints=[n_planePoints ; n];
    % Each point is weighted inversely to the number of inliers selected 
    % in each selected plane
    %weight=[weight; ones(n,1)./n];
    fprintf(1,'Median error was %f\n',handles.user_selected_planes{i}.e);
end

disp('-- Optimization: Stage I');
% Computing the best transformation:
% We proceed by performing the minimization in a iterated two-stage 
% process.
% In the first stage, we find the translation that minimizes the
% difference in distance from the camera origin to each plane represented
% in the camera system and laser system.
% In the second stage, we find the best rotation that minimizes the angular
% difference between the normal from the origin to corresponding planes

% Assume planes params wrt laser and camera are [thetal,alphal] and 
% [thetac,alphac]. thetax is 3-by-n_planes , alphax is 1-by-n_planes
% 
t1=zeros(3,1); R1=eye(3);

% Closed form solution
t_est=inv(thetac*thetac')*thetac*(alphac-alphal)';

% Adjust by t_estt_start=mean(thetal.*repmat(alphal,3,1),2) ...

t1=t1+t_est;

fprintf(1,'Computed RMS error in distance to planes: %f\n',...
    computeRMSDiffDistanceToPlanes(t_est,thetac,alphac,thetal,alphal));

% Computing best rotation
% camera_normals(Q)= R * laser_normals(P)
[U,S,V]=svd(thetal*thetac');
R=V*U';
if(det(R)<0)
    fprintf(1,'*** WARNING : Found det(R) < 0 => optimal solution includes a reflection\n');
    resp = input('Allow reflection (y/n) [n]? ');    
    if ( ~isempty(resp) && lower(resp(1)) == 'y')
        R = V * diag([ ones(size(V,2)-1, 1) ; -1]) * U';
    else
        error('Exiting due to unexpect point configuration');
    end
end
R1=R;

disp('-- Optimization: Stage II');
%% Stage II of optimization
% Use the computed estimates of R1 and t1 in a second optimization
% stage where the sum of sqr distance of the polygon vertices to each plane
% is minimized
% Find quaternion corresponding to computed R1
q=rot2quat(R1);
par=[q ; t1];

cost=computeRMSWeightedDistVerticesToPlanes(par,planePoints,n_planePoints,...
    thetac,alphac);
fprintf(1,'Initial RMS distance of points to planes: %f\n',cost);
disp('... running non-linear optimization routine...');

% Uses optimization toolbox
% [par_est, fval, exitFlag,output]=fminunc(@computeDistVerticesToPlanes,...
%     par,[],planePoints,n_planePoints,thetac,alphac);
[par_est, fval, exitFlag,output]=fminsearch(...
    @computeRMSWeightedDistVerticesToPlanes,...
    par,[],planePoints,n_planePoints,thetac,alphac);

cost=computeRMSWeightedDistVerticesToPlanes(par_est,planePoints,...
    n_planePoints,thetac,alphac);
fprintf(1,'RMS distance of points to planes after search: %f\n',cost);

% Convert back to rotation matrix
R2=quat2rot(par_est(1:4));
t2=par_est(5:7);
%T=[quat2rot(par_est(1:4)) par_est(5:7)];

handles.R1=R1;
handles.t1=t1;
handles.R2=R2;
handles.t2=t2;

disp('-- Result: ');
[R1 t1]
[R2 t2]

% Take preventive measure in case user tries to quit without saving
handles.user_saved_results = 0;

% Update handles structure
guidata(hObject, handles);

% Enable some buttons
set(handles.save_calib_file_bn,'Enable','On');
set(handles.plot_error_bn,'Enable','On');
set(handles.colorize_scan_bn,'Enable','On');

return;

% =========================================================================
% Function takes as input a 7-vector [q t] corresp to quaterion
% representation of rotation, and translation t and computes the sum of
% square distances of the points, planeVertices, to the 3d planes.
% planeVertices are in the laser coordinate frame and contain 4*n_planes
% points (4 points per plane)
function cost = computeRMSWeightedDistVerticesToPlanes(par, ...
    planePoints,n_planePoints,thetac,alphac)

q = par(1:4);
t = par(5:7);
R = quat2rot(q);
cost=0; count=0;
cn_planePoints=cumsum(n_planePoints);
for i=1:length(n_planePoints)    
    %vert = planeVertices((4*i-3):(4*i),:);
    if(i==1)
        vert = planePoints(1:cn_planePoints(i),:);
    else
        vert = planePoints((cn_planePoints(i-1)+1):cn_planePoints(i),:);
    end
    theta = thetac(:,i);
    % Sum of square distances of points transformed to camera frame to
    % planes in camera frame
    cost=cost+mean((theta'*(R*vert'+repmat(t,1,n_planePoints(i)))-alphac(i)).^2);
end
cost=sqrt(cost./length(n_planePoints));
return;

%-------------------------------------------------------------------------    
function cost = computeRMSDiffDistanceToPlanes(pc,thetac,alphac,thetal,alphal)

%t_1= (abs(pc'*thetac - alphac) - alphal).^2 ;
%t_2= (abs(-pc'*thetal - alphal) - alphac).^2;
%t_3=max(t_1,t_2);
%cost=sum(t3(t3<median(t3)));
cost = sqrt(mean( (abs(pc'*thetac - alphac) - alphal).^2 ));
return;


%-------------------------------------------------------------------------    
% --- Executes on button press in save_calib_file_bn.
function save_calib_file_bn_Callback(hObject, eventdata, handles)
% hObject    handle to save_calib_file_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag=input('Enter name tag for calibration file: ','s');
comment=input('Enter optional comment ([]=none): ','s');
% Save results of optim 1
fid=fopen([tag '_calib_1.m'],'wt');
fprintf(fid,'%% Laser to Camera calibration parameters (I optim stage) \n');
if (~isempty(comment))
    fprintf(fid,['%% File comment: ' comment '\n']);
end
fprintf(fid,['%% ' datestr(now) '\n']);
fprintf(fid,'%% \n');
fprintf(fid,'%% Transformation matrix specifies laser coordinate frame\n');
fprintf(fid,'%% in the reference frame of the camera\n');
fprintf(fid,'%% \n');
fprintf(fid,'%%-- Translation vector (t)\n');
fprintf(fid,'t = [ %5.6f ; %5.6f ; %5.6f ]\n',...
    handles.t1(1),handles.t1(2),handles.t1(3));
fprintf(fid,'%%-- Rotation matrix (R)\n');
fprintf(fid,'R = ...\n[ %5.6f  %5.6f  %5.6f ;...\n  %5.6f  %5.6f  %5.6f ;...\n  %5.6f  %5.6f  %5.6f ]\n',...
    handles.R1(1,1),handles.R1(1,2),handles.R1(1,3),...
    handles.R1(2,1),handles.R1(2,2),handles.R1(2,3),...
    handles.R1(3,1),handles.R1(3,2),handles.R1(3,3));
fclose(fid);
disp(['Saved ' tag '_calib_1.m']);

% Save results of optim 2
fid=fopen([tag '_calib_2.m'],'wt');
fprintf(fid,'%% Laser to Camera calibration parameters (II optim stages) \n');
if (~isempty(comment))
    fprintf(fid,['%% File comment: ' comment '\n']);
end
fprintf(fid,['%% ' datestr(now) '\n']);
fprintf(fid,'%% \n');
fprintf(fid,'%% Transformation matrix specifies laser coordinate frame\n');
fprintf(fid,'%% in the reference frame of the camera\n');
fprintf(fid,'%% \n');
fprintf(fid,'%%-- Translation vector (t)\n');
fprintf(fid,'t = [ %5.6f ; %5.6f ; %5.6f ]\n',...
    handles.t2(1),handles.t2(2),handles.t2(3));
fprintf(fid,'%%-- Rotation matrix (R)\n');
fprintf(fid,'R = ...\n[ %5.6f  %5.6f  %5.6f ;...\n  %5.6f  %5.6f  %5.6f ;...\n  %5.6f  %5.6f  %5.6f ]\n\n',...
    handles.R2(1,1),handles.R2(1,2),handles.R2(1,3),...
    handles.R2(2,1),handles.R2(2,2),handles.R2(2,3),...
    handles.R2(3,1),handles.R2(3,2),handles.R2(3,3));
fclose(fid);
disp(['Saved ' tag '_calib_2.m']);

handles.user_saved_results = 1;
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in load_calib_file_bn.
function load_calib_file_bn_Callback(hObject, eventdata, handles)
% hObject    handle to load_calib_file_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag = input('Enter name tag (without the _calib_x.m suffix) of laser-camera calibration file: ','s');
filename1 = [tag '_calib_1.m'];
temp = dir(filename1);
if (~size(temp,1))
    disp(['Cannot find file named ' filename1 '. Please check and try again.']);
    return;
end
filename1 = [tag '_calib_1'];
disp(['Loading stage I results from file: ' filename1 '.m']);
run(filename1);
handles.R1 = R; handles.t1 = t;
filename2 = [tag '_calib_2'];
disp(['Loading stage II results from file: ' filename2 '.m']);
run(filename2);
handles.R2 = R; handles.t2 = t;

% Enable colorizer button
set(handles.colorize_scan_bn,'Enable','On');

guidata(hObject, handles);



% --- Executes on button press in colorize_scan_bn.
function colorize_scan_bn_Callback(hObject, eventdata, handles)
% hObject    handle to colorize_scan_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (~handles.userSelectedCameraCalibFile)
    disp('Error: No camera calibration file selected.')
    disp('Please select a camera calibration file first!');
    return;
end

%%% Optional: Make sure that project_points2 function from MCCT is in your
%%% path
s=which('project_points2');
if(isempty(s))
    disp(['You need to place the Matlab Camera Calibration Toolbox ' ...
        'directory in your path to perform this procedure.']);
    return;
end

% Input name of scan file and image file
scan_filename_colorizer=input('Enter xyz scan filename to colorize: ','s');
temp=dir(scan_filename_colorizer);
if(~size(temp,1))
    disp(['Cannot find file named ' scan_filename_colorizer '. Please check and try again.']);
    return;
end
selectedImageFlag=0;
while (~selectedImageFlag)
    image_filename_colorizer=...
        input('Enter image filename to use for colorizing points: ','s');
    temp=dir(image_filename_colorizer);
    if(~size(temp,1))
        disp(['Cannot find file named' image_filename_colorizer ...
                '. Please check and try again.']);
    else
        selectedImageFlag=1;
    end
end

tic
% load scan
scan3d=load(scan_filename_colorizer);
n_points=size(scan3d,1);
%scan=(handles.R2*scan'+repmat(handles.t2,1,n_points))';
% Convert to mm's
%scan=scan.*1.0e3;

% 1) Convert into camera reference frame (m) * 1.0e3 to get in mms
% 2) Project points into 2d image using MCCT's project_points2 function
scan=project_points2(1.0e3*(handles.R2*scan3d'+repmat(handles.t2,1,n_points)),...
    zeros(3,1),zeros(3,1),...
    handles.camcalibparams.fc,handles.camcalibparams.cc,...
    handles.camcalibparams.kc,handles.camcalibparams.alpha_c);
% scan=project_points2(scan',zeros(3,1),zeros(3,1),...
%     handles.camcalibparams.fc,handles.camcalibparams.cc,...
%     handles.camcalibparams.kc,handles.camcalibparams.alpha_c);
% Flip rows<->columns to get matlab image coordinates, and round off values
scan=fliplr(round(scan'));

% Read image
image=imread(image_filename_colorizer);

% Initialize empty matrix representing default point color=black
scanRGB=zeros(n_points,3);
imrows=size(image,1);
imcols=size(image,2);

% Find indices of all points that project within image
inliers=find(scan(:,1)>0 & scan(:,1)<imrows & scan(:,2)>0 ...
    & scan(:,2)<imcols);

%% For all points that project within the image, lookup the color
%% and store in scanRGB
% Convert [scan(inliers,1) scan(inliers,2)] to linear index based on size
% of image
inliers_lindex=sub2ind([imrows imcols],scan(inliers,1),scan(inliers,2));
% Convert image from imrows*imcols*3 to (imrows*imcols)*3
image=reshape(image,imrows*imcols,3);
scanRGB(inliers,:)=image(inliers_lindex,:);
clear scan image inliers inliers_lindex;

%% Write VRML file as output
fprintf(1,'Writing VRML file rgbScan.wrl\n');
fprintf(1,'This may take a minute, so please wait... ');
xyzrgb2vrml('rgbScan.wrl',scan3d,scanRGB);
fprintf(1,'Done!\n');
toc
return;


    

% --- Executes on button press in plot_error_bn.
function plot_error_bn_Callback(hObject, eventdata, handles)
% hObject    handle to plot_error_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Not yet implemented. But stay tuned!');

% Function to plot reprojection errors for different scans


% --- Executes on button press in about_bn.
function about_bn_Callback(hObject, eventdata, handles)
% hObject    handle to about_bn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
about_dlg;
