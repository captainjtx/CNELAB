function [x,y,z]=get_cursor(handles)
%datacursormode on
dcmObj = datacursormode(handles.figure1);
set(dcmObj,'SnapToDataVertex','on','Enable','on','DisplayStyle','window')
    loop = 1;
    while loop == 1
        pause;
        %waitforbuttonpress;
        point1 = getCursorInfo(dcmObj);
        try
            x = point1.Position(1);
            y = point1.Position(2);
            z = point1.Position(3);
 
            loop=0;
        catch
            loop=1;
        end
    end
   % set(dcmObj,'enable','off');
end
