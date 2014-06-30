function ChangeSliders(obj,src,evt)
if src==obj.Fig && ~isempty(obj.Sliders) && ~isa(src,'figure')
    if length(obj.Sliders)==1
        if obj.ChanLink || any(strcmpi(obj.DataView,{'Superimposed','Alternated','Vertical','Horizontal'}))
            obj.FirstDispChans(:)=round(obj.FirstDispChans(:)+evt.VerticalScrollCount);
        else
            n=str2double(obj.DataView(4));
            obj.FirstDispChans(n)=round(obj.FirstDispChans(n)+evt.VerticalScrollCount);
        end
    end
    if length(obj.Sliders)>1
        n=obj.MouseDataset;
        if n~=0
            obj.FirstDispChans(n)=round(obj.FirstDispChans(n)+evt.VerticalScrollCount);
        end
    end
else
    if isa(src,'figure')
        if length(obj.Sliders)==1
            src=obj.Sliders;
        else
            src=obj.Sliders(obj.Axes==evt.Axes);
        end
        v=get(evt.Axes,'Ylim');
        if strcmpi(obj.DataView,'Alternated')
            set(src,'value',v(1)/obj.DataNumber);
        else
            set(src,'value',v(1));
        end
    end
    if length(obj.Sliders)==1
        if obj.ChanLink || any(strcmpi(obj.DataView,{'Superimposed','Alternated','Vertical','Horizontal'}))
            obj.FirstDispChans(:)=round(get(src,'max')-get(src,'value')+1);
        else
            n=str2double(obj.DataView(4));
            obj.FirstDispChans(n)=round(get(src,'max')-get(src,'value')+1);
        end
    end
    if length(obj.Sliders)>1
        obj.FirstDispChans(obj.Sliders==src)=round(get(src,'max')-get(src,'value')+1);
    end
end
end