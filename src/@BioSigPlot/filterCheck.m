function filterCheck(obj)

%do not require recalculate and redraw
obj.Filtering_=obj.applyPanelVal(obj.Filtering_,get(obj.ChkFilter,'Value'));

val=str2double(get(obj.EdtFilterLow,'String'));
if isnan(val)
    val=-inf;
end
obj.FilterLow_=obj.applyPanelVal(obj.FilterLow_,val);

val=str2double(get(obj.EdtFilterHigh,'String'));
if isnan(val)
    val=inf;
end
obj.FilterHigh_=obj.applyPanelVal(obj.FilterHigh_,val);

obj.FilterNotch_=obj.applyPanelVal(obj.FilterNotch_,str2double(get(obj.EdtFilterNotch,'String')));

obj.FilterCustomIndex_=obj.applyPanelVal(obj.FilterCustomIndex,get(obj.PopFilter,'value'));

%require recalculate and redraw

val=get(obj.ChkFilter,'Value');
obj.Filtering=obj.applyPanelVal(obj.Filtering_,val);

if val, offon='on'; else offon='off'; end
set(obj.EdtFilterLow,'Enable',offon)
set(obj.EdtFilterHigh,'Enable',offon)
set(obj.EdtFilterNotch,'Enable',offon)
set(obj.PopFilter,'Enable',offon)

end