function d=preprocessedData(obj,varargin)
% t=ceil(obj.Time*obj.SRate+1):min(ceil((obj.Time+obj.WinLength)*obj.SRate),size(obj.Data{1},1));
if nargin==2
    n=varargin{1};
    d=double(obj.Data{n}*(obj.Montage{n}(obj.MontageRef(n)).mat)');
    chanind = 1:size(d,2);
elseif nargin==3
    n=varargin{1};
    %make sure the data is montage transformed
    d=double(varargin{2});
    chanind = 1:size(d,2);
elseif nargin==4
    n=varargin{1};
    %make sure the data is montage transformed
    d=double(varargin{2});
    chanind = varargin{3};
else
    d=[];
    return
end

fs=obj.SRate;
ext=min(2*obj.SRate,round(size(d,1)/2));
% ext=0;

order=obj.FilterOrder;

notch_single=strcmpi(get(obj.MenuNotchFilterSingle,'checked'),'on');

a=cell(size(d,2),1);
b=cell(size(d,2),1);
fn=obj.FilterNotch{n};
fcum=obj.FilterCustomIndex{n};

fchan=[];
for i=1:length(chanind)
    c = chanind(i);
    if obj.Filtering{n}(c)
        fl=obj.FilterLow{n}(c);
        fh=obj.FilterHigh{n}(c);
        
        if fl==0||isempty(fl)||isnan(fl)||isinf(fl)
            if fh~=0
                if fh<(fs/2)
                    [b{i}{1},a{i}{1}]=butter(order,fh/(fs/2),'low');
                end
            end
        else
            if fh==0||isempty(fh)||isnan(fh)||isinf(fh)
                [b{i}{1},a{i}{1}]=butter(order,fl/(fs/2),'high');
            else
                if fl<fh
                    [b{i}{1},a{i}{1}]=butter(order,[fl,fh]/(fs/2),'bandpass');
                elseif fl>fh
                    [b{i}{1},a{i}{1}]=butter(order,[fh,fl]/(fs/2),'stop');
                end
            end
        end
        
        if ~isempty(b{i})
            if isempty(a{i})
                a{i}{1}=1;
            end
        end
        
        if ~isnan(fn(c))&&fn(c)~=0
            if fn(c)>1&&fn(c)<fs/2-1
                if notch_single
                    [notch_b,notch_a]=butter(order,[fn(c)-1,fn(c)+1]/(fs/2),'stop');
                    b{i}=cat(1,b{i},{notch_b});
                    a{i}=cat(1,a{i},{notch_a});
                else
                    [notch_b,notch_a]=butter_harmonic(fn(c),fs,order);
                    b{i}=cat(1,b{i},notch_b);
                    a{i}=cat(1,a{i},notch_a);
                end
            end
        end
        
        [custom_b,custom_a]=applyCustomFilters(obj,fcum(i));
        if custom_b~=1||custom_a~=1
            b{i}=cat(1,b{i},{custom_b});
            a{i}=cat(1,a{i},{custom_a});
        end
        
        if ~isempty(b{i})
            fchan=cat(1,fchan,i);
        end
    end
end
%multithreaded filter 
if ~isempty(fchan)
    fd=d(:,fchan);
    fd=wextend('ar','sym',fd,ext,'b');
    
    ja=a(fchan);
    jb=b(fchan);
    
    if isunix
        fd=UnixMultiThreadedFilter(jb,ja,fd);
    elseif ispc
        fd=WinMultiThreadedFilter(jb,ja,fd);
%     else
%         fd=FastFilter(jb,ja,fd);
    end
    d(:,fchan)=fd(ext+1:end-ext,:);
end

%apply subspace filter
if ~isempty(obj.SPFObj)&&isvalid(obj.SPFObj)&&isa(obj.SPFObj,'SPFPlot')
    sample=obj.SPFObj.sample;
    channel=obj.SPFObj.channel;
    dataset=obj.SPFObj.dataset;
    channel=channel(dataset==n);
    
    if ~isempty(channel)
        d(sample,channel)=obj.SPFObj.subspacefilter(d(sample,channel));
    end
end
end

function [b,a]=applyCustomFilters(obj,fcum)
if fcum==1||fcum==2
    b=1;
    a=1;
    return
else
    CustomFilters=obj.CustomFilters;
    
    if isfield(CustomFilters{fcum-2},'fir')
        fir=CustomFilters{fcum-2}.fir;
        for i=1:length(fir)
            a=1;
            b=fir(i).h;
        end
        
    elseif isfield(CustomFilters{fcum-2},'iir')
        
        iir=CustomFilters{fcum-2}.iir;
        for i=1:length(iir)
            a=iir(i).a;
            b=iir(i).b;
        end
    end
end

end
