function remakeMontage(obj)
            %Assure Montage properties Coherence
            
            if iscell(obj.Montage_)
                if length(obj.Montage_)~=obj.DataNumber, error('If system is cell, it must be of same length than data');end
            else
                tmp=cell(1,obj.DataNumber);
                [tmp{:}]=deal(obj.Montage_);
                obj.Montage_=tmp;
            end
            
            for i=1:length(obj.Montage_)
                if ischar(obj.Montage_{i})
                    try
                        s=load(obj.Montage_{i});
                        obj.Montage_{i}=s.Montage;
                    catch  %#ok<CTCH>
                        obj.Montage_{i}=[];
                    end
                end
            end
            
            if isempty(obj.ChanNames_)
                obj.ChanNames_=cell(1,obj.DataNumber);
                [obj.ChanNames_{:}]=deal([]);
            end
            
            for i=1:obj.DataNumber
                if isempty(obj.ChanNames_{i})
                    obj.ChanNames_{i}=num2cell(1:size(obj.Data{i},2));
                    obj.ChanNames_{i}=cellfun(@num2str,obj.ChanNames_{i},'UniformOutput',false);
                    obj.ChanOrderMat{i}=eye(obj.ChanNumber(i));
                elseif ~isempty(obj.Montage{i})
                    
                    if all(ismember(obj.ChanNames_{i},obj.Montage_{i}(1).channames))
                        
                        obj.ChanOrderMat{i}=eye(obj.ChanNumber(i));
                        p=zeros(1,size(obj.ChanOrderMat{i},1));
                        for j=1:size(obj.ChanOrderMat{i},1)
                            for k=1:length(obj.ChanNames_{i})
                                if strcmpi(obj.Montage_{i}(1).channames{j},obj.ChanNames_{i}{k})
                                    p(j)=k;
                                end
                            end
                        end
                        obj.ChanOrderMat{i}(1:size(obj.ChanOrderMat{i},1),:)=obj.ChanOrderMat{i}(p(1:size(obj.ChanOrderMat{i},1)),:);
                        for j=1:length(obj.Montage_{i})
                            obj.Montage_{i}(j).mat=obj.Montage_{i}(j).mat*obj.ChanOrderMat{i};
                        end
                    elseif length(obj.ChanNames_{i})==length(obj.Montage_{i}(1).channames)
                        obj.ChanOrderMat{i}=eye(obj.ChanNumber(i));
                        obj.Montage_{i}=struct('name','Raw','mat',obj.ChanOrderMat{i},'channames',obj.ChanNames_(i));
                    end
                end
                if isempty(obj.Montage{i})
                    obj.ChanOrderMat{i}=eye(obj.ChanNumber(i));
                    obj.Montage_{i}=struct('name','Raw','mat',obj.ChanOrderMat{i},'channames',obj.ChanNames_(i));
                end
            end
            
        end