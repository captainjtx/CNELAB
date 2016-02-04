%CSP test
clc
clear
% fname1='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/S1/Close.mat';
% fname2='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/S1/Open.mat';



% fname1='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/S2/Close.mat';
% fname2='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/S2/Open.mat';

fname1='/Users/tengi/Desktop/Projects/data/BMI/abduction/S1/Abd.mat';
fname2='/Users/tengi/Desktop/Projects/data/BMI/abduction/S1/Add.mat';

% movements={'Close','Open'};
movements={'Abd','Add'};

segments{1}=load(fname1);
segments{2}=load(fname2);

fs=segments{1}.(movements{1}).fs;
channelnames=segments{1}.(movements{1}).channame;

for i=1:length(channelnames)
    t=channelnames{i};
    channelindex(i)=str2double(t(2:end));
end

path=fileparts(fname1);

% csp_max_min='max','min';

%up-gamma band
% lc=60;
% hc=200;
% csp_max_min='max';%CSP--Move/Rest

%alpha band
% lc=8;
% hc=13;
%beta band
% lc=13;
% hc=30;

%alpha&beta band
lc=8;
hc=30;
csp_max_min='min';%CSP--Move/Rest

%all band
% lc=8;
% hc=200;

% baseline_time=[0 1.7];
baseline_time=[0.6 1.3];
% baseline_time=[1.3,1.7];
baseline_sample=round(baseline_time(1)*fs+1):round(baseline_time(2)*fs);
move_time=[1.3 2];
% move_time=[1.7 2.5];
move_sample=round(move_time(1)*fs):round(move_time(2)*fs);

%CSP parameters
NF=1;
%Desired sparsity of the filter
SpL=5;
%**************************************************************************

%Filter the data===========================================================
for i=1:length(movements)
    seg=segments{i}.(movements{i}).data;
    for j=1:size(seg,3)
        [b,a]=butter(2,[lc hc]/(fs/2));
        segments{i}.(movements{i}).data(:,:,j)=filter_symmetric(b,a,seg(:,:,j),fs,0,'iir');
    end
end
%==========================================================================
for i=1:length(movements)
    seg=segments{i}.(movements{i}).data;
    X=[];
    Y=[];
    %Rest
    %     for k=1:size(seg,3)
    %         for m=1:size(seg,2)
    %             Y(:,m,k)=abs(hilbert(seg(baseline_sample,m,k)));
    %         end
    %     end
    
    Y=seg(baseline_sample,:,:);
    %Move
    
    
    %     for k=1:size(seg,3)
    %         for m=1:size(seg,2)
    %             X(:,m,k)=abs(hilbert(seg(move_sample,m,k)));
    %         end
    %     end
    X=seg(move_sample,:,:);
    
    %Sparse CSP, recursive weight elimination
    
    if strcmpi(csp_max_min,'max')
           F = hist_bootstrap_filter( X,Y,SpL,2,40,100 );
    else
           F = hist_bootstrap_filter( Y,X,SpL,2,40,100 );
    end

    channames=cell(1,NF);
    
    for n=1:NF
        channames{n}=['CSP ' num2str(n)];
    end
    %**********************************************************************
    dw=30;
    dh=30;
    
    interval=30;
    figpos=[0,0,400*NF,335];
    %======================================================================
    chan_order=channelindex;
    
    axe1_pattern=zeros(1,NF);
    axe1_filter=zeros(1,NF);
    clim1_pattern=[inf,-inf];
    clim1_filter=[inf,-inf];
    
    hf=figure('Name',[movements{i},' ',csp_max_min,' Filter'],'Position',figpos);
    
    
    
    for m=1:NF
        fid=fopen(fullfile(path,[movements{i},'_scsp_',csp_max_min,num2str(m),'.smw']),'w');
        axe1_filter(m)=axes('Parent',hf,'Units','Pixels','Position',[(m-1)*(interval+dw*12)+interval/2,interval/2,12*dw,10*dh]);
        [fmax,fmin]=gauss_interpolate_120_grid(axe1_filter(m),F(:,m)/max(F(:,m)),chan_order,[],dw,dh,[],1);
%         title(['CSP' num2str(m),' Filter'])
        if fmax>clim1_filter(2)
            clim1_filter(2)=fmax;
        end
        if fmin<clim1_filter(1)
            clim1_filter(1)=fmin;
        end
        
        val=F(:,m)/max(F(:,m));
        for c=1:length(val)
            fprintf(fid,'%s,%f\n',channelnames{c},val(c));
        end
        fclose(fid);
    end
    set(hf,'color','w');
   
%     export_fig(hf,'-png','-r300',get(hf,'Name'));
%     close(hf)
end


