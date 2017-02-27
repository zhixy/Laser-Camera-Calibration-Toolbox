function pc = import_point_cloud_from_file(filename)
    str = strsplit(filename,'.');
    % 'ply' format is a standard one that can be read by MATLAB, so we use
    % built-in function--'pcread'
    % otherwise, we assume the the file is in ASICII format, and every row
    % is the coordinate of each point.
    % 
    if strcmp(str{numel(str)},'ply')
        pc = pcread(filename);
    else
        pc = pointCloud(importdata(filename));
    end
end