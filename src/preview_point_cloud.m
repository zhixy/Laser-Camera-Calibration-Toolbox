function preview_point_cloud(preview_filenames)

fig = figure;
dcm_obj = datacursormode(fig);

h = uicontrol('Position',[220 20 100 40],'String','Next',...
              'Callback',@Next_callback);
h1 = uicontrol('Position',[20 20 100 40],'String','Previous',...
              'Enable','off','Callback',@Previous_callback);
h2 = uicontrol('Position',[420 20 100 40],'String','Close',...
              'Callback',@Close_callback);
          
n = numel(preview_filenames);
if n<1
    disp('no point clouds to be showed');
    close(gcf);
    return;
end

current = 1;
close_figure = false;
while(true)  
    if close_figure
        break;
    end
    pc = import_point_cloud_from_file(preview_filenames{current});
    pcshow(pc); 
    title(preview_filenames{current}, 'interpreter', 'none');
    
    if current == n
        h.Enable = 'off';
    else
        h.Enable = 'on';
    end
    
    if current == 1
        h1.Enable = 'off';
    else
        h1.Enable = 'on';
    end
    
    uiwait(gcf);
    
end

close(gcf);



function Next_callback(objectHandle , eventData )
    current = current+1;   
    uiresume(gcbf);
    
end 
function Previous_callback(objectHandle , eventData )
    current = current-1;    
    uiresume(gcbf);
end 
function Close_callback(objectHandle , eventData )
    close_figure = true;
    uiresume(gcbf);
end 
end