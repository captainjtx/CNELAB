function MeanReferenceFilter(obj)
omitMask=true;
[data,~,dataset,channel,sample]=get_selected_data(obj,omitMask);

data=data*(eye(size(data,2))-1/size(data,2)*ones(size(data,2),size(data,2)));

for i=1:size(data,2)
    obj.PreprocData{dataset(i)}(sample-obj.BufferStartSample+1,channel(i))=data(:,i);
end

obj.redrawChangeBlock('time');

end

