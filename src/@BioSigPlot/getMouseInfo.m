function [nchan,ndata,yvalue,t]=getMouseInfo(obj)
xlim=obj.WinLength*obj.SRate;
ndata=0;nchan=0;
yvalue=zeros(1,length(obj.Axes));%for two axes
t=0;
for i=1:length(obj.Axes)
    pos=get(obj.Axes(i),'CurrentPoint');
    yvalue(i)=pos(1,2); %TODO adjust to the scale
    y_lim=get(obj.Axes(i),'Ylim');
    x_lim=get(obj.Axes(i),'Xlim');
    if pos(1,1)>=x_lim(1) && pos(1,1)<=xlim && pos(1,2)>=y_lim(1) && pos(1,2)<=y_lim(2)
        if strcmpi(obj.DataView,'Alternated')
            nchan=sum(obj.MontageChanNumber)-round(pos(1,2))+1;
            if nchan<=0, nchan=1; end
            if nchan>sum(obj.MontageChanNumber), nchan=sum(obj.MontageChanNumber); end
            ndata=rem(nchan-1,obj.DataNumber)+1;
            nchan=floor((nchan-1)/obj.DataNumber)+1;
        else
            if strcmpi(obj.DataView(1:3),'DAT')
                ndata=str2double(obj.DataView(4));
            else
                ndata=i;
            end
            nchan=obj.MontageChanNumber(ndata)-round(pos(1,2))+1;
            if nchan<=0, nchan=1; end
            if nchan>obj.MontageChanNumber(ndata), nchan=obj.MontageChanNumber(ndata); end
        end
        
        t=pos(1,1)/obj.SRate+obj.Time;
    end
end

nchan=round(nchan);
ndata=round(ndata);
end