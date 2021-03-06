function MnuVideoStartEnd(obj)
%**************************************************************************
% Dialog box of video start and end
%**************************************************************************
title='Specify the start and end of the video';

def={num2str(obj.VideoStartTime),num2str(obj.VideoEndTime)};

prompt={'Video Start (s)','Video End (s)'};


answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

tmp=str2double(answer{1});
if isempty(tmp)||isnan(tmp)
    tmp=0;
end

obj.VideoStartTime=tmp;

tmp=str2double(answer{2});
if isempty(tmp)||isnan(tmp)
    tmp=[];
end

obj.VideoEndTime=tmp;
end

