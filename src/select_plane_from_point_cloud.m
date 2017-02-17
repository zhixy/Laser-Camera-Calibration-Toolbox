function handles = select_plane_from_point_cloud(handles,preview_filenames,ind_preview)

fig = figure;
dcm_obj = datacursormode(fig);

h = uicontrol('Position',[20 20 100 40],'String','Continue',...
              'Callback',@continue_callback);
h1 = uicontrol('Position',[220 20 100 40],'String','back',...
              'Enable','off','Callback',@back_callback);
          
point = cell(1,numel(preview_filenames));
for i=1:numel(preview_filenames)
    disp(preview_filenames{i});
    done = 0;
    str = strsplit(preview_filenames{i},'.');
    if strcmp(str{numel(str)},'ply')
        pc = pcread(preview_filenames{i});
    else
        pc = pointCloud(importdata(preview_filenames{i}));
    end
    pcshow(pc);
    
    uiwait(gcf);
   
end
close(gcf);

% for i=1:length(ind_preview)
%     [theta,alpha,minError]=tls_robust(pc_in_plane{ind_preview(i)});
%     handles.user_selected_planes{ind_preview(i)}.theta = theta;
%     handles.user_selected_planes{ind_preview(i)}.alpha = alpha;
%     handles.user_selected_planes{ind_preview(i)}.e = minError;
%     handles.user_selected_planes{ind_preview(i)}.inliers = pc_in_plane{ind_preview(i)};
% end

function continue_callback(objectHandle , eventData )
    if done == 0
        cur_info = getCursorInfo(dcm_obj);
        if isfield(cur_info,'Position')
            point{i} = cur_info.Position;
            arrayPos=find(handles.active_image_numbers==ind_preview(i));
            
            [theta, alpha, minError, inliers] = ObtainPlanePoint(pc.Location,point{i});
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