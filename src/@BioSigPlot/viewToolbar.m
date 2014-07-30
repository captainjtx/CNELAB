function viewToolbar(obj)

obj.IconPlay=imread('play.bmp');
obj.IconPause=imread('pause.bmp');

obj.TogHorizontal=uitoggletool(obj.Toolbar,'CData',imread('horizontal.bmp'),...
    'TooltipString','Horizontal','separator','on',...
    'ClickedCallback',@(src,evt) set(obj,'DataView','Horizontal'));

obj.TogVertical=uitoggletool(obj.Toolbar,'CData',imread('vertical.bmp'),...
    'TooltipString','Vertical','ClickedCallback',@(src,evt) set(obj,'DataView','Vertical'));

obj.BtnPlayBackward=uitoggletool(obj.Toolbar,'CData',imread('slower.bmp'),'separator','on',...
    'ClickedCallback',@(src,evt) PlayBackward(obj));
obj.TogPlay=uitoggletool(obj.Toolbar,'CData',obj.IconPlay,...
    'ClickedCallback',@(src,evt) StartPlay(obj),'State','off');
obj.BtnPlayForward=uitoggletool(obj.Toolbar,'CData',imread('faster.bmp'),...
    'ClickedCallback',@(src,evt) PlayForward(obj));
obj.TogVideo=uitoggletool(obj.Toolbar,'CData',imread('video.bmp'),'TooltipString','Video Window',...
    'ClickedCallback',@(src,evt) WinVideoFcn(obj,src));

end