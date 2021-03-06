classdef CnelabWindow < handle
    properties
        fig
        
        open_btn
        file_listbox
        file_listbox_model
        jRenderer
        
        cfg
        
        choice
        
        selectedFiles
        
        cfg_name
        
    end
    
    properties (Dependent)
        cnelab_path
        file_type
        valid
    end
        
    methods
        function val=get.file_type(obj)
            val=ones(1,length(obj.cfg.files));
            
            for i=1:length(obj.cfg.files)
                for j=1:length(obj.cfg.files{i})
                    [~,~,ext]=fileparts(obj.cfg.files{i}{j});
                    if ~strcmp(ext,'.cds')
                        val(i)=-1;
                    end
                end
            end
        end
        function val=get.valid(obj)
            try
                val=ishandle(obj.fig)&&isgraphics(obj.fig);
            catch
                val=0;
            end
        end
        
        function val=get.cnelab_path(obj)
            [val,~,~]=fileparts(which('cnelab.m'));
        end
        
        function obj=CnelabWindow()
            obj.cfg_name=[obj.cnelab_path,'/db/cfg/user.cfg'];
            
            if exist(obj.cfg_name,'file')==2
                obj.cfg=load(obj.cfg_name,'-mat');
            else
                cfg.files={};
                cfg.skip=0;
                obj.cfg=cfg;    
            end
            %check if file still there
            file_nonexist=[];
            for i=1:length(obj.cfg.files)
                for j=1:length(obj.cfg.files{i})
                    if ~exist(obj.cfg.files{i}{j},'file')
                        file_nonexist=cat(1,file_nonexist,i);
                        break
                    end
                end
            end
            obj.cfg.files(file_nonexist)=[];
            obj.choice=-1;
        end
        
        function buildfig(obj)
            obj.choice=0;
            
            if obj.valid
                figure(obj.fig);
                return
            end

            screensize=get(0,'ScreenSize');
            obj.fig=figure('MenuBar','none','Name',['Welcome to CNELab ',char(169),'2014-2016 Tianxiao Jiang'],'units','pixels',...
                'Position',[screensize(3)/2-375 screensize(4)/2-225 750 450],'NumberTitle','off','CloseRequestFcn',@(src,evts) OnClose(obj),...
                'Resize','off','DockControls','off','Alphamap',0.5,'color','w');
            set(obj.fig,'WindowKeyPressFcn',@(h,e)key_press(obj,h,e));
            
            logo=uipanel(obj.fig,'units','normalized','position',[0,0.4,0.6,0.6],'BorderType','none','backgroundcolor','white');
            
            logo_icon=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,filesep,'db',filesep,'icon',filesep,'cnel.png']));
            logo_label=javaObjectEDT(javax.swing.JLabel());
            logo_label.setIcon(logo_icon);
            logo_label.setHorizontalAlignment(javax.swing.JLabel.CENTER);
            logo_label.setBackground(java.awt.Color(1,1,1));
            logo_label.setOpaque(true);
            [jh,gh]=javacomponent(logo_label,[0,0,1,1],logo);
            set(gh,'Units','Norm','Position',[0.33,0.4,0.34,0.43]);
            
            logo_txt_label=javaObjectEDT(javax.swing.JLabel());
            logo_txt_label.setText('Welcome to CNELab');
            logo_txt_label.setHorizontalAlignment(javax.swing.JLabel.CENTER);

            logo_txt_label.setBackground(java.awt.Color(1,1,1));
            logo_txt_label.setForeground(java.awt.Color(0.3,0.3,0.3));
            logo_txt_label.setFont(java.awt.Font('Garamond', java.awt.Font.PLAIN, 34));
            logo_txt_label.setOpaque(true);
            
            [jh,gh]=javacomponent(logo_txt_label,[0,0,1,1],logo);
            set(gh,'Units','Norm','Position',[0.1,0.25,0.8,0.12]);
            
            version_txt_label=javaObjectEDT(javax.swing.JLabel());
            version_txt_label.setText('Version 2.0');
            version_txt_label.setHorizontalAlignment(javax.swing.JLabel.CENTER);

            version_txt_label.setBackground(java.awt.Color(1,1,1));
            version_txt_label.setForeground(java.awt.Color(0.5,0.5,0.5));
            version_txt_label.setFont(java.awt.Font('Garamond', java.awt.Font.PLAIN, 20));
            version_txt_label.setOpaque(true);
            
            [jh,gh]=javacomponent(version_txt_label,[0,0,1,1],logo);
            set(gh,'Units','Norm','Position',[0.1,0.1,0.8,0.12]);
            
