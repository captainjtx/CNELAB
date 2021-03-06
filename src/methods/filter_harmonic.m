function data = filter_harmonic(data,freq,fs,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if length(varargin)==1
    order=varargin{1};
else
    order=2;
end
ext=min(fs*2,round(size(data,1)/2));

if freq<=1||freq>=fs/2-1
    return
end

for i=1:floor(fs/2/freq)
    f=freq*i;
    
    w1=(f-1)/fs*2;
    w2=(f+1)/fs*2;
    
    if w1<=0&&w2>0&&w2<1
        [b,a]=butter(order,w2,'high');
        data=cnelab_filter_symmetric(b,a,data,ext,0,'iir');
    elseif w2>=1&&w1>0&&w1<1
        [b,a]=butter(order,w1,'low');
        data=cnelab_filter_symmetric(b,a,data,ext,0,'iir');
    elseif w1==0&&w2==1
%         data=data;
    else
        [b,a]=butter(order,[w1,w2],'stop');
        data=cnelab_filter_symmetric(b,a,data,ext,0,'iir');
    end
end

end

