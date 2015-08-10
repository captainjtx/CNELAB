function h=tfmap_grid(fig,axe,t,f,tf,pos,dw,dh,channame,sl,sh,freq)
%TFMAP_GRID Summary of this function goes here
%   Detailed explanation goes here
%Orign of postion is top left corner
x=pos(1)-dw/2;
y=1-(pos(2)+dh/2);

text(x+dw/2,y+dh+0.008,channame,...
    'fontsize',8,'horizontalalignment','center','parent',axe,'interpreter','none')

h=axes('parent',fig,'units','normalized','Position',[x,y,dw,dh],'Visible','off');

imagesc('XData',t,'YData',f,'CData',10*log10(tf),'Parent',h);
set(h,'CLim',[sl sh]);
set(h,'XLim',[min(t) max(t)]);
set(h,'YLim',freq);

colormap(jet);


set(h,'Tag',['TFMapAxes-' channame]);


drawnow
end
