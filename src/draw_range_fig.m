function draw_range_fig(hObject, eventdata, handles)

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

% Restrict to data with far > y > near
scan=handles.current_scan;

% Prune based on distance
dist_sq = scan(:,1).*scan(:,1)+scan(:,2).*scan(:,2);
scan(dist_sq < handles.nearVal*handles.nearVal ...
    | dist_sq > handles.farVal*handles.farVal,:) = [];

if (isempty(scan))
    return;
end
    
% Project scan to viewing vectors (up,right,forward)
P = [handles.right_vector handles.forward_vector handles.up_vector];
scan = scan * P;
% Compute angle swept by data in xy plane
theta = atan2(scan(:,2),scan(:,1));

% Assume the angle swept by the data is less than 180 degrees
% Find angle corresponding to vector pointing at the middle of the cloud
midtheta = 0.5*(min(theta) + max(theta));
if (max(theta)-min(theta) > pi)
    if (midtheta > 0)
        midtheta = midtheta - pi;
    else
        midtheta = midtheta + pi;
    end
end

% Rotate the data by pi/2 - midtheta to put everything in view
R = [ cos(pi/2 - midtheta) sin(pi/2 - midtheta) 0;...
    -sin(pi/2 - midtheta) cos(pi/2 - midtheta) 0;...
    0 0 1];
scan = scan * R;

% Perspective projection (x/y, z/y)
scanp=[scan(:,1)./scan(:,2) scan(:,3)./scan(:,2)];

% X,Y bounds of projection
xBounds=[ min(scanp(:,1)) max(scanp(:,1))];
yBounds=[ min(scanp(:,2)) max(scanp(:,2))];

% Size of a square pixel
pixel_size=max([range(xBounds) range(yBounds)])/150;

% Choose size of grid that will serve as the range image (n_cols n_rows)
nx=ceil(range(xBounds)/pixel_size) + 1;
ny=ceil(range(yBounds)/pixel_size) + 1;
grid=ones(ny,nx).*1.0e6; %grid=zeros(ny,nx);

% Add points to grid
ix=floor( (scanp(:,1)-xBounds(1))/pixel_size ) + 1;
iy=floor( (yBounds(2)-scanp(:,2))/pixel_size ) + 1;
ii=sub2ind(size(grid),iy,ix);
grid(ii)=min(grid(ii),scan(:,2));%grid(ii)=max(grid(ii),scan(:,2));

% Set locations without data to maximum value
grid=grid(:);
grid(grid==1.0e6)=max(grid(grid~=1.0e6)); grid=reshape(grid,ny,nx);
colormap(flipud(jet));
axes(handles.range_image_axis);
imagesc(grid);
axis('equal');
axis off;
title(handles.current_scanfilename);
%colorbar

%disp('Checking for previous polygon');
% Draw previously selected polygon, if any
if(~isempty(handles.user_selected_planes) && ...
        ~isempty(handles.user_selected_planes{handles.preview_file_num})) 
    %disp('> Field not empty');
    x=handles.user_selected_planes{handles.preview_file_num}.vertices2d(:,1);
    y=handles.user_selected_planes{handles.preview_file_num}.vertices2d(:,2);
    hold on;
    crosses_h=plot(x,y,'wo-','markersize',6,'linewidth',2);
    hold off;
else
    %disp('> Field empty');
end
return;



