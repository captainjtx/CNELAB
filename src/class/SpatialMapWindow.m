classdef SpatialMapWindow < handle
    %TFMAPWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        valid
        SpatialMapFig
        bsp
        fig
        data_popup
        event_popup
        ms_before_edit
        ms_after_edit
        event_text
        ms_before_text
        ms_after_text
        
        
        normalization_popup
        scale_start_text
        scale_end_text
        scale_start_edit
        scale_end_edit
        scale_start_popup
        scale_end_popup
        max_freq_edit
        min_freq_edit
        max_clim_edit
        min_clim_edit
        max_freq_slider
        min_freq_slider
        max_clim_slider
        min_clim_slider
        erd_radio
        ers_radio
        erd_edit
        ers_edit
        erd_slider
        ers_slider
        threshold_edit
        threshold_slider
        compute_btn
        scale_by_max_radio
        display_mask_radio
        new_btn
        act_start_edit
        act_len_edit
        act_start_slider
        act_len_slider
        auto_refresh_radio
    end
    properties
        fs
        
        data_input_
        ms_before_
        ms_after_
        event_
        
        normalization_
        normalization_start_
        normalization_end_
        normalization_start_event_
        normalization_end_event_
        
        max_freq_
        min_freq_
        max_clim_
        min_clim_
        clim_slider_max_
        clim_slider_min_
        event_list_
        
        erd_
        ers_
        erd_t_
        ers_t_
        
        threshold_
        
        scale_by_max_
        
        display_mask_channel_
        act_start_
        act_len_
        auto_refresh_
    end
    
    properties (Dependent)
        data_input
        ms_before
        ms_after
        event
        
        normalization
        normalization_start
        normalization_start_event
        normalization_end
        normalization_end_event
        
        max_freq
        min_freq
        max_clim
        min_clim
        clim_slider_max
        clim_slider_min
        event_list
        
        erd
        ers
        erd_t
        ers_t
        
        threshold
        
        scale_by_max
        
        display_mask_channel
        act_start
        act_len
        auto_refresh
        
        tfmat
        tfmat_t
        tfmat_f
    end
    methods
        function val=get.auto_refresh(obj)
            val=obj.auto_refresh_;
        end
        function set.auto_refresh(obj,val)
            obj.auto_refresh_=val;
            if obj.valid
                set(obj.auto_refresh_radio,'value',val);
            end
        end
        function val=get.act_start(obj)
            val=obj.act_start_;
        end
        function set.act_start(obj,val)
            obj.act_start_=val;
            if obj.valid
                set(obj.act_start_edit,'string',num2str(val));
                set(obj.act_start_slider,'value',val);
            end
        end
        
        
        function val=get.act_len(obj)
            val=obj.act_len_;
        end
        function set.act_len(obj,val)
            obj.act_len_=val;
            if obj.valid
                set(obj.act_len_edit,'string',num2str(val));
                set(obj.act_len_slider,'value',val);
            end
        end
        
        function val=get.erd(obj)
            val=obj.erd_;
        end
        function set.erd(obj,val)
            obj.erd_=val;
            if obj.valid
                if ~val
                    set(obj.erd_edit,'enable','off');
                    set(obj.erd_slider,'enable','off');
                else
                    set(obj.erd_slider,'enable','on');
                    set(obj.erd_edit,'enable','on');
                end
            end
        end
        
        
        function val=get.ers(obj)
            val=obj.ers_;
        end
        function set.ers(obj,val)
            obj.ers_=val;
            if obj.valid
                if ~val
                    set(obj.ers_edit,'enable','off');
                    set(obj.ers_slider,'enable','off');
                else
                    set(obj.ers_slider,'enable','on');
                    set(obj.ers_edit,'enable','on');
                end
            end
        end
        function val=get.erd_t(obj)
            val=obj.erd_t_;
        end
        function set.erd_t(obj,val)
            old=digits(4);
            %             val=vpa(val);
            obj.erd_t_=val;
            if obj.valid
                set(obj.erd_edit,'string',num2str(val));
                set(obj.erd_slider,'value',val);
            end
            digits(old);
        end
        
        function val=get.ers_t(obj)
            val=obj.ers_t_;
        end
        function set.ers_t(obj,val)
            old=digits(4);
            %             val=vpa(val);
            obj.ers_t_=val;
            if obj.valid
                set(obj.ers_edit,'string',num2str(val));
                set(obj.ers_slider,'value',val);
            end
            digits(old);
        end
        
        function val=get.threshold(obj)
            val=obj.threshold_;
        end
        function set.threshold(obj,val)
            old=digits(4);
            %             val=vpa(val);
            obj.threshold_=val;
            if obj.valid
                set(obj.threshold_edit,'string',num2str(val));
                set(obj.threshold_slider,'value',val);
            end
            digits(old);
        end
        
        function val=get.scale_by_max(obj)
            val=obj.scale_by_max_;
        end
        function set.scale_by_max(obj,val)
            obj.scale_by_max_=val;
            if obj.valid
                set(obj.scale_by_max_radio,'value',val);
            end
        end
        function val=get.display_mask_channel(obj)
            val=obj.display_mask_channel_;
        end
        function set.display_mask_channel(obj,val)
            obj.display_mask_channel_=val;
            if obj.valid
                set(obj.display_mask_radio,'value',val);
            end
        end
        
        
        function val=get.data_input(obj)
            val=obj.data_input_;
        end
        function set.data_input(obj,val)
            obj.data_input_=val;
            if obj.valid
                set(obj.data_popup,'value',val);
            end
        end
        function val=get.ms_before(obj)
            val=obj.ms_before_;
        end
        function set.ms_before(obj,val)
            obj.ms_before_=val;
            if obj.valid
                set(obj.ms_before_edit,'string',num2str(val));
            end
        end
        function val=get.ms_after(obj)
            val=obj.ms_after_;
        end
        function set.ms_after(obj,val)
            obj.ms_after_=val;
            if obj.valid
                set(obj.ms_after_edit,'string',num2str(val));
            end
        end
        function val=get.event(obj)
            val=obj.event_;
        end
        function set.event(obj,val)
            if obj.valid
                [ia,ib]=ismember(val,obj.event_list);
                if ia
                    set(obj.event_popup,'value',ib);
                else
                    set(obj.event_popup,'value',1);
                    val=obj.event_list{1};
                end
            end
            obj.event_=val;
        end
        
        function val=get.normalization(obj)
            val=obj.normalization_;
        end
        function set.normalization(obj,val)
            if obj.valid
                set(obj.normalization_popup,'value',val);
            end
            obj.normalization_=val;
        end
        function val=get.normalization_start(obj)
            val=obj.normalization_start_;
        end
        function set.normalization_start(obj,val)
            if obj.valid
                set(obj.scale_start_edit,'string',num2str(val));
            end
            
            obj.normalization_start_=val;
        end
        
        function val=get.normalization_start_event(obj)
            val=obj.normalization_start_event_;
        end
        
        function set.normalization_start_event(obj,val)
            if obj.valid
                ind=find(ismember(val,obj.event_list));
                if isempty(ind)
                    ind=1;
                end
                set(obj.scale_start_popup,'value',ind);
            end
        end
        
        function val=get.normalization_end(obj)
            val=obj.normalization_end_;
        end
        function set.normalization_end(obj,val)
            obj.normalization_end_=val;
            if obj.valid
                if obj.normalization==2||obj.normalization==3
                    set(obj.scale_end_edit,'string',num2str(val));
                    
                elseif obj.normalization==4
                    set(obj.scale_end_edit,'string',val);
                end
            end
        end
        
        function val=get.normalization_end_event(obj)
            val=obj.normalization_end_event_;
        end
        
        function set.normalization_end_event(obj,val)
            if obj.valid
                ind=find(ismember(val,obj.event_list));
                if isempty(ind)
                    ind=1;
                end
                set(obj.scale_end_popup,'value',ind);
            end
        end
        
        function val=get.max_freq(obj)
            val=obj.max_freq_;
        end
        function set.max_freq(obj,val)
            if val>obj.fs/2
                val=obj.fs/2;
            elseif val<1
                val=1;
            end
            if obj.min_freq>=val
                obj.min_freq=val-1;
            end
            if obj.valid
                set(obj.max_freq_edit,'string',num2str(val));
                set(obj.max_freq_slider,'value',val);
            end
            obj.max_freq_=val;
        end
        
        function val=get.min_freq(obj)
            val=obj.min_freq_;
        end
        function set.min_freq(obj,val)
            if val<0
                val=0;
            elseif val>(obj.fs/2-1)
                val=obj.fs/2-1;
            end
            
            if obj.max_freq<=val
                obj.max_freq=val+1;
            end
            if obj.valid
                set(obj.min_freq_edit,'string',num2str(val));
                set(obj.min_freq_slider,'value',val);
            end
            obj.min_freq_=val;
        end
        
        function val=get.clim_slider_min(obj)
            val=obj.clim_slider_min_;
        end
        function set.clim_slider_min(obj,val)
            obj.clim_slider_min_=val;
            if obj.min_clim<val
                obj.min_clim=val;
            end
            if obj.valid
                set(obj.max_clim_slider,'min',val);
                set(obj.min_clim_slider,'min',val);
                set(obj.erd_slider,'min',val);
                set(obj.ers_slider,'min',val);
            end
        end
        
        function val=get.clim_slider_max(obj)
            val=obj.clim_slider_max_;
        end
        function set.clim_slider_max(obj,val)
            obj.clim_slider_max_=val;
            if obj.max_clim>val
                obj.max_clim=val;
            end
            if obj.valid
                set(obj.max_clim_slider,'max',val);
                set(obj.min_clim_slider,'max',val);
                set(obj.erd_slider,'min',val);
                set(obj.ers_slider,'max',val);
            end
        end
        function val=get.max_clim(obj)
            val=obj.max_clim_;
        end
        function set.max_clim(obj,val)
            if val>obj.clim_slider_max
                val=obj.clim_slider_max;
            elseif val<obj.clim_slider_min
                val=obj.clim_slider_min;
            end
            if obj.min_clim>=val
                obj.min_clim=val-1;
            end
            if obj.valid
                set(obj.max_clim_edit,'string',num2str(val));
                set(obj.max_clim_slider,'value',val);
            end
            obj.max_clim_=val;
        end
        
        function val=get.min_clim(obj)
            val=obj.min_clim_;
        end
        function set.min_clim(obj,val)
            if val>obj.clim_slider_max
                val=obj.clim_slider_max;
            elseif val<obj.clim_slider_min
                val=obj.clim_slider_min;
            end
            
            if obj.max_clim<=val
                obj.max_clim=val+1;
            end
            if obj.valid
                set(obj.min_clim_edit,'string',num2str(val));
                set(obj.min_clim_slider,'value',val);
            end
            obj.min_clim_=val;
        end
        
        function val=get.event_list(obj)
            val=obj.event_list_;
        end
        
        function set.event_list(obj,val)
            obj.event_list_=val;
            
            if obj.valid
                set(obj.event_popup,'value',1);
                set(obj.scale_start_popup,'value',1);
                set(obj.scale_end_popup,'value',1);
                set(obj.event_popup,'string',val);
                set(obj.scale_start_popup,'string',val);
                set(obj.scale_end_popup,'string',val);
            end
            
            [ia,ib]=ismember(obj.event,val);
            if ia
                if obj.valid
                    set(obj.event_popup,'value',ib);
                end
            else
                obj.event=val{1};
            end
            
            [ia,ib]=ismember(obj.normalization_start_event,val);
            if ia
                if obj.valid
                    set(obj.scale_start_popup,'value',ib);
                end
            else
                obj.normalization_start_event=val{1};
            end
            
            
            [ia,ib]=ismember(obj.normalization_end_event,val);
            if ia
                if obj.valid
                    set(obj.scale_end_popup,'value',ib);
                end
            else
                obj.normalization_end_event=val{1};
            end
            
            
        end
        
    end
    
    methods
        function obj=SpatialMapWindow(bsp)
            obj.bsp=bsp;
            obj.fs=bsp.SRate;
            if ~isempty(bsp.Evts)
                obj.event_list_=unique(bsp.Evts(:,2));
            end
            varinitial(obj);
            addlistener(bsp,'EventListChange',@(src,evts)UpdateEventList(obj));
            addlistener(bsp,'SelectedEventChange',@(src,evts)UpdateEventSelected(obj));
            %             buildfig(obj);
        end
        function UpdateEventList(obj)
            obj.event_list=unique(obj.bsp.Evts(:,2));
        end
        function varinitial(obj)
            obj.valid=0;
            obj.data_input_=1;%selection
            obj.ms_before_=1000;
            obj.ms_after_=1000;
            obj.event_='';
            obj.normalization_=1;%none
            obj.normalization_start_='';
            obj.normalization_end_='';
            obj.normalization_start_event_='';
            obj.normalization_end_event_='';
            obj.max_freq_=obj.fs/2;
            obj.min_freq_=0;
            obj.clim_slider_max_=15;
            obj.clim_slider_min_=-15;
            obj.max_clim_=10;
            obj.min_clim_=-10;
            obj.erd_=1;
            obj.ers_=1;
            obj.erd_t_=0;
            obj.ers_t_=0;
            obj.threshold_=1;
            obj.scale_by_max_=0;
            obj.display_mask_channel_=0;
            obj.act_start_=1000;
            obj.act_len_=1000;
            obj.auto_refresh_=0;
        end
        function buildfig(obj)
            if obj.valid
                figure(obj.fig);
                return
            end
            obj.valid=1;
            obj.fig=figure('MenuBar','none','Name','Spatial-Spectral Map','units','pixels',...
                'Position',[500 100 300 700],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','off');
            
            hp=uipanel('units','normalized','Position',[0,0,1,1]);
            
            hp_data=uipanel('Parent',hp,'Title','','Units','normalized','Position',[0,0.87,1,0.13]);
            uicontrol('Parent',hp_data,'Style','text','String','Input Data: ','units','normalized','Position',[0.01,0.6,0.4,0.35],...
                'HorizontalAlignment','left');
            obj.data_popup=uicontrol('Parent',hp_data,'Style','popup',...
                'String',{'Selection','Single Event','Average Event'},'units','normalized','position',[0.4,0.6,0.59,0.35],...
                'Callback',@(src,evts) DataPopUpCallback(obj,src),'value',obj.data_input);
            
            obj.event_text=uicontrol('Parent',hp_data,'Style','text','string','Event: ','units','normalized','position',[0.01,0.3,0.35,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.ms_before_text=uicontrol('Parent',hp_data,'Style','text','string','Before (ms): ','units','normalized','position',[0.4,0.3,0.3,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.ms_after_text=uicontrol('Parent',hp_data,'Style','text','string','After (ms): ','units','normalized','position',[0.7,0.3,0.3,0.3],...
                'HorizontalAlignment','left','visible','off');
            obj.event_popup=uicontrol('Parent',hp_data,'Style','popup','string',obj.event_list,'units','normalized','position',[0.01,0.05,0.35,0.3],...
                'visible','off','callback',@(src,evts) EventCallback(obj,src));
            obj.ms_before_edit=uicontrol('Parent',hp_data,'Style','Edit','string',num2str(obj.ms_before),'units','normalized','position',[0.4,0.05,0.29,0.3],...
                'HorizontalAlignment','left','visible','off','callback',@(src,evts) MsBeforeCallback(obj,src));
            obj.ms_after_edit=uicontrol('Parent',hp_data,'Style','Edit','string',num2str(obj.ms_after),'units','normalized','position',[0.7,0.05,0.29,0.3],...
                'HorizontalAlignment','left','visible','off','callback',@(src,evts) MsAfterCallback(obj,src));
            
            hp_scale=uipanel('Parent',hp,'Title','','units','normalized','position',[0,0.73,1,0.13]);
            uicontrol('Parent',hp_scale,'style','text','units','normalized','string','Baseline: ',...
                'position',[0.01,0.6,0.4,0.35],'HorizontalAlignment','left');
            obj.normalization_popup=uicontrol('Parent',hp_scale,'style','popup','units','normalized',...
                'string',{'None','Individual Within Segment','Average Within Sgement','External Baseline'},'callback',@(src,evts) NormalizationCallback(obj,src),...
                'position',[0.4,0.6,0.59,0.35],'value',obj.normalization);
            
            obj.scale_start_text=uicontrol('Parent',hp_scale,'style','text','units','normalized',...
                'string','Start (ms): ','position',[0.05,0.3,0.4,0.3],'HorizontalAlignment','center',...
                'visible','off');
            obj.scale_end_text=uicontrol('Parent',hp_scale,'style','text','units','normalized',...
                'string','End (ms): ','position',[0.55,0.3,0.4,0.3],'HorizontalAlignment','center',...
                'visible','off');
            obj.scale_start_edit=uicontrol('parent',hp_scale,'style','edit','units','normalized',...
                'string',obj.normalization_start,'position',[0.05,0.05,0.4,0.3],'HorizontalAlignment','center','visible','off',...
                'callback',@(src,evt)NormalizationStartEndCallback(obj,src));
            obj.scale_start_popup=uicontrol('parent',hp_scale,'style','popup','units','normalized',...
                'string',obj.event_list,'position',[0.05,0.05,0.4,0.3],'visible','off',...
                'callback',@(src,evt)NormalizationStartEndCallback(obj,src));
            
            obj.scale_end_edit=uicontrol('parent',hp_scale,'style','edit','units','normalized',...
                'string',obj.normalization_end,'position',[0.55,0.05,0.4,0.3],'HorizontalAlignment','center','visible','off',...
                'callback',@(src,evt)NormalizationStartEndCallback(obj,src));
            obj.scale_end_popup=uicontrol('parent',hp_scale,'style','popup','units','normalized',...
                'string',obj.event_list,'position',[0.55,0.05,0.4,0.3],'visible','off',...
                'callback',@(src,evt)NormalizationStartEndCallback(obj,src));
            
            hp_act=uipanel('parent',hp,'title','Activation','units','normalized','position',[0,0.62,1,0.1]);
            
            uicontrol('parent',hp_act,'style','text','string','Start (ms)','units','normalized',...
                'position',[0,0.6,0.18,0.3]);
            uicontrol('parent',hp_act,'style','text','string','Len (ms)','units','normalized',...
                'position',[0,0.1,0.18,0.3]);
            
            obj.act_start_edit=uicontrol('parent',hp_act,'style','edit','string',num2str(obj.min_freq),'units','normalized',...
                'position',[0.2,0.55,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) ActCallback(obj,src));
            obj.act_start_slider=uicontrol('parent',hp_act,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) ActCallback(obj,src),...
                'min',0,'max',obj.ms_before+obj.ms_after,'sliderstep',[0.005,0.02],'value',obj.act_start);
            obj.act_len_edit=uicontrol('parent',hp_act,'style','edit','string',num2str(obj.max_freq),'units','normalized',...
                'position',[0.2,0.05,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) ActCallback(obj,src));
            obj.act_len_slider=uicontrol('parent',hp_act,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) ActCallback(obj,src),...
                'min',1,'max',obj.ms_before+obj.ms_after,'sliderstep',[0.005,0.02],'value',obj.act_len);
            
            hp_freq=uipanel('parent',hp,'title','Frequency','units','normalized','position',[0,0.51,1,0.1]);
            
            uicontrol('parent',hp_freq,'style','text','string','Min','units','normalized',...
                'position',[0,0.6,0.1,0.3]);
            uicontrol('parent',hp_freq,'style','text','string','Max','units','normalized',...
                'position',[0,0.1,0.1,0.3]);
            
            obj.min_freq_edit=uicontrol('parent',hp_freq,'style','edit','string',num2str(obj.min_freq),'units','normalized',...
                'position',[0.15,0.55,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) FreqCallback(obj,src));
            obj.min_freq_slider=uicontrol('parent',hp_freq,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) FreqCallback(obj,src),...
                'min',0,'max',obj.fs/2,'sliderstep',[0.005,0.02],'value',obj.min_freq);
            obj.max_freq_edit=uicontrol('parent',hp_freq,'style','edit','string',num2str(obj.max_freq),'units','normalized',...
                'position',[0.15,0.05,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) FreqCallback(obj,src));
            obj.max_freq_slider=uicontrol('parent',hp_freq,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) FreqCallback(obj,src),...
                'min',0,'max',obj.fs/2,'sliderstep',[0.005,0.02],'value',obj.max_freq);
            
            hp_erds=uipanel('parent',hp,'title','ERD/ERS(dB) T-Test','units','normalized','position',[0,0.4,1,0.1]);
            
            obj.erd_radio=uicontrol('parent',hp_erds,'style','radiobutton','string','ERD','units','normalized',...
                'position',[0,0.6,0.18,0.3],'value',obj.erd,'callback',@(src,evts) ERDSCallback(obj,src));
            obj.ers_radio=uicontrol('parent',hp_erds,'style','radiobutton','string','ERS','units','normalized',...
                'position',[0,0.1,0.18,0.3],'value',obj.ers,'callback',@(src,evts) ERDSCallback(obj,src));
            obj.erd_edit=uicontrol('parent',hp_erds,'style','edit','string',num2str(obj.erd_t),'units','normalized',...
                'position',[0.2,0.55,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) ERDSCallback(obj,src));
            obj.erd_slider=uicontrol('parent',hp_erds,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) ERDSCallback(obj,src),...
                'min',obj.clim_slider_min,'max',obj.clim_slider_max,'value',obj.erd_t,'sliderstep',[0.01,0.05]);
            obj.ers_edit=uicontrol('parent',hp_erds,'style','edit','string',num2str(obj.ers_t),'units','normalized',...
                'position',[0.2,0.05,0.15,0.4],'horizontalalignment','center','callback',@(src,evts) ERDSCallback(obj,src));
            obj.ers_slider=uicontrol('parent',hp_erds,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) ERDSCallback(obj,src),...
                'min',obj.clim_slider_min,'max',obj.clim_slider_max,'value',obj.ers_t,'sliderstep',[0.01,0.05]);
            
            hp_clim=uipanel('parent',hp,'title','Scale','units','normalized','position',[0,0.29,1,0.1]);
            
            uicontrol('parent',hp_clim,'style','text','string','Min','units','normalized',...
                'position',[0,0.6,0.1,0.3]);
            uicontrol('parent',hp_clim,'style','text','string','Max','units','normalized',...
                'position',[0,0.1,0.1,0.3]);
            obj.min_clim_edit=uicontrol('parent',hp_clim,'style','edit','string',num2str(obj.min_clim),'units','normalized',...
                'position',[0.15,0.55,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) ClimCallback(obj,src));
            obj.min_clim_slider=uicontrol('parent',hp_clim,'style','slider','units','normalized',...
                'position',[0.4,0.6,0.55,0.3],'callback',@(src,evts) ClimCallback(obj,src),...
                'min',obj.clim_slider_min,'max',obj.clim_slider_max,'value',obj.min_clim,'sliderstep',[0.01,0.05]);
            obj.max_clim_edit=uicontrol('parent',hp_clim,'style','edit','string',num2str(obj.max_clim),'units','normalized',...
                'position',[0.15,0.05,0.2,0.4],'horizontalalignment','center','callback',@(src,evts) ClimCallback(obj,src));
            obj.max_clim_slider=uicontrol('parent',hp_clim,'style','slider','units','normalized',...
                'position',[0.4,0.1,0.55,0.3],'callback',@(src,evts) ClimCallback(obj,src),...
                'min',obj.clim_slider_min,'max',obj.clim_slider_max,'value',obj.max_clim,'sliderstep',[0.01,0.05]);
            
            
            hp_threshold=uipanel('parent',hp,'title','Threshold','units','normalized','position',[0,0.23,1,0.05]);
            
            uicontrol('parent',hp_threshold,'style','text','string','Ratio','units','normalized',...
                'position',[0,0.2,0.1,0.6]);
            obj.threshold_edit=uicontrol('parent',hp_threshold,'style','edit','string',num2str(obj.threshold),'units','normalized',...
                'position',[0.15,0.1,0.2,0.8],'horizontalalignment','center','callback',@(src,evts) ThresholdCallback(obj,src));
            obj.threshold_slider=uicontrol('parent',hp_threshold,'style','slider','units','normalized',...
                'position',[0.4,0.2,0.55,0.6],'callback',@(src,evts) ThresholdCallback(obj,src),...
                'min',0,'max',1,'value',obj.threshold,'sliderstep',[0.01,0.05]);
            
            hp_display=uipanel('parent',hp,'title','Display','units','normalized','position',[0,0.05,1,0.17]);
            
            obj.scale_by_max_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Scale By Maximum',...
                'units','normalized','position',[0,0.75,0.45,0.25],'value',obj.scale_by_max,...
                'callback',@(src,evts) ScaleByMaxCallback(obj,src));
            obj.display_mask_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Dispaly Mask Channels',...
                'units','normalized','position',[0,0.5,0.45,0.25],'value',obj.display_mask_channel,...
                'callback',@(src,evts) DisplayMaskCallback(obj,src));
            obj.auto_refresh_radio=uicontrol('parent',hp_display,'style','radiobutton','string','Auto Refresh',...
                'units','normalized','position',[0,0.25,0.45,0.25],'value',obj.auto_refresh,...
                'callback',@(src,evts) AutoRefreshCallback(obj,src));
            
            obj.compute_btn=uicontrol('parent',hp,'style','pushbutton','string','Compute','units','normalized','position',[0.79,0.005,0.2,0.04],...
                'callback',@(src,evts) ComputeCallback(obj));
            
            
            obj.new_btn=uicontrol('parent',hp,'style','pushbutton','string','New','units','normalized','position',[0.01,0.005,0.2,0.04],...
                'callback',@(src,evts) NewCallback(obj));
            
            DataPopUpCallback(obj,obj.data_popup);
            NormalizationCallback(obj,obj.normalization_popup);
            
            obj.event=obj.event_;
            obj.normalization_start_event=obj.normalization_start_event_;
            obj.normalization_end_event=obj.normalization_end_event_;
        end
        function OnClose(obj)
            obj.valid=0;
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
            
            h = obj.SpatialMapFig;
            if ishandle(h)
                delete(h);
            end
        end
        
        function DataPopUpCallback(obj,src)
            obj.data_input=get(src,'value');
            switch get(src,'value')
                case 1
                    %Selection
                    set(obj.event_text,'visible','off');
                    set(obj.ms_before_text,'visible','off');
                    set(obj.ms_after_text,'visible','off');
                    set(obj.event_popup,'visible','off');
                    set(obj.ms_before_edit,'visible','off');
                    set(obj.ms_after_edit,'visible','off');
                case 2
                    %Single Event
                    set(obj.event_text,'visible','on');
                    set(obj.ms_before_text,'visible','on');
                    set(obj.ms_after_text,'visible','on');
                    set(obj.event_popup,'visible','on','enable','off');
                    set(obj.ms_before_edit,'visible','on');
                    set(obj.ms_after_edit,'visible','on');
                case 3
                    %Average Event
                    set(obj.event_text,'visible','on');
                    set(obj.ms_before_text,'visible','on');
                    set(obj.ms_after_text,'visible','on');
                    set(obj.event_popup,'visible','on','enable','on');
                    set(obj.ms_before_edit,'visible','on');
                    set(obj.ms_after_edit,'visible','on');
            end
        end
        
        function MsBeforeCallback(obj,src)
            t=str2double(get(src,'string'));
            if isnan(t)
                t=obj.ms_before;
            end
            obj.ms_before=t;
        end
        function MsAfterCallback(obj,src)
            t=str2double(get(src,'string'));
            if isnan(t)
                t=obj.ms_after;
            end
            obj.ms_after=t;
        end
        
        function NormalizationCallback(obj,src)
            obj.normalization=get(src,'value');
            switch get(src,'value')
                case 1
                    set(obj.scale_start_text,'visible','off');
                    set(obj.scale_end_text,'visible','off');
                    set(obj.scale_start_edit,'visible','off');
                    set(obj.scale_end_edit,'visible','off');
                    set(obj.scale_start_popup,'visible','off');
                    set(obj.scale_end_popup,'visible','off');
                case 2
                    set(obj.scale_start_text,'visible','on');
                    set(obj.scale_start_text,'string','Start (ms): ')
                    set(obj.scale_end_text,'visible','on');
                    set(obj.scale_end_text,'string','End (ms): ')
                    set(obj.scale_start_edit,'visible','on');
                    set(obj.scale_end_edit,'visible','on');
                    set(obj.scale_start_popup,'visible','off');
                    set(obj.scale_end_popup,'visible','off');
                case 3
                    set(obj.scale_start_text,'visible','on');
                    set(obj.scale_start_text,'string','Start (ms): ')
                    set(obj.scale_end_text,'visible','on');
                    set(obj.scale_end_text,'string','End (ms): ')
                    set(obj.scale_start_edit,'visible','on');
                    set(obj.scale_end_edit,'visible','on');
                    set(obj.scale_start_popup,'visible','off');
                    set(obj.scale_end_popup,'visible','off');
                case 4
                    set(obj.scale_start_text,'visible','on');
                    set(obj.scale_start_text,'string','Start (event): ')
                    set(obj.scale_end_text,'visible','on');
                    set(obj.scale_end_text,'string','End (event): ')
                    set(obj.scale_start_edit,'visible','off');
                    set(obj.scale_end_edit,'visible','off');
                    set(obj.scale_start_popup,'visible','on');
                    set(obj.scale_end_popup,'visible','on');
            end
        end
        
        
        
        function FreqCallback(obj,src)
            switch src
                case obj.max_freq_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.max_freq;
                    end
                    obj.max_freq=round(t*10)/10;
                case obj.min_freq_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.min_freq;
                    end
                    obj.min_freq=round(t*10)/10;
                case obj.max_freq_slider
                    obj.max_freq=round(get(src,'value')*10)/10;
                case obj.min_freq_slider
                    obj.min_freq=round(get(src,'value')*10)/10;
            end
            if ~isempty(obj.SpatialMapFig)&&ishandle(obj.SpatialMapFig)
                h=findobj(obj.SpatialMapFig,'-regexp','Tag','TFMapAxes*');
                
                set(h,'YLim',[obj.min_freq,obj.max_freq]);
                DisplayOnsetCallback(obj,obj.onset_radio);
                %                 figure(obj.TFMapFig);
            end
        end
        function ClimCallback(obj,src)
            switch src
                case obj.max_clim_slider
                    obj.max_clim=get(src,'value');
                case obj.min_clim_slider
                    obj.min_clim=get(src,'value');
                case obj.max_clim_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.max_clim;
                    end
                    obj.max_clim=t;
                case obj.min_clim_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.min_clim;
                    end
                    obj.min_clim=t;
            end
            
            if ~isempty(obj.TFMapFig)&&ishandle(obj.TFMapFig)
                h=findobj(obj.TFMapFig,'-regexp','Tag','TFMapAxes*');
                
                if obj.min_clim<obj.max_clim
                    set(h,'CLim',[obj.min_clim,obj.max_clim]);
                end
                %                 figure(obj.TFMapFig);
            end
        end
        
        function NormalizationStartEndCallback(obj,src)
            switch src
                case obj.scale_start_edit
                    obj.normalization_start=str2double(get(src,'string'));
                case obj.scale_end_edit
                    obj.normalization_end=str2double(get(src,'string'));
                case obj.scale_start_popup
                    obj.normalization_start_event_=obj.event_list{get(src,'value')};
                case obj.scale_end_popup
                    obj.normalization_end_event_=obj.event_list{get(src,'value')};
            end
        end
        
        function EventCallback(obj,src)
            obj.event_=obj.event_list{get(src,'value')};
        end
        
        function UpdateEventSelected(obj)
            if ~isempty(obj.bsp.SelectedEvent)
                obj.event=obj.bsp.Evts{obj.bsp.SelectedEvent(1),2};
            end
        end
        function NewCallback(obj)
            if ~isempty(obj.SpatialMapFig)&&ishandle(obj.SpatialMapFig)
                set(obj.SpatialMapFig,'Name','Obsolete SpatialMap');
            end
            obj.SpatialMapFig=figure('Name','Active SpatialMap','NumberTitle','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt));
        end
        function ComputeCallback(obj)
            %==========================================================================
            nL=round(obj.ms_before*obj.fs/1000);
            nR=round(obj.ms_after*obj.fs/1000);
            
            %Data selection************************************************************
            if obj.data_input==1
                omitMask=true;
                [data,chanNames,dataset,channel,sample,evts,groupnames,chanpos]=get_selected_data(obj,omitMask);
            elseif obj.data_input==2
                if isempty(obj.bsp.SelectedEvent)
                    errordlg('No event selection !');
                    return
                elseif length(obj.bsp.SelectedEvent)>1
                    warndlg('More than one event selected, using the first one !');
                end
                i_label=round(obj.bsp.Evts{obj.bsp.SelectedEvent(1),1}*obj.fs);
                i_label=min(max(1,i_label),size(obj.bsp.Data{1},1));
                
                i_label((i_label+nR)>size(obj.bsp.Data{1},1))=[];
                i_label((i_label-nL)<1)=[];
                if isempty(i_label)
                    errordlg('Illegal selection!');
                    return
                end
                tmp_sel=[reshape(i_label-nL,1,length(i_label));reshape(i_label+nR,1,length(i_label))];
                omitMask=true;
                [data,chanNames,dataset,channel,sample,evts,groupnames,chanpos]=get_selected_data(obj.bsp,omitMask,tmp_sel);
            elseif obj.data_input==3
                t_evt=[obj.bsp.Evts{:,1}];
                t_label=t_evt(strcmpi(obj.bsp.Evts(:,2),obj.event));
                if isempty(t_label)
                    errordlg(['Event: ',obj.event,' not found !']);
                    return
                end
                i_event=round(t_label*obj.fs);
                i_event=min(max(1,i_event),size(obj.bsp.Data{1},1));
                
                i_event((i_event+nR)>size(obj.bsp.Data{1},1))=[];
                i_event((i_event-nL)<1)=[];
                
                omitMask=true;
                [data,chanNames,dataset,channel,sample,evts,groupnames,chanpos]=get_selected_data(obj.bsp,omitMask);
                %need to change the data
            end
            %**************************************************************************
            
            %set default parameter*****************************************************
            
            s=[obj.min_clim obj.max_clim];
            if s(1)>=s(2)
                s(1)=s(2)-abs(s(2))*0.1;
                obj.min_clim=s(1);
            end
            sl=obj.min_clim;
            sh=obj.max_clim;
            
            freq=[obj.min_freq obj.max_freq];
            if freq(1)>=freq(2)
                freq(1)=freq(2)-1;
                obj.min_freq=freq(1);
            end
            
            if isempty(obj.SpatialMapFig)||~ishandle(obj.SpatialMapFig)||~strcmpi(get(obj.SpatialMapFig,'name'),'Active SpatialMap')
                obj.SpatialMapFig=figure('Name','Active SpatialMap','NumberTitle','off','WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt));
            end
            figure(obj.SpatialMapFig)
            
            clf
            
            %Normalizatin**************************************************************
            if obj.normalization==1||obj.normalization==2
                nref=[obj.normalization_start,obj.normalization_end];
                
                if nref(2)>=round(size(data,1)/obj.fs*1000)
                    nref(2)=round(size(data,1)/obj.fs*1000);
                end
                if nref(1)>=nref(2)
                    nref(1)=0;
                end
                if nref(1)<0;
                    nref(1)=0;
                end
                baseline=[];
                obj.normalization_start=nref(1);
                obj.normalization_end=nref(2);
            elseif obj.normalization==3
                nref=[];
                
                t_evt=[obj.bsp.Evts{:,1}];
                t_label=t_evt(strcmpi(obj.bsp.Evts(:,2),obj.normalization_start_event));
                i_label=round(t_label*obj.fs);
                i_label=min(max(1,i_label),size(obj.bsp.Data{1},1));
                
                baseline_start=i_label;
                
                t_label=t_evt(strcmpi(obj.bsp.Evts(:,2),obj.normalization_end_event));
                i_label=round(t_label*obj.fs);
                i_label=min(max(1,i_label),size(obj.bsp.Data{1},1));
                
                baseline_end=i_label;
                
                tmp_sel=[reshape(baseline_start,1,length(i_label));reshape(baseline_end,1,length(i_label))];
                omitMask=true;
                baseline=get_selected_data(obj.bsp,omitMask,tmp_sel);
                
            end
            %**************************************************************************
            if isempty(chanpos)
                errordlg('No channel position in the data !');
                return
            end
            
            chanind=~isnan(chanpos(:,1))&~isnan(chanpos(:,2));
            data=data(:,chanind);
            channames=chanNames(chanind);
            chanpos=chanpos(chanind,:);
            
            chanpos(:,1)=chanpos(:,1)-min(chanpos(:,1));
            chanpos(:,2)=chanpos(:,2)-min(chanpos(:,2));
            
            dx=abs(pdist2(chanpos(:,1),chanpos(:,1)));
            dx=min(dx(dx~=0));
            if isempty(dx)
                dx=1;
            end
            
            dy=abs(pdist2(chanpos(:,2),chanpos(:,2)));
            dy=min(dy(dy~=0));
            if isempty(dy)
                dy=1;
            end
            chanpos(:,1)=chanpos(:,1)+dx/2;
            chanpos(:,2)=chanpos(:,2)+dy*0.6;
            
            x_len=max(chanpos(:,1))+dx/2;
            y_len=max(chanpos(:,2))+dy*0.6;
            chanpos(:,1)=chanpos(:,1)/x_len;
            chanpos(:,2)=chanpos(:,2)/y_len;
            
            dw=dx/(x_len+2*dx);
            dh=dy/(y_len+2*dy);
            axe = axes('Parent',obj.TFMapFig,'units','normalized','Position',[0 0 1 1],'XLim',[0,1],'YLim',[0,1],'visible','off');
            
            cmax=-inf;
            nref_tmp=nref;
            obj.tfmat=cell(1,length(channames));
            
            for j=1:length(channames)
                if obj.data_input==3
                    tfm=0;
                    %compute the baseline spectrum
                    if obj.normalization==2
                        rtfm=0;
                        for i=1:length(i_event)
                            tmp_sel=[i_event(i)-nL+nref(1);i_event(i)-nL+nref(2)];
                            bdata=get_selected_data(obj.bsp,omitMask,tmp_sel);
                            bdata=bdata(:,chanind);
                            bdata=bdata(:,j);
                            [rtf,f,t]=bsp_tfmap(obj.SpatialMapFig,bdata,baseline,obj.fs,wd,ov,s,[],channames,freq,unit);
                            rtfm=rtfm+abs(rtf);
                        end
                        
                        rtfm=rtfm/length(i_event);
                        nref_tmp=[];
                    end
                    %******************************************************
                    for i=1:length(i_event)
                        tmp_sel=[i_event(i)-nL;i_event(i)+nR];
                        data=get_selected_data(obj.bsp,omitMask,tmp_sel);
                        data=data(:,chanind);
                        data=data(:,j);
                        [tf,f,t]=bsp_tfmap(obj.SpatialMapFig,data,baseline,obj.fs,wd,ov,s,nref_tmp,channames,freq,unit);
                        tfm=tfm+tf;
                    end
                    tfm=tfm/length(i_event);
                    if obj.normalization==3
                        tfm=tfm./repmat(mean(rtfm,2),1,size(tfm,2));
                    end
                else
                    [tfm,f,t]=bsp_tfmap(obj.SpatialMapFig,data(:,j),baseline,obj.fs,wd,ov,s,nref,channames,freq,unit);
                end

                if ~isempty(tfm)
                    cmax=max(max(max(abs(10*log10(tfm)))),cmax);
                end
                
                obj.tfmat{j}=tfm;
            end
            obj.clim_slider_max=cmax*1.5;
            obj.clim_slider_min=-cmax*1.5;
            
            obj.tfmat_t=t;
            obj.tfmat_f=f;
            
            spatialmap_grid()
        end
        
        function ERDSCallback(obj,src)
            switch src
                case obj.erd_radio
                    obj.erd=get(src,'value');
                case obj.ers_radio
                    obj.ers=get(src,'value');
                case obj.erd_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.erd_t;
                    end
                    t=max(obj.clim_slider_min,min(obj.clim_slider_max,t));
                    obj.erd_t=t;
                case obj.ers_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.ers_t;
                    end
                    t=max(obj.clim_slider_min,min(obj.clim_slider_max,t));
                    obj.ers_t=t;
                case obj.erd_slider
                    obj.erd_t=get(src,'value');
                case obj.ers_slider
                    obj.ers_t=get(src,'value');
            end
        end
        function ThresholdCallback(obj,src)
            switch src
                case obj.threshold_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.threshold;
                    end
                    t=max(0,min(t,1));
                    
                    obj.threshold=t;
                case obj.threshold_slider
                    obj.threshold=get(src,'value');
            end
        end
        
        function DisplayMaskCallback(obj,src)
            obj.display_mask_channel_=get(src,'value');
        end
        function ScaleByMaxCallback(obj,src)
            obj.scale_by_max_=get(src,'value');
        end
        
        function ActCallback(obj,src)
            switch src
                case obj.act_start_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.act_start;
                    end
                    obj.act_start=t;
                case obj.act_len_edit
                    t=str2double(get(src,'string'));
                    if isnan(t)
                        t=obj.act_len;
                    end
                    obj.act_len=t;
                case obj.act_start_slider
                    obj.act_start=get(src,'value');
                case obj.act_len_slider
                    obj.act_len=get(src,'value');
            end
        end
        function AutoRefreshCallback(obj,src)
            obj.auto_refresh_=get(src,'value');
        end
        
        
        function KeyPress(obj,src,evt)
            if strcmpi(get(src,'Name'),'Obsolete SpatialMap')
                return
            end
            if ~isempty(evt.Modifier)
                if length(evt.Modifier)==1
                    if ismember('command',evt.Modifier)||ismember('control',evt.Modifier)
                        if strcmpi(evt.Key,'t')
                            obj.NewCallback();
                        end
                        
                    end
                end
            end
        end
        
    end
    
end

