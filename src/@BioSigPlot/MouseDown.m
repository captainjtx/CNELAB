function MouseDown(obj)
t=floor((obj.MouseTime-obj.Time)*obj.SRate);

[nchan,ndata,yvalue]=getMouseInfo(obj); %#ok<ASGLU>
time=obj.MouseTime;
Modifier=get(obj.Fig,'CurrentModifier');

if obj.UponText
    
    %     if strcmpi(get(obj.Fig,'SelectionType'),'open')
    %
    %         return
    %     end
    return
end
if isempty(obj.MouseMode)
    %**********************************************************************
    set(obj.Fig,'pointer','hand');
    %Cancel text edit status
    if obj.EditMode==1
        obj.EditMode=0;
        EventList=obj.Evts_;
        for i=1:size(obj.EventDisplayIndex,2)
            EventList{obj.EventDisplayIndex(1,i),2}=get(obj.EventTexts(1,i),'String');
        end
        obj.Evts=EventList;
        return
    end
    %Multi Channel Selection
    if ndata
        if isempty(Modifier)
            %**********************************************************************
            %Single Event Selection
            if ~isempty(obj.EventLines)
                for i=1:size(obj.EventLines,1)*size(obj.EventLines,2)
                    if ishandle(obj.EventLines(i))&&obj.EventLines(i)
                        XData=get(obj.EventLines(i),'XData');
                        eventIndex=XData(1);
                        if abs(t-eventIndex)<50
                            newSelect=obj.EventDisplayIndex(i);
                            obj.SelectedEvent=newSelect;
                            obj.DragMode=1;
                            return
                        end
                    end
                end
            end
            %**********************************************************************
            %Sigle Channel Selection
            obj.ChanSelect2Edit{ndata}=nchan;
            return
        elseif ismember('control',Modifier)||ismember('command',Modifier)
            %**********************************************************************
            %Cancel region selection
            if ~isempty(obj.Selection)
                for i=1:size(obj.Selection,2)
                    if time>=obj.Selection(1,i)&&time<=obj.Selection(2,i)
                        obj.Selection(:,i)=[];
                        redrawSelection(obj);
                        return
                    end
                end
            end
            
            %Event Line selection
            if ~isempty(obj.EventLines)
                for i=1:size(obj.EventLines,1)*size(obj.EventLines,2)
                    if ishandle(obj.EventLines(i))&&obj.EventLines(i)
                        XData=get(obj.EventLines(i),'XData');
                        eventIndex=XData(1);
                        if abs(t-eventIndex)<50
                            newSelect=obj.EventDisplayIndex(i);
                            if ~isempty(obj.SelectedEvent)
                                if any(newSelect==obj.SelectedEvent)
                                    obj.SelectedEvent(newSelect==obj.SelectedEvent)=[];
                                    
                                else
                                    obj.SelectedEvent=cat(1,obj.SelectedEvent,newSelect);
                                end
                            else
                                obj.SelectedEvent=newSelect;
                            end
                            obj.DragMode=1;
                            return
                        end
                    end
                end
            end
            
            
            [flag,loc]=ismember(nchan,obj.ChanSelect2Edit{ndata});
            if flag
                obj.ChanSelect2Edit{ndata}(loc)=[];
            else
                obj.ChanSelect2Edit{ndata}=[obj.ChanSelect2Edit{ndata};nchan];
            end
            
            %**********************************************************************
            
        elseif ismember('shift',Modifier)
            if isempty(obj.ChanSelect2Edit{ndata})
                obj.ChanSelect2Edit{ndata}=linspace(nchan,1,abs(1-nchan)+1)';
            else
                tmp=obj.ChanSelect2Edit{ndata};
                start=tmp(end);
                [flag,loc]=ismember(linspace(start,nchan,abs(start-nchan)+1)',tmp);
                tmp(loc(loc~=0))=[];
                tmp=[tmp;linspace(nchan,start,abs(start-nchan)+1)'];
                pChan=nchan;
                pChanLoc=[];
                while(1)
                    if start>nchan
                        pChan=pChan-1;
                    else
                        pChan=pChan+1;
                    end
                    [flag,loc]=ismember(pChan,tmp);
                    if flag
                        pChanLoc=cat(1,pChanLoc,loc);
                    else
                        break;
                    end
                end
                
                if ~isempty(pChanLoc)
                    tmp(pChanLoc)=[];
                end
                
                obj.ChanSelect2Edit{ndata}=tmp;
            end
        end
    end
    
elseif strcmpi(obj.MouseMode,'Select')
    if length(Modifier)==1
        if strcmpi('control',Modifier{1})||strcmpi('command',Modifier{1})
            %**********************************************************************
            %Cancel region selection
            if ~isempty(obj.Selection)
                for i=1:size(obj.Selection,2)
                    if time>=obj.Selection(1,i)&&time<=obj.Selection(2,i)
                        obj.Selection(:,i)=[];
                        redrawSelection(obj);
                        return
                    end
                end
            end
        end
    end
    if(strcmpi(get(obj.Fig,'SelectionType'),'open'))
        
        obj.SelectionStart=[];%Cancel first click
        i=1;
        while i<=size(obj.Selection,2)
            if time<=obj.Selection(2,i) && time>=obj.Selection(1,i)
                obj.Selection(:,i)=[];
            else
                i=i+1;
            end
        end
        redrawSelection(obj);
    else
        if isempty(obj.SelectionStart)
            obj.SelectionStart=time;
        else %Second click
            tempSelection=sort([obj.SelectionStart;time]);
            for i=1:size(obj.Selection,2)
                if tempSelection(1,1)<=obj.Selection(2,i) && tempSelection(2,1)>=obj.Selection(1,i)
                    tempSelection(:,1)=[min([tempSelection(1,1) obj.Selection(1,i)]) max([tempSelection(2,1) obj.Selection(2,i)])];
                else
                    tempSelection(:,end+1)=obj.Selection(:,i); %#ok<AGROW>
                end
            end
            obj.Selection=round(100*sortrows(tempSelection',1)')/100;
            
            
            obj.SelectionStart=[];
            redrawSelection(obj);
        end
    end
elseif strcmpi(obj.MouseMode,'Annotate')
    
    if isempty(obj.SelectedFastEvt)
        newEvent={time,'New Event',obj.EventDefaultColor,0};
        addNewEvent(obj,newEvent);
    else
        newEvent={time,obj.FastEvts{obj.SelectedFastEvt,1},obj.FastEvts{obj.SelectedFastEvt,2},1};
        addNewEvent(obj,newEvent);
    end
    
end

end