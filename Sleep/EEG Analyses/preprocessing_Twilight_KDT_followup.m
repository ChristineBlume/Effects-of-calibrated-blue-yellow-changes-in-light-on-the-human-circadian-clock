function [data_reref] = preprocessing_Twilight_KDT_followup (path_data, computer)

% Function written by Christine Blume for preprocessing of the
% Twilight (WAKE) part

% What it does: 
% load data, reject components from ICA, artefact inspection of
% KDT segments, segmentation, linked mastoids reference
% corrects trial info to reflect the correct KDT number

%% Load the necessary stuff
clearvars -except path_data computer file_no;
if computer == 1
    p = 'R:\Chronobiologie_Forschung\STUDIEN\Twilight\'; % chronovideo
    load(strcat(p, 'Github-copy\Twilight\Sleep\EEG Analyses\layouts\EEG_CB_noREF.mat'));
    load(strcat(p, 'Github-copy\Twilight\Sleep\EEG Analyses\layouts\electrodes_foranalysis.mat'));
    load(strcat(p, 'Github-copy\Twilight\Sleep\EEG Analyses\layouts\electrodes_foranalysis_old.mat'), 'eeg_chans');
    elec = ft_read_sens(strcat(p,'toolboxes_CB\obob_ownft\external\fieldtrip\template\electrode\easycap-M1_CB_FCz.txt'));
elseif computer == 2
    p = 'C:\Users\chris\'; % Basel
    load(strcat(p, 'Documents\GitHub\Twilight\Sleep\EEG Analyses\layouts\EEG_CB_noREF.mat'));
    load(strcat(p, 'Documents\GitHub\Twilight\Sleep\EEG Analyses\layouts\electrodes_foranalysis.mat'));
end

%% Preprocessing
    cd(path_data);
    filenames   = dir(strcat(path_data, '\**\*KDT*.eeg'));
