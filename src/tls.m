function [theta,alpha,e]=tls(Z)
% tls
% Computes tls estimate of hyperplane parameters
% [theta, alpha] = tls ( Z)
% Z is of form (p1'; p2'; ..) where pi is p-by-1 (dimension p)
% Computed hyperplane is of form theta' * p = alpha with alpha>0

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


p=size(Z,2);
n=size(Z,1);
centroid=mean(Z,1);
Z=Z-repmat(centroid,n,1);
[U,S,V]=svd(Z'*Z);
theta=U(:,p);
alpha=theta'*centroid';

if(alpha<0)
    theta=-theta;
    alpha=-alpha;
end

e=median( abs(Z*theta - alpha +centroid*theta));
return;
