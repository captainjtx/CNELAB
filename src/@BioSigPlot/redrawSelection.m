function redrawSelection(obj)

for i=1:length(obj.Axes)
    h=findobj(obj.Axes(i),'Type','rectangle');
    delete(h);
    
    DrawSelect(obj.Axes(i),obj.Selection,obj.Time,obj.WinLength);
    obj.SelRect(i)=rectangle('Parent',obj.Axes(i),'Position',[-1 0 .0001 .0001],...
        'EdgeColor','none','FaceColor',[.85 1 .85]); % Current Selection Rectangle
    
    h=findobj(obj.Axes(i),'Type','rectangle');
    uistack(h,'bottom');
end



end
function DrawSelect(axe,selection,t,dt)
% Draw the rectangle of selected time periods
% axe :axes to draw
% selection :  periods of selection
% t : start time to draw
% dt : time interval within there is drawing


xlim=get(axe,'XLim');
ylim=get(axe,'YLim');

for i=1:size(selection,2)
    if selection(2,i)>=t && selection(1,i)<=t+dt
        p=(selection(:,i)-t)*xlim(2)/dt;
        p(1)=max(0,p(1));
        rectangle('Parent',axe,'Position',[p(1) ylim(1) p(2)-p(1)+0.0000001 ylim(2)],'EdgeColor','none','FaceColor',[.85 1 .85]);
    end
end
end