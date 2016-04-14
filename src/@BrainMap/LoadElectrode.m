function LoadElectrode( obj )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[filename,pathname]=uigetfile({'*.mat;*.txt','Data format (*.mat)'},'Please select electrode file');
fpath=[pathname filename];
if ~filename
    return;
end

if obj.mapObj.isKey(fpath)
    errordlg('Already loaded !');
    return
end

tmp=load(fpath,'-mat');

if ~isfield(tmp,'norm')
    tmp.norm=tmp.coor;
end

for i=1:size(tmp.coor,1)
    userdat.ind=i;
    userdat.select=false;
    
    [faces,vertices] = createContact3D(tmp.coor(i,:),tmp.norm(i,:),tmp.radius(i),tmp.thickness(i));
    
    mapval.handles(i)=patch('faces',faces,'vertices',vertices,...
        'facecolor',tmp.color(i,:),'edgecolor','none','UserData',userdat,...
        'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src),'facelighting','gouraud');
end
material dull;

num=obj.JFileLoadTree.addElectrode(fpath,true);

mapval.id='Electrode';
mapval.file=fpath;
mapval.ind=num;
mapval.coor=tmp.coor;
mapval.radius=tmp.radius;
mapval.thickness=tmp.thickness;
mapval.color=tmp.color;
mapval.norm=tmp.norm;

obj.mapObj([mapval.id,num2str(num)])=mapval;

end


