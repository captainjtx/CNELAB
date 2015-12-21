%CSP test
clc
clear
% fname1='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Ma Li/Close.mat';
% fname2='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Ma Li/Open.mat';

fname1='/Users/tengi/Desktop/Projects/data/BMI/abduction/lima/Abd.mat';
fname2='/Users/tengi/Desktop/Projects/data/BMI/abduction/lima/Add.mat';


% fname='/Users/tengi/Desktop/Projects/data/BMI/handopenclose/Xu Yun/neuroSegs_PCA.mat';

% fname='/Users/tengi/Desktop/Projects/data/BMI/abduction/lima/segments.mat';

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



% csp_max_min='max','min';

%up-gamma band
lc=60;
hc=200;
csp_max_min='max';%CSP--Move/Rest

%alpha band
% lc=8;
% hc=13;
%beta band
% lc=13;
% hc=30;

%alpha&beta band
% lc=8;
% hc=30;
% csp_max_min='min';%CSP--Move/Rest

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

NF_oneside=3;

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
    
    Cx=0;
    Cy=0;
    
    for t=1:size(seg,3)
        ctmp=cov(X(:,:,t));
        %         Cx=Cx+ctmp/trace(ctmp);
        %           ctmp=X(:,:,t)'*X(:,:,t);
        Cx=Cx+ctmp/trace(ctmp);
        
        %         disp('Cx')
        %         disp(max(eig(ctmp))/min(eig(ctmp)))
        %         subplot(1,2,1)
        %         plot(eig(ctmp/trace(ctmp)))
        %         corrmap=corrcoef(X(:,:,t));
        %         corrmap(abs(corrmap)<0.85)=0;
        %         imagesc(corrmap,[-1 1]);
        %         colorbar
        %         title('Movement')
        
        ctmp=cov(Y(:,:,t));
        %         Cy=Cy+ctmp/trace(ctmp);
        %           ctmp=Y(:,:,t)'*Y(:,:,t);
        Cy=Cy+ctmp/trace(ctmp);
        %         disp('Cy')
        %         disp(max(eig(ctmp))/min(eig(ctmp)))
        
        %         subplot(1,2,2)
        %         plot(eig(ctmp/trace(ctmp)));
        %         corrmap=corrcoef(Y(:,:,t));
        %         corrmap(abs(corrmap)<0.85)=0;
        %         imagesc(corrmap,[-1 1]);
        %         colorbar
        %         title('Rest')
        
        %         pause
    end
    
    Cx=Cx/size(seg,3);
    Cy=Cy/size(seg,3);
    
    %Generalized Eigen-Value problem
    %See Simultaneous Diagonalization
    %Lmd=Move/Rest
    [W,Lmd]=eig(Cx,Cy);
    
    [Lmd,id]=sort(diag(Lmd),'descend');
    
    figure('Name',['Generalized Eigenvalue ',movements{i}])
    plot(Lmd,'.','MarkerSize',15)
    grid on
    %     ylim([0 3])
    xlim([1 length(Lmd)])
    ylabel('Generalized Eigenvalue')
    
    Wf=W(:,id);
    for w=1:size(Wf,2)
        if abs(max(Wf(:,w)))>abs(min(Wf(:,w)))
            Wf(:,w)=-Wf(:,w);
        end
    end
    
    len=size(Wf,2);
    
    if strcmpi(csp_max_min,'max')
        NF_ind=1:NF_oneside;
    elseif strcmpi(csp_max_min,'min')
        NF_ind=len:-1:len-NF_oneside+1;
    end
    W=Wf(:,NF_ind);
    P=inv(Wf)';
    P=P(:,NF_ind);
    F=W;
    
    for p=1:size(P,2)
        P(:,p)=P(:,p)/(sum(P(:,p).^2))^0.5;
    end
    
    for f=1:size(F,2)
        F(:,f)=F(:,f)/(sum(F(:,f).^2))^0.5;
    end
    
    Lmd=Lmd(NF_ind);
    channames=cell(1,length(NF_ind));
    
    for n=1:length(NF_ind)
        channames{n}=['CSP ' num2str(NF_ind(n))];
    end
    
    data=[];
    evts={};
    rdata=[];
    for s=1:size(seg,3)
        
        evts=cat(1,evts,{size(data,1)/fs,'Rest'});
        d1=Y(:,:,s)*W;
        data=cat(1,data,d1);
        
        rdata=cat(1,rdata,Y(:,:,s));
        
        evts=cat(1,evts,{size(data,1)/fs,movements{i}});
        
        d2=X(:,:,s)*W;
        data=cat(1,data,d2);
        
        rdata=cat(1,rdata,X(:,:,s));
    end
    