%     filenames2   = dir('*V2R*_mel*.eeg'); 
%     filenames = [filenames;filenames2];
%     clear filenames2
for k = 1:length(filenames)
    tmpfile     = filenames(k,1);
    tmpfile_name     = tmpfile.name;
    tmpfile_path = tmpfile.folder;
    tmpfilename = strcat(tmpfile_path, '\', tmpfile_name);

    % Prepare VP-Name for saving
    VPname = strsplit(tmpfile_name, '.');
    VPname = VPname{1};

    k
    VPname
    %     
%         if isfile(strcat(VPname, '_reref.mat'))  
%             continue
%         end

        % ---------------------
        % Load EEG File
        % ---------------------
        cfg             = [];
        cfg.dataset     = tmpfilename;
        cfg.channel     = eeg_chans;
        cfg.continuous  = 'yes';
        cfg.hpfilter    = 'yes';
        cfg.hpfilttype  = 'but';
        cfg.hpfreq      = 0.5; % Hz
        data_cont       = ft_preprocessing(cfg);  
        
        % ---------------------------------------
        % segmentation within start/stop markers
        % ---------------------------------------  
        cfg = [];
        cfg.dataset = tmpfilename; % datafile to read events from
        cfg.trialdef.eventtype  = 'Comment';
        
        % trial definition
        cfg.trialdef.eventvalue  = {'KDT1_start', 'KDT1_stop', 'KDT2_start', 'KDT2_stop', 'KDT3_start', 'KDT3_stop'};  
        cfg_trl = ft_definetrial(cfg);
        events = cfg_trl.event;
        
        % account for different trial numbers across files
        if size(cfg_trl.trl, 1) == 2
            cfg_trl.trl(1,2) = cfg_trl.trl(2,1); % move KDT_stop to end of trial marker
            cfg_trl.trl(1,3) = cfg_trl.trl(1,2)-cfg_trl.trl(1,1); % calculate length of trial
            
            cfg_trl.trl(2,:) = [];

            KDT_segments = cfg_trl.trl; % save for later
        elseif size(cfg_trl.trl, 1) == 4
            cfg_trl.trl(1,2) = cfg_trl.trl(2,1); % move KDT_stop to end of trial marker
            cfg_trl.trl(1,3) = cfg_trl.trl(1,2)-cfg_trl.trl(1,1); % calculate length of trial
            
            cfg_trl.trl(3,2) = cfg_trl.trl(4,1); % move KDT_stop to end of trial marker
            cfg_trl.trl(3,3) = cfg_trl.trl(3,2)-cfg_trl.trl(3,1); % calculate length of trial
            
            cfg_trl.trl([2 4],:) = [];

            KDT_segments = cfg_trl.trl;
        elseif size(cfg_trl.trl, 1) == 6
            cfg_trl.trl(1,2) = cfg_trl.trl(2,1); % move KDT_stop to end of trial marker
            cfg_trl.trl(1,3) = cfg_trl.trl(1,2)-cfg_trl.trl(1,1); % calculate length of trial
            
            cfg_trl.trl(3,2) = cfg_trl.trl(4,1); % move KDT_stop to end of trial marker
            cfg_trl.trl(3,3) = cfg_trl.trl(3,2)-cfg_trl.trl(3,1); % calculate length of trial
            
            cfg_trl.trl(5,2) = cfg_trl.trl(6,1); % move KDT_stop to end of trial marker
            cfg_trl.trl(5,3) = cfg_trl.trl(5,2)-cfg_trl.trl(5,1); % calculate length of trial
            
            cfg_trl.trl([2 4 6],:) = [];

            KDT_segments = cfg_trl.trl;
        end
        
        % ----------------------------------------------
        % Segmentation 1
        %------------------------------------------------
        data_cont_segm1   = ft_redefinetrial(cfg_trl, data_cont); %Segmentation
        data_cont         = data_cont_segm1;
        clear data_cont_segm1
        
        % ---------------------
        % run ICA
        % ---------------------   
%         cfg = [];
%         cfg.method      = 'runica';
%         cfg.channel     = {'all', '-ECG', '-EMG'};
%         cfg.runica.pca	= length(data_cont.label)-3; %was -1, but 2 more chans excluded in cfg.channel
%         comp            = ft_componentanalysis(cfg,data_cont);
%         save(strcat(VPname, '_ICAcomponents'), 'comp');  %% save components of ICA

        load (strcat(VPname, '_ICAcomponents'), 'comp');  %% save components of ICA

%         % ---------------------
%         % plot components
%         % ---------------------
%         cfg                     = [];
% %         cfg.blocksize           = 8;
%         cfg.fontsize            = 10;
%         cfg.layout              = layout; % specify the layout file that should be used for plotting
%         cfg.preproc.lpfilter	= 'yes';
%         cfg.preproc.lpfreq      = 40;
%         cfg.viewmode            = 'component';
%         cfg.comment             = 'no';
%         ft_databrowser(cfg, comp); % timecourse & topography
%         comprej = input('Which component (in [])?'); % manually type in components which should be rejected for this subject

%         % ---------------------------------------------------
%         % remove bad components and backproject the data
%         % --------------------------------------------------- 
%         data_cont_for_parteogrej = data_cont;
%         eogchan = {'VEOG','E1_2','EOG_riglow','EOG_lefup', 'ECG', 'EMG'}; %and ecg/emg channel
%         iseogchan = ismember(data_cont_for_parteogrej.label, eogchan);
%        
%         % EOG channels
%         cfg = [];
%         cfg.channel = data_cont_for_parteogrej.label(iseogchan==1);
%         data_cont_parteogrej_eog = ft_selectdata(cfg, data_cont_for_parteogrej); % EOG/ECG/EMG chans w/o components rejected
% 
%         % Reject components 
%         cfg = [];
%         cfg.component = comprej; % to be removed component(s)
%         data_cont_for_parteogrej = ft_rejectcomponent(cfg, comp, data_cont_for_parteogrej); % remove components from all channels (next: select EEG chans)
% 
%         % select EEG chans from signal where components have been rejected
%         cfg = [];
%         cfg.channel = data_cont_for_parteogrej.label(iseogchan==0); % refchans have to remain for rereferencing!
%         data_cont_parteogrej_eeg = ft_selectdata(cfg, data_cont_for_parteogrej); % select eeg channels
%         
%         % Rereference EEG chans only for visualisation purposes
%         cfg = [];
%         cfg.reref = 'yes';
%         cfg.implicitref = 'FCz';
%         cfg.refchannel = {'A1', 'A2'}; 
%         data_cont_parteogrej_eeg = ft_preprocessing(cfg, data_cont_parteogrej_eeg);
%         
%         % exclude REF chans
%         refchan = {'A1', 'A2'}; % ref chans
%         isrefchan = ismember(data_cont_parteogrej_eeg.label, refchan);
%         cfg = [];
%         cfg.channel = data_cont_parteogrej_eeg.label(isrefchan == 0); % now also remove ref chans
%         data_cont_parteogrej_eeg2 = ft_selectdata(cfg, data_cont_parteogrej_eeg); 
%         
%         % select REF chans from signal where components have been rejected
%         cfg = [];
%         cfg.channel = data_cont_for_parteogrej.label(isrefchan==1);
%         data_cont_parteogrej_ref = ft_selectdata(cfg, data_cont_for_parteogrej); % select ref channel
% 
%         clear data_cont_for_parteogrej
%         clear data_cont_for_parteogrej_eeg
%         clear data_cont_parteogrej_eeg
% 
%         data_cont_parteogrej_forinspect = ft_appenddata([],data_cont_parteogrej_eeg2, data_cont_parteogrej_ref, data_cont_parteogrej_eog);    % add back EOG, EMG; ECG, and REF elecs

%         % ---------------------------------------------------
%         % VISUAL ARTEFACT DETECTION CONTINUOUS DATA
%         % ---------------------------------------------------
% 
%         % ----------------------------
%         % FT_DATABROWSER
%         % ----------------------------
%         emgchan = {'EMG'};
%         isemgchan = ismember(data_cont_parteogrej_forinspect.label, emgchan);
% 
%         % Data subset for inspection EMG
%         cfg = [];
%         cfg.channel = data_cont_parteogrej_forinspect.label(isemgchan==1);
%         data_cont_parteogrej_forinspect_emg = ft_selectdata(cfg, data_cont_parteogrej_forinspect);
% 
%         cfg = [];    
%         cfg.bpfilter  = 'yes';
%         cfg.bpfreq = [10 100];
%         data_cont_parteogrej_forinspect_emg_filt = ft_preprocessing(cfg, data_cont_parteogrej_forinspect_emg);
% 
%         % Data subset for inspection EEG
%         cfg = [];
%         cfg.channel = data_cont_parteogrej_forinspect.label(isemgchan==0);
%         data_cont_parteogrej_forinspect_eeg = ft_selectdata(cfg, data_cont_parteogrej_forinspect);
% 
%         cfg = [];    
%         cfg.lpfilter  = 'yes';
%         cfg.lpfreq = 40;
%         data_cont_parteogrej_forinspect_eeg_filt = ft_preprocessing(cfg, data_cont_parteogrej_forinspect_eeg);
% 
%         % recombine subsets of data for inspection
%         data_cont_parteogrej_forinspect = ft_appenddata([],data_cont_parteogrej_forinspect_eeg_filt, data_cont_parteogrej_forinspect_emg_filt);
% 
%         % prepare inspection settings
%         chancolors_CB = ones(length(data_cont_parteogrej_forinspect.label),1);
%         chancolors_CB(:) = 2;
% 
%         eogchan = {'VEOG','E1_2','EOG_riglow','EOG_lefup'}; 
%         eogchan2 = ismember(data_cont_parteogrej_forinspect.label, eogchan);
%         chancolors_CB(eogchan2==1) = 3; % eog channels
% 
%         emgchan2 = ismember(data_cont_parteogrej_forinspect.label, emgchan);
%         chancolors_CB(emgchan2==1) = 1; % emg channels
% 
%         refchan = {'A1', 'A2'};
%         refchan2 = ismember(data_cont_parteogrej_forinspect.label, refchan);
%         chancolors_CB(refchan2 == 1) = 4; %A1/A2
% 
%         ecgchan = {'ECG'};
%         ecgchan2 = ismember(data_cont_parteogrej_forinspect.label, ecgchan);
%         chancolors_CB(ecgchan2 == 1) = 6; 
% 
%         cfg = [];
%         cfg.ecgscale = 0.1;
%         cfg.layout = layout;
%         cfg.showlabel = 'yes';
%         cfg.gradscale = 0.04;
%         cfg.continuous = 'no';
% %         cfg.blocksize = 60;
%         cfg.viewmode = 'vertical';
%         cfg.fontsize = 10;
%         cfg.colorgroups = chancolors_CB;
%         cfg.plotlabels = 'yes';
%         % rereferencing now only for artifact rejection
%         cfg.preproc.reref = 'yes';
%         cfg.preproc.implicitref = 'FCz';
%         cfg.preproc.refchannel = {'A1', 'A2'}; %applied to all chans incl. bipolar ones
% 
%         % all segments of a trial have to be displayed in one window, then
%         % trials can be changed usign the "segments" button in data browser
%         cfg_artrej_contdata = ft_databrowser(cfg, data_cont_parteogrej_forinspect); %% view data, do not yet reject artifacts
%         cfg_artrej_contdata.artfctdef.reject = 'complete';
%         save(strcat(VPname, '_cfg_artrej'), 'cfg_artrej_contdata', 'comprej');  %% save cfg output from ft_databrowser
% 
%         chan_to_rej3 = input('Which electrodes (in {})?'); % manually type in segments which should be rejected for this subject
% %         chan_to_rej3 = {};

        load(strcat(VPname, '_cfg_artrej'));  %% save cfg output from ft_databrowser

        % -------------------------------------------------------------------------
        % NOW remove bad components from all electrodes and backproject the data
        % -------------------------------------------------------------------------
        cfg = [];
        cfg.component = comprej; % to be removed component(s)
        data_cont_eogrej = ft_rejectcomponent(cfg, comp, data_cont);

        % -----------------------------------------
        % define trials - 2s segments for FFT
        %-----------------------------------------
        cfg = [];
        cfg.dataset = tmpfilename; % datafile to read events from
        cfg.trialdef.triallength  = 2;
        cfg_trl = ft_definetrial(cfg);

        % -----------------------------------------
        % Prepare Event Codes
        %-----------------------------------------
        events2 = events(all(~cellfun(@isempty,struct2cell(events))));
        events = {events2.value};
        
        if strcmp(events{1}, 'KDT1_start')
            id_kdt1 = 1;
        end
        if strcmp(events{1}, 'KDT2_start')
            id_kdt1 = 2;
        end
        if strcmp(events{1}, 'KDT3_start')
            id_kdt1 = 3;
        end
        if length(events) > 2
            if strcmp(events{3}, 'KDT1_start')
                id_kdt2 = 1;
            end
            if strcmp(events{3}, 'KDT2_start')
                id_kdt2 = 2;
            end
            if strcmp(events{3}, 'KDT3_start')
                id_kdt2 = 3;
            end
        end
        if length(events) > 4
            if strcmp(events{5}, 'KDT1_start')
                id_kdt3 = 1;
            end
            if strcmp(events{5}, 'KDT2_start')
                id_kdt3 = 2;
            end
            if strcmp(events{5}, 'KDT3_start')
                id_kdt3 = 3;
            end
        end

        % ----------------------------------------------
        % New trial definition based on segmented data (3 KDT segments)
        %-----------------------------------------------
        segm_length = 1000; %segment length in sampling points (i.e., 2 seconds)
        trl_new1 = [KDT_segments(1,1):segm_length:KDT_segments(1,2)]; % sequence starting with beginning of 
        trl_new1 = trl_new1';
        trl_new2 = trl_new1+(segm_length-1); 
        trl_new = [trl_new1 trl_new2 trl_new2-trl_new1 repmat(id_kdt1,length(trl_new1),1)]; % beginning of segment/ end of segment/ duration/ KDT1 = 1
        trl_new(end,:) = []; % remove last row, exceeds trial length
        cfg_trl.trl = trl_new;
        clear trl_new1 trl_new2 trl_new

        if size(KDT_segments, 1) == 2
            trl_new1 = [KDT_segments(2,1):segm_length:KDT_segments(2,2)];
            trl_new1 = trl_new1';
            trl_new2 = trl_new1+(segm_length-1); 
            trl_new = [trl_new1 trl_new2 trl_new2-trl_new1 repmat(id_kdt2,length(trl_new1),1)];
            trl_new(end,:) = [];
            cfg_trl.trl = [cfg_trl.trl; trl_new]; % add to KDT1 trials
            clear trl_new*
        elseif size(KDT_segments, 1) == 3
            trl_new1 = [KDT_segments(2,1):segm_length:KDT_segments(2,2)];
            trl_new1 = trl_new1';
            trl_new2 = trl_new1+(segm_length-1); 
            trl_new = [trl_new1 trl_new2 trl_new2-trl_new1 repmat(id_kdt2,length(trl_new1),1)];
            trl_new(end,:) = [];
            cfg_trl.trl = [cfg_trl.trl; trl_new]; % add to KDT1 trials
            clear trl_new*

            trl_new1 = [KDT_segments(3,1):segm_length:KDT_segments(3,2)];
            trl_new1 = trl_new1';
            trl_new2 = trl_new1+(segm_length-1); 
            trl_new = [trl_new1 trl_new2 trl_new2-trl_new1 repmat(id_kdt3,length(trl_new1),1)];
            trl_new(end,:) = [];
            cfg_trl.trl = [cfg_trl.trl; trl_new];
            clear trl_new*
        end

        % ----------------------------------------------
        % Segmentation - redefine trials based on cfg_trl
        %------------------------------------------------

        tmp_data_segm = ft_redefinetrial(cfg_trl, data_cont_eogrej); %Segmentation
        data_segm_clean = ft_rejectartifact(cfg_artrej_contdata, tmp_data_segm); 

        % ----------------------------
        % FINAL CLEANING
        % ----------------------------
%         chan_to_rej = {'VEOG', 'E1_2', 'EMG', 'ECG', 'EOG_riglow', 'EOG_lefup'};  % not needed for further analysis
% 
%         chan_to_rej1 = horzcat(chan_to_rej, chan_to_rej3); % merges
%         manually excluded electrodes and chan-to-rej3
%         chan_to_rej1 = unique(chan_to_rej1);

        % final cleaning of data
        chan_to_rej2 = ismember(data_segm_clean.label, chan_to_rej1);
        cfg = [];
        cfg.channel = data_segm_clean.label(chan_to_rej2 == 0);
        data_segm_finalclean = ft_selectdata(cfg, data_segm_clean); % only remove channels

        clear data_cont*
        clear tmp_data*

        % ----------------------------------
        % Rereference to A1/A2 (digitally linked mastoids)
        % ----------------------------------
        cfg = [];
        cfg.reref = 'yes';
        cfg.implicitref = 'FCz';
        cfg.refchannel = {'A1', 'A2'};
        data_reref = ft_preprocessing(cfg, data_segm_finalclean);
%         save(strcat(VPname, '_cfg_artrej'), 'cfg_artrej_contdata', 'comprej', 'chan_to_rej1');  %% save cfg output from ft_databrowser
        save(strcat(VPname, '_reref'), 'data_reref');  %% save rereferenced data
        clear data_segm_finalclean
        
%             if k <length(filenames) 
%                     interrupt=input('Insert y to continue. Otherwise insert n: ', 's');
%                 while ~(or(interrupt=='y', interrupt=='n'))
%                     interrupt=input('Insert y to continue. Otherwise insert n: ', 's');
%                 end
%                 if interrupt == 'n'
%                     msg = 'You decided to stop here.';
%                     error(msg)
%                 end
%             end
%         if strcmp(interrupt, 'y')
%             continue
%         end
end

end