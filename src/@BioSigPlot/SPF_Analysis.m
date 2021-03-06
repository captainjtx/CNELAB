function SPF_Analysis(obj,method)
%Subspace Projection Filter
omitMask=true;
[data,chanNames,dataset,channel,sample]=get_selected_data(obj,omitMask);

channames{1}=chanNames;
renames=cell(size(chanNames));
for i=1:length(chanNames)
    renames{i}=['Recon-',chanNames{i}];
end
channames{3}=renames;

spnames=cell(size(chanNames));
for i=1:length(chanNames)
    spnames{i}=[method,'-',num2str(i)];
end
channames{2}=spnames;

if size(data,2)<15
    dataview='Vertical';
else
    dataview='Horizontal';
end
if strcmpi(method,'pca')
    var=data'*data;
    [V,D]=eig(var);
    
    [e,ID]=sort(diag(D),'descend');
    
    SV=V(:,ID);
    
    subspaceData=data*SV;
    reconData=data;
    
    mix=SV';
    demix=SV;
    weg=e;
elseif strcmpi(method,'tpca')
    
elseif strcmpi(method,'ica')
    
    prompt='Number of ICA:';
    
    title='ICA';
    
    
    answer=inputdlg(prompt,title,1,{num2str(size(data,2))});
    
    if isempty(answer)
        return
    else
        tmp=str2double(answer{1});
        if isempty(tmp)||isnan(tmp)
            tmp=size(data,2);
        end
        
        [icasig, A, W] = fastica(data','verbose', 'off', 'displayMode', 'off','numOfIC', tmp);
        reconData=data;
        subspaceData=icasig';
        
        mix=A';
        demix=W';
        
        weg=[];
        
        subspacename=cell(1,tmp);
        for i=1:tmp
            subspacename{i}=[method,'-',num2str(i)];
        end
        channames{2}=subspacename;
    end
end
obj.SPFObj=SPFPlot(method,data,subspaceData,reconData,mix,demix,weg,...
    'SRate',obj.SRate,...
    'WinLength',min(size(data,1)/obj.SRate,15),...
    'DataView',dataview,...
    'Gain',mean(obj.Gain_{obj.DisplayedData(1)}),...
    'ControlPanelDisplay','off',...
    'LockLayout','off',...
    'DisplayGauge','off',...
    'ChanNames',channames);
if isempty(obj.SPFObj)
    return
end

obj.SPFObj.sample=sample;
obj.SPFObj.channel=channel;
obj.SPFObj.dataset=dataset;

addlistener(obj.SPFObj,'MaskSubspace',@(src,evt)spf_selected_data(obj,dataset,channel,sample));

end

function spf_selected_data(obj,dataset,channel,sample)
fdata=obj.SPFObj.PreprocData{3};

%**************************************************************************
bufferSample=obj.BufferStartSample:obj.BufferEndSample;
[buf_ind,~]=ismember(bufferSample,sample);

for i=1:size(fdata,2)
    obj.PreprocData{dataset(i)}(buf_ind,channel(i))=fdata(bufferSample(buf_ind)-sample(1)+1,i);
end

obj.redrawChangeBlock('time');

end

