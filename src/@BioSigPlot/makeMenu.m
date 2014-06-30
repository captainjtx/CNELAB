function makeMenu(obj)
obj.MenuFile=uimenu(obj.Fig,'Label','File');
obj.MenuExport=uimenu(obj.MenuFile,'Label','Export');
obj.MenuExportFigure=uimenu(obj.MenuExport,'Label','Figure');
obj.MenuExportFigureMirror=uimenu(obj.MenuExportFigure,'Label','Mirror','Callback',@(src,evt) obj.ExportToFigure);
obj.MenuExportFigureAdvanced=uimenu(obj.MenuExportFigure,'Label','Advanced','Callback',@(src,evt) obj.ExportToWindow);
obj.MenuExportEvents=uimenu(obj.MenuExport,'Label','Events','Callback',@(src,evt) obj.ExportEvents);
obj.MenuImport=uimenu(obj.MenuFile,'Label','Import');
obj.MenuImportDataSet=uimenu(obj.MenuImport,'Label','DataSet','Callback',@(src,evt) obj.ImportDataSet);
obj.MenuImportEvents=uimenu(obj.MenuImport,'Label','Events','Callback',@(src,evt) obj.ImportEvents);
obj.MenuImportVideo=uimenu(obj.MenuImport,'Label','Video','Callback',@(src,evt) obj.ImportVideo);
obj.MenuCopy=uimenu(obj.MenuFile,'Label','Copy','Enable','off');
%**************************************************************************
%First Order Menu--------------------------------------------------Settings 
obj.MenuSettings=uimenu(obj.Fig,'Label','Settings');
obj.MenuCommands=uimenu(obj.MenuSettings,'Label','Command List',...
    'Callback',@(src,evts) listdlg('ListString',obj.Commands,'ListSize',[700 500],'PromptString','List of commands'));
obj.MenuConfigurationState=uimenu(obj.MenuSettings,'Label','Configuration file','Callback',@(src,evt) ConfigWindow(obj));
obj.MenuPlaySpeed=uimenu(obj.MenuSettings,'Label','Speed for play','Callback',@(src,evt) MnuPlay(obj));
obj.MenuChan=uimenu(obj.MenuSettings,'Label','Channels per page','Callback',@(src,evt) MnuChan2Display(obj));
obj.MenuTime2disp=uimenu(obj.MenuSettings,'Label','Duration per page','Callback',@(src,evt) MnuTime2Display(obj));
obj.MenuChanLink=uimenu(obj.MenuSettings,'Label','Dataset link',...
    'Callback',@(src,evt) set(obj,'ChanLink',~obj.ChanLink));
%Second Order Menu----------------------------------------------------Color
obj.MenuColor=uimenu(obj.MenuSettings,'Label','Color');
obj.MenuColorCanvas=uimenu(obj.MenuColor,'Label','Canvas',...
    'Callback',{@CanvasColorChange,obj});
obj.MenuColorLines=uimenu(obj.MenuColor,'Label','Lines',...
    'Callback',{@LineColorChange,obj});

obj.MenuDisplay=uimenu(obj.Fig,'Label','Display');
obj.MenuInsideTicks=uimenu(obj.MenuDisplay,'Label','Put ticks inside the graph',...
    'Callback',@(src,evt) set(obj,'InsideTicks',~obj.InsideTicks));
obj.MenuXGrid=uimenu(obj.MenuDisplay,'Label','Show XGrid',...
    'Callback',@(src,evt) set(obj,'XGrid',~obj.XGrid));
obj.MenuYGrid=uimenu(obj.MenuDisplay,'Label','Show YGrid',...
    'Callback',@(src,evt) set(obj,'YGrid',~obj.YGrid));
obj.MenuEventsDisplay=uimenu(obj.MenuDisplay,'Label','Show Events',...
    'Callback',@(src,evt) set(obj,'EventsDisplay',~obj.EventsDisplay));
end

function CanvasColorChange(src,evt,obj)

obj.AxesBackgroundColor=uisetcolor(obj.AxesBackgroundColor,'Axes Background Color');

end

function LineColorChange(src,evt,obj)

obj.NormalModeColor=uisetcolor(obj.NormalModeColor,'Line Color');

end