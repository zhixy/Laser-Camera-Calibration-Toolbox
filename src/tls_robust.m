function [theta,alpha,minError]=tls_robust(Z,ntrials,nsamples)
% tls_robust
% Finds robust estimate of hyperplane parameters for given data
% using RANSAC
% theta * p = alpha , alpha>0

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

n=size(Z,1);
p=size(Z,2);
switch nargin
    case 1
        ntrials=500; nsamples=max(floor(n/3),p);
    case 2
        nsamples=max(floor(n/3),p);
end

if (nargin==1)
    ntrials=500;
end
mincost=1.0e6;

for i=1:ntrials
    temp=randperm(n);
    temp=temp(1:nsamples);
    [theta,alpha,cost]=tls(Z(temp,:));
    
    if(i==1 || cost<mincost)
        theta_best=theta;
        alpha_best=alpha;
        mincost=cost;
    end
end

theta=theta_best; alpha=alpha_best;
minError=mincost;
return;
