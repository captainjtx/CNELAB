function redrawEvts(obj)
if obj.RedrawEvtsSkip
    return
end

evts=obj.Evts_(obj.Evts2Display,:);

%Clear all the events displayed
for i=1:size(obj.EventLines,1)*size(obj.EventLines,2)
    if ishandle(obj.EventLines(i))
        delete(obj.EventLines(i))
    end
end

for i=1:size(obj.EventTexts,1)*size(obj.EventTexts,2)
    if ishandle(obj.EventTexts(i))
        delete(obj.EventTexts(i))
    end
end

if isempty(evts)
    obj.EventLines=[];
    obj.EventTexts=[];
    obj.EventDisplayIndex=[];
    return
end

EventLines=[];
EventTexts=[];
EventIndex=[];

for i=1:length(obj.Axes)
    [Elines,Etexts,Eindex]=DrawEvts(obj,obj.Axes(i),evts(:,1:2),obj.Time,obj.WinLength,...
        obj.SRate,evts(:,3),obj.SelectedEvent,obj.EventSelectColor,i);
    if ~isempty(Elines)
        EventLines(i,:)=Elines;
        EventTexts(i,:)=Etexts;
        EventIndex(i,:)=obj.Evts2Display(Eindex);
    end
end

obj.EventLines=EventLines;
obj.EventTexts=EventTexts;
obj.EventDisplayIndex=EventIndex;

highlightSelectedEvents(obj);

end

function [EventLines,EventTexts,EventIndex]=DrawEvts(obj,axe,evts,t,dt,SRate,colors,SelectedEvent,SelectedColor,axenum)
EventLines=[];
EventTexts=[];
EventIndex=[];
yl=get(axe,'Ylim');
xl=get(axe,'Xlim');
count=0;

for i=1:size(evts,1)
    if evts{i,1}>=t && evts{i,1}<=t+dt
        count=count+1;
        x=SRate*(evts{i,1}-t);
        EventLines(count)=line([x x],[0 2000],'parent',axe,'Color',colors{i});
        EventTexts(count)=text('Parent',axe,'position',[x+(xl(2)-xl(1))/400 yl(2)],'Color',colors{i},...
            'VerticalAlignment','Top','FontSize',12,'String',evts{i,2},'Editing','off','SelectionHighlight','on',...
            'ButtonDownFcn',@(src,evt)openText(obj,src,axenum),'DisplayName',['Event',num2str(count)]);
%         ...'Interpreter','none');
        EventIndex(count)=i;
    end
end

end
