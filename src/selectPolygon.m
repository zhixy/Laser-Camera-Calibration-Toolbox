function [x,y]=selectPolygon()
% function [x,y]=selectPolygon()
% OUTPUT: x,y - xy coordinates of vertices of selected polygon in figure
% NOTE: The coord vectors are set up so that the last and first entries
% are the same
% PURPOSE:
% Function to select a polygonal region in the current figure
% and return the coordinates of the vertices (x,y)
% USAGE:
% - Left click to select point
% - ESC to undo
% - Right click to end and finish loop

% Author: Ranjith Unnikrishnan
%* Carnegie Mellon University, Vision and Mobile Robots Laboratory       *
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

x=[];
y=[];
done=0;
n_selected=0;
crosses_h=1234.567; % some arbit number
first=1;
xlabel('left mouse=select, ESC=undo last selection, right mouse=finish');

while (done==0)
    [xc,yc,button]=ginput(1);
    
    switch (button)
        case 1     % left button
            % Select point
            fprintf(1,'Selected point (%.3f,%.3f)\n',xc,yc);
            x=[x;xc];
            y=[y;yc];
            n_selected=n_selected+1;
        case 27      % ESC key
            % Undo last point
            if(n_selected > 0)
                fprintf(1,'Deleted last point\n');
                x(end)=[];
                y(end)=[];
                n_selected=n_selected-1;
            end
        case 3      % Right mouse button
            fprintf(1,'Ending\n');
            done=1;
            if(length(x)>0)
                % Terminate
                x=[x;x(1)];
                y=[y;y(1)];
            end
        otherwise
    end
    
    if(ishandle(crosses_h)) 
        %fprintf(1,'crosses_h is a handle\n');
        delete(crosses_h);
    end

    hold on;
    if(length(x)>0)
        crosses_h=plot([x;x(1)],[y;y(1)],'wo-',...
            'markersize',6,'linewidth',2);
    end
    hold off;
end        
        

