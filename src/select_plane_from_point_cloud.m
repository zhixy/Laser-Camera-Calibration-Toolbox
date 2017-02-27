function handles = select_plane_from_point_cloud(handles,preview_filenames,ind_preview)

fig = figure;
dcm_obj = datacursormode(fig);

h = uicontrol('Position',[20 20 100 40],'String','Continue',...
              'Callback',@continue_callback);
h1 = uicontrol('Position',[220 20 100 40],'String','back',...
              'Enable','off','Callback',@back_callback);
          
for i=1:numel(preview_filenames)
    disp(preview_filenames{i});
    done = 0;
    pc = import_point_cloud_from_file(preview_filenames{i});
    pcshow(pc);
    title(preview_filenames{i}, 'interpreter', 'none');
    
    uiwait(gcf);
   
end
close(gcf);


function continue_callback(objectHandle , eventData )
    if done == 0
        cur_info = getCursorInfo(dcm_obj);
        if isfield(cur_info,'Position')
            arrayPos=find(handles.active_image_numbers==ind_preview(i));
            
            [theta, alpha, minError, inliers] = ObtainPlanePoint(pc.Location,cur_info.Position);
%             [theta,alpha,minError] = tls_robust(inliers);
            handles.user_selected_planes{arrayPos}.theta = theta;
            handles.user_selected_planes{arrayPos}.alpha = alpha;
            handles.user_selected_planes{arrayPos}.e = minError;
            handles.user_selected_planes{arrayPos}.inliers = inliers;
            
            pcshow(pointCloud(inliers));
            h1.Enable = 'on';
            done = 1;
        end
    else
        h1.Enable = 'off';
        uiresume(gcbf);
    end
        
    
end 
function back_callback(objectHandle , eventData )
    
    pcshow(pc);
    done = 0; 
    objectHandle.Enable = 'off';
end 

end