% quat2rot
% Converts quaternion to equivalent rotation matrix
% R = quat2rot(q)
% where q=[qw qx qy qz]' . If point p = [0 px py pz]' as a quaternion, the
% operation q*p*q' is a rotation to another point t. The matrix R that
% performs the eqivalent transformation in the matrix mult operation R*p.
% 
function R = quat2rot(q)

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

% normalization
q=q./(sqrt(sum(q.*q)));
qw=q(1); qx=q(2); qx=q(3); qx=q(4);
sqw=q(1)*q(1);
sqx=q(2)*q(2);
sqy=q(3)*q(3);
sqz=q(4)*q(4);

R=zeros(3);
R(1,1)= sqx - sqy - sqz + sqw;
R(2,2)= -sqx + sqy - sqz + sqw;
R(3,3)= -sqx - sqy + sqz + sqw;

tmp1=q(2)*q(3); % qx*qy
tmp2=q(4)*q(1); % qz*qw
R(2,1)= 2.0 * (tmp1 + tmp2);
R(1,2)= 2.0 * (tmp1 - tmp2);

tmp1=q(2)*q(4); % qx*qz
tmp2=q(3)*q(1); % qy*qw

R(3,1) = 2.0 * (tmp1 - tmp2);
R(1,3) = 2.0 * (tmp1 + tmp2);

tmp1=q(3)*q(4); % qy*qz
tmp2=q(2)*q(1); % qx*qw

R(3,2) = 2.0 * (tmp1 + tmp2);
R(2,3) = 2.0 * (tmp1 - tmp2);

return;

