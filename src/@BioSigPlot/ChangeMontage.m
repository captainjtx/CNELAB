function ChangeMontage(obj,src,data,mtgref)

if strcmpi(get(src,'Checked'),'on')
    return
end

if strcmpi(mtgref,'end')
    mtgref=legnth(obj.Montage_{data});
end
for i=1:length(obj.MontageOptMenu{data})
    set(obj.MontageOptMenu{data}(i),'Checked','off');
end

set(src,'checked','on');

%keep mask if transit from 
if ~((obj.MontageRef_(data) == 1 && mtgref == 2) || (obj.MontageRef_(data) == 2 && mtgref == 1))
    obj.Mask_{data}=ones(obj.MontageChanNumber(data),1);
end
% if transit from raw to mean ref, update the montage to exclude mask
if obj.MontageRef_(data) == 1 && mtgref == 2
    mask = obj.Mask_{data};
    channum = sum(mask);
    totalchannum = size(obj.Montage_{data}(2).mat, 1);
    
    mat=eye(totalchannum)-1/channum*ones(totalchannum,totalchannum);
    mat(:, ~mask) = 0;
    obj.Montage_{data}(2).mat = mat;
end

obj.MontageRef_(data)=mtgref;

obj.ChanSelect2Edit_{data}=[];

obj.Gain_{data}=ones(obj.MontageChanNumber(data),1);



obj.Filtering_{data}=zeros(obj.MontageChanNumber(data),1);
obj.FilterLow_{data}=zeros(obj.MontageChanNumber(data),1);
obj.FilterHigh_{data}=zeros(obj.MontageChanNumber(data),1);
obj.FilterNotch_{data}=zeros(obj.MontageChanNumber(data),1);
resetFilterPanel(obj);

obj.ChanSelect2Display_{data}=1:size(obj.Montage{data}(mtgref).mat,1);
obj.DispChans_(data)=min(obj.DispChans_(data),size(obj.Montage{data}(mtgref).mat,1));
obj.FirstDispChans_(data)=1;

recalculate(obj);
ChangeGain(obj,[]);
remakeAxes(obj);
resetView(obj);
assignChannelGroupColor(obj);
redraw(obj);
redrawEvts(obj);

end