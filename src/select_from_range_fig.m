function [theta,alpha,minError,vertices3d,vertices2d,inliers]= ...
    select_from_range_fig(hObject, eventdata, handles)
% -------------------------------------------------------------------------
% FUNCTION: select_from_range_fig
% INPUT:
%  hObject : handle to current figure
%  eventdata : from calling function
%  handles : data common to GUI
% OUTPUT:
%  theta,alpha: parameters of selected plane as per equation
%               theta'*x=alpha , alpha>0 , norm(theta)=1
%  minError   : min fitting error using tls_robust routine
%  vertices3d : 3d coords of points corresponding to vertices of selected 
%               polgon
%  inliers    : 3d coords of points considered inliers to the selected
%               plane
% -------------------------------------------------------------------------

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
scanp = scan * P;
% Compute angle swept by data in xy plane
theta = atan2(scanp(:,2),scanp(:,1));

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
scanp = scanp * R;

% Perspective projection (x/y, z/y)
scanp_y = scanp(:,2);
scanp=[scanp(:,1)./scanp(:,2) scanp(:,3)./scanp(:,2)];
%scanp(:,1) = scanp(:,1)/scanp(:,2);
%scanp(:,3) = scanp(:,3)/scanp(:,2);

% X,Y bounds of projection
xBounds=[ min(scanp(:,1)) max(scanp(:,1))];
yBounds=[ min(scanp(:,2)) max(scanp(:,2))];

% Size of a square pixel
pixel_size=max([range(xBounds) range(yBounds)])/150;

% Choose size of grid that will serve as the range image (n_cols n_rows)
nx=ceil(range(xBounds)/pixel_size) + 1;
ny=ceil(range(yBounds)/pixel_size) + 1;
grid=zeros(ny,nx);

% Add points to grid
ix=floor( (scanp(:,1)-xBounds(1))/pixel_size ) + 1;
iy=floor( (yBounds(2)-scanp(:,2))/pixel_size ) + 1;
ii=sub2ind(size(grid),iy,ix);
grid(ii)=max(grid(ii),scanp_y);

grid=-grid;
% Set values of zero to minimum value
grid(grid==0) = min(grid(:));
colormap(jet);
axes(handles.range_image_axis);
imagesc(grid);
axis('equal'); axis off;
title(handles.current_scanfilename);
%colorbar

% Draw a polygon and get its vertices
[x_polygon,y_polygon]=selectPolygon;
vertices2d=[x_polygon y_polygon];

% Choose points whose projections in range image
% are inside the polygon
region=scan(inpolygon(ix,iy,x_polygon,y_polygon),:);

fprintf(1,'Selected %d points\n',size(region,1));
% Fit plane to points
[theta,alpha,minError]=tls_robust(region);

% Compute the 3d points corresponding to the vertices of the polygon
vertices3d=[];
for i=1:4
    temp=[ix iy]-repmat([x_polygon(i) y_polygon(i)],size(ix,1),1);
    [m,j]=min(sum(temp.^2,2));
    %[m,j]=min(sum((scanp-repmat([x_polygon(i) y_polygon(i)],size(scanp,1),1)).^2,2));
    vertices3d=[vertices3d; scan(j,:)];
end

% Compute inliers = points within median distance from plane
dist=abs(theta'*region'-alpha);
inliers=region(dist<median(dist),:);

return;