%             text('parent',logo_a,'position',[0.5,0.3],'string','Welcome to CNELab',...
%                 'FontSize',32,'HorizontalAlignment','center','Color',[0.3,0.3,0.3]);
%             text('parent',logo_a,'position',[0.5,0.15],'string','Version 2.0',...
%                 'Fontsize',17,'HorizontalAlignment','center','Color',[0.5,0.5,0.5]);
            
            file_p=uipanel(obj.fig,'units','normalized','position',[0.6,0,0.4,1],'BorderType','none','backgroundcolor',[0.95,0.95,0.95]);
            
            if isempty(obj.cfg.files)
                obj.file_listbox=javaObjectEDT(javax.swing.JList());
            else
                list_str=cell(1,length(obj.cfg.files));
                for i=1:length(list_str)
                    list_str{i}=obj.cfg.files{i}{1};
                    [pathstr,~,~]=fileparts(obj.cfg.files{i}{1});
                    for j=2:length(obj.cfg.files{i})
                        [path_tmp,name_tmp,ext_tmp]=fileparts(obj.cfg.files{i}{j});
                        if strcmp(path_tmp,pathstr)
                            %all cds files must in the same directory
                            list_str{i}=[list_str{i},' &#43; ',name_tmp,ext_tmp];
                        else
                            %if two files not in the same directory, delete
                            %it
                            obj.cfg.files{i}(j)=[];
                        end
                    end
                end
                obj.file_listbox_model=javaObjectEDT(javax.swing.DefaultListModel);
                for i=1:length(list_str)
                    obj.file_listbox_model.addElement(list_str{i});
                end
                obj.file_listbox=javaObjectEDT(javax.swing.JList(obj.file_listbox_model));
                obj.file_listbox.setSelectedIndex(0);
            end
            
            obj.file_listbox.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_INTERVAL_SELECTION);
            obj.file_listbox.setLayoutOrientation(javax.swing.JList.VERTICAL);
            obj.file_listbox.setVisibleRowCount(9);
            obj.file_listbox.setSelectionBackground(java.awt.Color(0.2,0.6,1));
            obj.file_listbox.setSelectionForeground(java.awt.Color(1,1,1));
            obj.file_listbox.setFixedCellHeight(45);
            obj.file_listbox.setBackground(java.awt.Color(0.95,0.95,0.95));
            obj.file_listbox.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
            obj.jRenderer = javaObjectEDT(src.java.LabelListBoxRenderer());
            obj.jRenderer.setFileType(obj.file_type);
            obj.file_listbox.setCellRenderer(obj.jRenderer);
            set(handle(obj.file_listbox,'CallbackProperties'),'MousePressedCallback',@(h,e)mouse_press_list(obj));
            
            jsp=javaObjectEDT(javax.swing.JScrollPane());
            jsp.setViewportView(obj.file_listbox);
            jsp.setVerticalScrollBarPolicy(javax.swing.JScrollPane.VERTICAL_SCROLLBAR_NEVER);
            jsp.setHorizontalScrollBarPolicy(javax.swing.JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
            jsp.setBorder(javax.swing.BorderFactory.createEmptyBorder());
            [jh,gh]=javacomponent(jsp,[0,0.08,1,0.92],file_p);
            set(gh,'Units','normalized','position',[0,0.07,1,0.93]);
            
            obj.open_btn = javaObjectEDT(com.mathworks.mwswing.MJButton('Open another data ...'));
            obj.open_btn.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
            
            obj.open_btn.setBackground(java.awt.Color(0.95, 0.95, 0.95));
            obj.open_btn.setForeground(java.awt.Color(0.2, 0.2, 0.2));
            obj.open_btn.setFlyOverAppearance(true);
            %             obj.open_btn.setCursor(java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
            set(handle(obj.open_btn,'CallbackProperties'), 'MouseEnteredCallback', @(h,e)mouse_enter(obj))
            set(handle(obj.open_btn,'CallbackProperties'), 'MouseExitedCallback',  @(h,e)mouse_exit(obj))
            set(handle(obj.open_btn,'CallbackProperties'), 'MousePressedCallback', @(h,e)mouse_press_btn(obj))
            [dummy,btContainer] = javacomponent(obj.open_btn,[0 0 1 1],file_p); %#ok
            set(btContainer, 'Units','Norm', 'Position',[0.03,0.01,0.5,0.05]);
            
            originalLnF = javax.swing.UIManager.getLookAndFeel();  %class
            try
                javaMethodEDT('setLookAndFeel',javax.swing.UIManager,javax.swing.UIManager.getCrossPlatformLookAndFeelClassName());
            catch  e
                e.printStackTrace();
            end
            opt=uipanel(obj.fig,'units','normalized','position',[0.1,0,0.5,0.4],'BorderType','none','backgroundcolor','white');
            
            demo_icon = javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/demo.png']));
            demo_label = javaObjectEDT(javax.swing.JLabel());
            demo_label.setIcon(demo_icon);
            demo_label.setText('<html><font size=4.5 color=black><b>Start from demo</b></font> <br> <font size=3.5 color=gray> Quickly learn the features</font></html>');
            demo_label.setIconTextGap(10);
            demo_label.setOpaque(false);
            
            demo=javaObjectEDT(javax.swing.JButton());
            demo.setBorder(javax.swing.BorderFactory.createMatteBorder(2,0,0,0,java.awt.Color(0.8,0.8,0.8)));
            demo.setBackground(java.awt.Color(1,1,1));
            demo.add(demo_label);
            demo.setOpaque(false);
            demo.setBorderPainted(true);
            
            set(handle(demo,'CallbackProperties'),'MousePressedCallback',@(h,e) Demo(obj));
            [jh,gh]=javacomponent(demo,[0,0.72,1,0.28],opt);
            set(gh,'Units','Norm','Position',[0,0.72,1,0.28]);
            
            new_cds_icon = javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/new_cds.png']));
            new_cds_label = javaObjectEDT(javax.swing.JLabel());
            new_cds_label.setIcon(new_cds_icon);
            new_cds_label.setText('<html><font size=4.5 color=black><b>Create new CDS files</b></font> <br> <font size=3.5 color=gray> By converting from other data formats</font></html>');
            new_cds_label.setBorder(javax.swing.border.EmptyBorder(0,3,0,0));
            new_cds_label.setIconTextGap(14);
            new_cds_label.setOpaque(false);
            
            new_cds=javaObjectEDT(javax.swing.JButton());
            new_cds.setBorder(javax.swing.BorderFactory.createMatteBorder(2,0,0,0,java.awt.Color(0.8,0.8,0.8)));
            new_cds.setBackground(java.awt.Color(1,1,1));
            new_cds.add(new_cds_label);
            new_cds.setOpaque(false);
            new_cds.setBorderPainted(true);
            
            set(handle(new_cds,'CallbackProperties'),'MousePressedCallback',@(h,e) NewCDS(obj));
            [jh,gh]=javacomponent(new_cds,[0,0.44,1,0.28],opt);
            set(gh,'Units','Norm','Position',[0,0.44,1,0.28]);
            
            tmp=javaObjectEDT(javax.swing.JButton());
            tmp.setBorder(javax.swing.BorderFactory.createMatteBorder(2,0,2,0,java.awt.Color(0.8,0.8,0.8)));
            tmp.setBackground(java.awt.Color(1,1,1));
            tmp.setOpaque(false);
            tmp.setBorderPainted(true);
            set(handle(tmp,'CallbackProperties'),'MousePressedCallback',@(h,e) Reserved(obj));
            [jh,gh]=javacomponent(tmp,[0,0.16,1,0.28],opt);
            set(gh,'Units','Norm','Position',[0,0.16,1,0.28]);
            javaMethodEDT('setLookAndFeel',javax.swing.UIManager,originalLnF);
            warning('off','MATLAB:uitabgroup:OldVersion');
        end
        
        function OnClose(obj)
            h = obj.fig;
            if ishandle(h)
                delete(h);
            end
            obj.saveConfig();
        end
        
        function mouse_enter(obj)
            obj.open_btn.setBackground(java.awt.Color(0.8,0.8,0.8));
            obj.open_btn.setForeground(java.awt.Color(1,1,1));
        end
        
        function mouse_exit(obj)
            obj.open_btn.setBackground(java.awt.Color(0.94,0.94,0.94));
            obj.open_btn.setForeground(java.awt.Color(0.2,0.2,0.2));
        end
        function mouse_press_btn(obj)
            obj.choice=1;
            
            OnClose(obj);
            notify(obj,'UserChoice')
        end
        function mouse_press_list(obj)
            ind = obj.file_listbox.getSelectedIndex();
            
            if ind==-1
                return
            else
                obj.selectedFiles=obj.cfg.files{ind+1};
            end
            obj.choice=2;
            
            for i=1:length(obj.selectedFiles)
                if ~exist(obj.selectedFiles{i},'file')
                    %file does not exist
                    %delete the file history
                    errordlg(['Can not find ',obj.selectedFiles{i}]);
                    obj.cfg.files(ind+1)=[];
                    obj.file_listbox_model.remove(ind);
                    obj.jRenderer.setFileType(obj.file_type);
                    if ~isempty(obj.cfg.files)
                        obj.file_listbox.setSelectedIndex(0);
                    end
%                     obj.file_listbox.setCellRenderer(obj.jRenderer);
                    return
                end
            end
            OnClose(obj);
            notify(obj,'UserChoice');
        end
        
        function key_press(obj,src,evt)
            ind=obj.file_listbox.getSelectedIndex();
            if ind==-1
                return
            end
            if strcmpi(evt.Key,'uparrow')
                ind=ind-1;
                obj.file_listbox.setSelectedIndex(mod(ind,length(obj.cfg.files)));
            elseif strcmpi(evt.Key,'downarrow')
                ind=ind+1;
                obj.file_listbox.setSelectedIndex(mod(ind,length(obj.cfg.files)));
            elseif strcmpi(evt.Key,'return')
                mouse_press_list(obj);
            end
        end
                
        function NewCDS(obj)
            OnClose(obj);
        end
        function Demo(obj)
            if exist([obj.cnelab_path,'/demo/demo.cds'],'file')==2
                obj.selectedFiles={[obj.cnelab_path,'/demo/demo.cds']};
                obj.choice=2;
                OnClose(obj);
                notify(obj,'UserChoice');
            else
                errordlg(['Cannot find ',obj.cnelab_path,'/demo/demo.cds !']);
                OnClose(obj);
            end
        end
        
        function Reserved(obj)
            OnClose(obj);
        end
        
        function saveConfig(obj)
            newcfg=obj.cfg;
            save(obj.cfg_name,'-struct','newcfg','-mat');
        end
    end
    
    events
        UserChoice
    end
end
