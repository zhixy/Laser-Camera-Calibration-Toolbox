function q=rot2quat(R)
% rot2quat
% Converts (3-by-3) rotation matrix to equivalent quaternion. If matrix
% operation R*p rotates point p to another point, the quaternion
% representing the equivalent rotation through quat operation q*p*q' is
% what is returned by this function
% q = rot2quat(R)

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

t=1+trace(R);
q=zeros(4,1);
if(t>0)
    s=0.5/sqrt(t);
    % qw
    q(1) = 0.5*sqrt(t);
    % qx, qy, qz
    q(2) = (R(3,2)-R(2,3))*s;
    q(3) = (R(1,3)-R(3,1))*s;
    q(4) = (R(2,1)-R(1,2))*s;
else
    fprintf(1,'ERROR: rot2quat: Trace of R < 0\n');
end 