%     bsp=BioSigPlot(data,'Evts',evts,'SRate',fs,'ChanNames',channames,'Title',movements{i},...
%         'WinLength',14,'Position',[0,0,600,200],'Gain',0.24);
    %     BioSigPlot(rdata,'Evts',evts,'SRate',fs,'Title',movements{i});
    
    dw=30;
    dh=30;
    
    interval=30;
    figpos=[0,0,1220,670];
    %======================================================================
    chan_order=channelindex;
    if strcmpi(csp_max_min,'min')
        axe1_pattern=zeros(1,NF_oneside);
        axe1_filter=zeros(1,NF_oneside);
        clim1_pattern=[inf,-inf];
        clim1_filter=[inf,-inf];
        
        h=figure('Name',[movements{i}, ' Decrease'],'Position',figpos);
        
        for m=1:length(NF_ind)
            count=m;
            %         subplot(2,NF_oneside,count)
            axe1_pattern(m)=axes('Units','Pixels','Position',[(m-1)*(interval+dw*12)+interval/2,dh*10+interval*1.5,12*dw,10*dh]);
            [pmax,pmin]=gauss_interpolate_120_grid(axe1_pattern(m),P(:,count)/max(abs(P(:,count))),chan_order,[],dw,dh);
            title(['CSP ' num2str(m), '  Lambda: ',num2str(Lmd(count)),' Pattern'])
            if pmax>clim1_pattern(2)
                clim1_pattern(2)=pmax;
            end
            if pmin<clim1_pattern(1)
                clim1_pattern(1)=pmin;
            end
            
            %         subplot(2,NF_oneside,count+NF_oneside)
            axe1_filter(m)=axes('Units','Pixels','Position',[(m-1)*(interval+dw*12)+interval/2,interval/2,12*dw,10*dh]);
            [fmax,fmin]=gauss_interpolate_120_grid(axe1_filter(m),F(:,count)/max(abs(F(:,count))),chan_order,[],dw,dh);
            title(['CSP' num2str(m),' Filter'])
            if fmax>clim1_filter(2)
                clim1_filter(2)=fmax;
            end
            if fmin<clim1_filter(1)
                clim1_filter(1)=fmin;
            end
            
        end
        
        for j=1:NF_oneside
            set(axe1_pattern(j),'CLim',[-1 1]);
            set(axe1_filter(j),'CLim',[-1 1]);
        end
        
        pos=get(axe1_pattern(3),'position');
        axes(axe1_pattern(3));
        cb=colorbar('Units','Pixels');
        cbpos=get(cb,'position');
        set(axe1_pattern(3),'position',pos);
        set(cb,'position',[pos(1)+pos(3)+interval/2,cbpos(2),cbpos(3),cbpos(4)]);
        
        pos=get(axe1_filter(3),'position');
        axes(axe1_filter(3));
        cb=colorbar('Units','Pixels');
        cbpos=get(cb,'position');
        set(axe1_filter(3),'position',pos);
        set(cb,'position',[pos(1)+pos(3)+interval/2,cbpos(2),cbpos(3),cbpos(4)]);
    end
    %======================================================================
    if strcmpi(csp_max_min,'max')
        
        h=figure('Name',[movements{i},' Increase'],'Position',figpos);
        
        axe2_pattern=zeros(1,NF_oneside);
        axe2_filter=zeros(1,NF_oneside);
        clim2_pattern=[inf,-inf];
        clim2_filter=[inf,-inf];
        
        for m=1:NF_oneside
            count=NF_ind(m);
            %         subplot(2,NF_oneside,m)
            
            axe2_pattern(m)=axes('Units','Pixels','Position',[(m-1)*(interval+dw*12)+interval/2,dh*10+interval*1.5,12*dw,10*dh]);
            [pmax,pmin]=gauss_interpolate_120_grid(axe2_pattern(m),P(:,count)/max(abs(P(:,count))),chan_order,[],dw,dh);
            title(['CSP ' num2str(-m),' Lambda: ',num2str(Lmd(count)),' Pattern'])
            
            if pmax>clim2_pattern(2)
                clim2_pattern(2)=pmax;
            end
            if pmin<clim2_pattern(1)
                clim2_pattern(1)=pmin;
            end
            
            %         subplot(2,NF_oneside,m+NF_oneside)
            axe2_filter(m)=axes('Units','Pixels','Position',[(m-1)*(interval+dw*12)+interval/2,interval/2,12*dw,10*dh]);
            [fmax,fmin]=gauss_interpolate_120_grid(axe2_filter(m),F(:,count)/max(abs(F(:,count))),chan_order,[],dw,dh);
            title(['CSP' num2str(-m),' Filter'])
            if fmax>clim2_filter(2)
                clim2_filter(2)=fmax;
            end
            if fmin<clim2_filter(1)
                clim2_filter(1)=fmin;
            end
        end
        
        for j=1:NF_oneside
            set(axe2_pattern(j),'CLim',[-1 1]);
            set(axe2_filter(j),'CLim',[-1 1]);
        end
        
        pos=get(axe2_pattern(3),'position');
        axes(axe2_pattern(3));
        cb=colorbar('Units','Pixels');
        cbpos=get(cb,'position');
        set(axe2_pattern(3),'position',pos);
        set(cb,'position',[pos(1)+pos(3)+interval/2,cbpos(2),cbpos(3),cbpos(4)]);
        
        pos=get(axe2_filter(3),'position');
        axes(axe2_filter(3));
        cb=colorbar('Units','Pixels');
        cbpos=get(cb,'position');
        set(axe2_filter(3),'position',pos);
        set(cb,'position',[pos(1)+pos(3)+interval/2,cbpos(2),cbpos(3),cbpos(4)]);
    end
    %======================================================================
end


