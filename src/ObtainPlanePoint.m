function [theta, alpha, minError, inliers] = ObtainPlanePoint(pc,point)

    %find 10 nearest points to the selected point
    %one is the point ifself
    dis = sqrt(sum(bsxfun(@minus,pc,point).^2,2));
%     [~,index] = sort(dis);
%     n_neighbour = 200;
%     nearest_points = pc(index(1:n_neighbour),:);
    nearest_points = pc(dis<0.05,:);
    n_neighbour = size(nearest_points,1);
    n_samples = 10;
    
    max_inliers = 0;
    inliers = [];
    
    for i=1:500
        temp = randperm(n_neighbour);
        index_samples = temp(1:n_samples);
        samples = nearest_points(index_samples,:);
        [n,p] = affine_fit(samples);
        
        index = find(abs((bsxfun(@minus,pc,p))*n)<0.002);
        if length(index)>max_inliers
            max_inliers = length(index);
            inliers = pc(index,:);
            theta = n;
            alpha = p*n;
        end
        
    end
    
    index = find(sqrt(sum(bsxfun(@minus,inliers,p).^2,2))<0.1);
    inliers = inliers(index,:);
    
    if(alpha<0)
        theta=-theta;
        alpha=-alpha;
    end

    minError = median(abs(bsxfun(@minus,inliers,mean(inliers,1))*n));
    
end

function [n,p] = affine_fit(X)
    %Computes the plane that fits best (lest square of the normal distance
    %to the plane) a set of sample points.
    %INPUTS:
    %
    %X: a N by 3 matrix where each line is a sample point
    %
    %OUTPUTS:
    %
    %n : a unit (column) vector normal to the plane
    %V : a 3 by 2 matrix. The columns of V form an orthonormal basis of the
    %plane
    %p : a point belonging to the plane
    %
    %NB: this code actually works in any dimension (2,3,4,...)
    %Author: Adrien Leygue
    %Date: August 30 2013
    
    %the mean of the samples belongs to the plane
    p = mean(X,1);
    
    %The samples are reduced:
    R = bsxfun(@minus,X,p);
    %Computation of the principal directions if the samples cloud
    [V,~] = eig(R'*R);
    %Extract the output from the eigenvectors
    n = V(:,1)/norm(V(:,1));
end