function highlightSelectedEvents(obj)
if isempty(obj.Evts_)
    return
end
EventLines=obj.EventLines;
EventTexts=obj.EventTexts;
EventIndex=obj.EventDisplayIndex;
colors=obj.Evts_(:,3);
SelectedEvent=obj.SelectedEvent;
SelectedColor=obj.EventSelectColor;

for i=1:size(EventIndex,1)*size(EventIndex,2)
    if ishandle(EventLines(i))&&ishandle(EventTexts(i))
        set(EventLines(i),'Color',colors{EventIndex(i)});
        set(EventTexts(i),'Color',colors{EventIndex(i)});
    end
end

if isempty(SelectedEvent)
    return
end

for i=1:size(EventIndex,1)*size(EventIndex,2)
    if any(EventIndex(i)==SelectedEvent)
        set(EventLines(i),'Color',SelectedColor);
        set(EventTexts(i),'Color',SelectedColor);
        uistack(EventLines(i),'top');
        uistack(EventTexts(i),'top');
    end
end


end
