function [data_reref] = preprocessing_Twilight_SLEEP_followup (path_data, computer)

% Function written by Christine Blume for preprocessing of the
% ALocGlo(SLEEP) part 

% What it does: 
% load data, segmentation lights off/on, artefact inspection of
% continuous data, segmentation for SWA Analyses, linked mastoids reference

%% Load the necessary stuff
clearvars -except path_data computer file_no;
if computer == 1
    p = 'R:\Chronobiologie_Forschung\STUDIEN\Twilight\'; % chronovideo
    load(strcat(p, 'Github-copy\Twilight\Sleep\EEG Analyses\layouts\EEG_CB_noREF.mat'));
    load(strcat(p, 'Github-copy\Twilight\Sleep\EEG Analyses\layouts\electrodes_foranalysis.mat'));
    load(strcat(p, 'Github-copy\Twilight\Sleep\EEG Analyses\layouts\electrodes_foranalysis_old.mat'), 'eeg_chans');
    path_stagings = strcat(p, '1_RAW Data (R Drive)\Twilight_EXPERIMENTAL\SleepStaging_G3\bvaMarker_30s\');
    path_sleepcycles = strcat(p, '1_RAW Data (R Drive)\Twilight_EXPERIMENTAL\SleepStaging_G3\SleepCycles\SleepCycles_2022-12-22\');
elseif computer == 2
    p = 'C:\Users\chris\'; % Basel
    load(strcat(p, 'Documents\GitHub\Twilight\Sleep\EEG Analyses\layouts\EEG_CB_noREF.mat'));
    load(strcat(p, 'Documents\GitHub\Twilight\Sleep\EEG Analyses\layouts\electrodes_foranalysis.mat'));
    path_stagings = strcat('E:\10 Data\14-Twilight\Twilight\1_RAW Data (R Drive)\Twilight_EXPERIMENTAL\SleepStaging_G3\bvaMarker_30s\');
%     path_stagings = strcat(path_data, 'SIESTA_results\bvaMarker_30s\');
    path_data = 'E:\10 Data\14-Twilight\Twilight\1_RAW Data (R Drive)\Twilight_EXPERIMENTAL\BVA_Workspace_Experimental\Raw Files (Brainvision)\';
    path_sleepcycles = 'E:\10 Data\14-Twilight\Twilight\1_RAW Data (R Drive)\Twilight_EXPERIMENTAL\SleepStaging_G3\for_SleepCycles_2022-11-15\SleepCycles_2022-11-15\';
end

%% Preprocessing
    cd(path_data);
    filenames   = dir('*sleep*.eeg'); % only files USED are saved in the directory
    for k = 43 % only first 19 Pbn with no sleep stages/cycles
        tmpfile     = filenames(k,1);
        tmpfile     = tmpfile.name;
        tmpfilename = strcat(path_data, tmpfile);

        % Prepare VP-Name for saving
        VPname = strsplit(tmpfile, '.');
        VPname = VPname{1};
     
%         if isfile(strcat(VPname, '_reref.mat'))  
%             continue
%         end

        k
        VPname

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
        
        % -----------------------------------------
        % define trials for segmentation between LightsOff and LightsOn
        %-----------------------------------------
        cfg = [];
        cfg.dataset = tmpfilename; % datafile to read events from
        cfg.trialdef.eventtype  = 'Comment';
        
        % trial definition
        cfg.trialdef.eventvalue  = {'LightsOff', 'LightsOn'};  
        cfg_trl = ft_definetrial(cfg);
        cfg_trl.trl(1,2) = cfg_trl.trl(2,1); % move lightsOn to end of trial marker
        cfg_trl.trl(1,3) = cfg_trl.trl(1,2)-cfg_trl.trl(1,1); % calculate length of trial
        cfg_trl.trl(2,:) = [];
        
        % ----------------------------------------------
        % Segmentation 1 - select only between LightsOff and LightsOn
        %------------------------------------------------
        data_cont_segm   = ft_redefinetrial(cfg_trl, data_cont); %Segmentation
    
%         % ---------------------------------------------------
%         % prep visualisation
%         % ---------------------------------------------------
%         data_cont_forinspect = data_cont_segm;
%         eogchan = {'VEOG','E1_2','EOG_riglow','EOG_lefup', 'ECG', 'EMG'}; %and ecg/emg channel
%         iseogchan = ismember(data_cont_forinspect.label, eogchan);
%        
%         % EOG channels
%         cfg = [];
%         cfg.channel = data_cont_forinspect.label(iseogchan==1);
%         data_cont_forinspect_eog = ft_selectdata(cfg, data_cont_forinspect); % EOG/ECG/EMG chans w/o components rejected
% 
%         % select EEG chans from signal
%         cfg = [];
%         cfg.channel = data_cont_forinspect.label(iseogchan==0); % refchans have to remain for rereferencing!
%         data_cont_forinspect_eeg = ft_selectdata(cfg, data_cont_forinspect); % select eeg channels
%         
%         % Rereference EEG chans only for visualisation purposes
%         cfg = [];
%         cfg.reref = 'yes';
%         cfg.implicitref = 'FCz';
%         cfg.refchannel = {'A1', 'A2'}; 
%         data_cont_forinspect_eeg = ft_preprocessing(cfg, data_cont_forinspect_eeg);
%         
%         % exclude REF chans
%         refchan = {'A1', 'A2'}; % ref chans
%         isrefchan = ismember(data_cont_forinspect_eeg.label, refchan);
%         cfg = [];
%         cfg.channel = data_cont_forinspect_eeg.label(isrefchan == 0); % now also remove ref chans
%         data_cont_forinspect_eeg2 = ft_selectdata(cfg, data_cont_forinspect_eeg); 
%         
%         % select REF chans from signal
%         cfg = [];
%         cfg.channel = data_cont_forinspect.label(isrefchan==1);
%         data_cont_forinspect_ref = ft_selectdata(cfg, data_cont_forinspect); % select ref channel
% 
%         clear data_cont_for_parteogrej
%         clear data_cont_for_parteogrej_eeg
%         clear data_cont_parteogrej_eeg
% 
%         data_cont_forinspect2 = ft_appenddata([],data_cont_forinspect_eeg2, data_cont_forinspect_ref, data_cont_forinspect_eog);    % add back EOG, EMG; ECG, and REF elecs
%         
%         clear data_cont_forinspect
%         
%         % ---------------------------------------------------
%         % VISUAL ARTEFACT DETECTION CONTINUOUS DATA
%         % ---------------------------------------------------
% 
%         % ----------------------------
%         % FT_DATABROWSER
%         % ----------------------------
%         emgchan = {'EMG'};
%         isemgchan = ismember(data_cont_forinspect2.label, emgchan);
% 
%         % Data subset for inspection EMG
%         cfg = [];
%         cfg.channel = data_cont_forinspect2.label(isemgchan==1);
%         data_cont_forinspect_emg = ft_selectdata(cfg, data_cont_forinspect2);
% 
%         cfg = [];    
%         cfg.bpfilter  = 'yes';
%         cfg.bpfreq = [10 100];
%         data_cont_forinspect_emg_filt = ft_preprocessing(cfg, data_cont_forinspect_emg);
% 
%         % Data subset for inspection EEG
%         cfg = [];
%         cfg.channel = data_cont_forinspect2.label(isemgchan==0);
%         data_cont_forinspect_eeg = ft_selectdata(cfg, data_cont_forinspect2);
% 
%         cfg = [];    
%         cfg.lpfilter  = 'yes';
%         cfg.lpfreq = 40;
%         data_cont_forinspect_eeg_filt = ft_preprocessing(cfg, data_cont_forinspect_eeg);
% 
%         % recombine subsets of data for inspection
%         data_cont_forinspect2 = ft_appenddata([],data_cont_forinspect_eeg_filt, data_cont_forinspect_emg_filt);
% 
%         % prepare inspection settings
%         chancolors_CB = ones(length(data_cont_forinspect2.label),1);
%         chancolors_CB(:) = 2;
% 
%         eogchan = {'VEOG','E1_2','EOG_riglow','EOG_lefup'}; 
%         eogchan2 = ismember(data_cont_forinspect2.label, eogchan);
%         chancolors_CB(eogchan2==1) = 3; % eog channels
% 
%         emgchan2 = ismember(data_cont_forinspect2.label, emgchan);
%         chancolors_CB(emgchan2==1) = 1; % emg channels
% 
% %         if strcmp(VPname, '1994LUAA_V1_sleep_mel-_LiveAmp') | strcmp(VPname, '1994LUAA_V2_sleep_mel+_LiveAmp')
% %             refchan = {'A2'};  
% %         else
%             refchan = {'A1', 'A2'};
% %         end
%         refchan2 = ismember(data_cont_forinspect2.label, refchan);
%         chancolors_CB(refchan2 == 1) = 4; %A1/A2
% 
%         ecgchan = {'ECG'};
%         ecgchan2 = ismember(data_cont_forinspect2.label, ecgchan);
%         chancolors_CB(ecgchan2 == 1) = 6; 
% 
%         cfg = [];
%         cfg.ecgscale = 0.1;
%         cfg.layout = layout;
%         cfg.showlabel = 'yes';
%         cfg.gradscale = 0.04;
%         cfg.continuous = 'yes';
%         cfg.blocksize = 20;
%         cfg.viewmode = 'vertical';
%         cfg.fontsize = 10;
%         cfg.colorgroups = chancolors_CB;
%         cfg.plotlabels = 'yes';
%         cfg.ylim = [-81 81];
% 
%         cfg_artrej_contdata = ft_databrowser(cfg, data_cont_forinspect2); %% view data, do not yet reject artifacts
%         cfg_artrej_contdata.artfctdef.reject = 'complete';
%         
%         chan_to_rej3 = input('Which electrodes to exclude (in {})?'); % manually type in electrodes which should be rejected for this subject
%         save(strcat(VPname, '_cfg_artrej'), 'cfg_artrej_contdata', 'chan_to_rej3');  %% save cfg output from ft_databrowser
        load(strcat(VPname, '_cfg_artrej'));  %% load cfg output from ft_databrowser
        
        clear data_cont_for*
  
        % ----------------------------------------------
        % New Trial Def with Sleep Staging Data
        % ----------------------------------------------
        VPname2 = split(VPname, '_');
        VPname2 = strcat(VPname2{1}, '_', VPname2{3});
        
        sleepstage_file = dir(strcat(path_stagings, VPname2, '.vmrk'));
        sleepstage_file = fopen(strcat(path_stagings, sleepstage_file.name), 'r');
        SR_sleepstages = textscan(sleepstage_file, '%s%*s%*s%*s%*s%[^\n\r]', 1, 'Delimiter', ',', 'ReturnOnError', false);
        SR_sleepstages = SR_sleepstages{:, 1};
        SR_sleepstages = strsplit(SR_sleepstages{1}, ' ');
        SR_sleepstages = SR_sleepstages{3};
        [C,~] = strsplit(SR_sleepstages,{' ','H'},'CollapseDelimiters',true);
        SR = str2double(C{1});
        clear C
        clear matches
        clear SR_sleepstages
        sleepstages = textscan(sleepstage_file, '%s%f%f%f%s%[^\n\r]', 'Delimiter', ',', 'HeaderLines' , 2 ,'ReturnOnError', false);
        fclose(sleepstage_file);
        Description = sleepstages{:, 2};
        Position = sleepstages{:, 3};
        sleepstages = [Description, Position];
        clear Description
        clear Position
        clear sleepstage_file

        % Upsample Sleepstaging file as file was staged on ??Hz
        fsample = data_cont.fsample;
        SR_diff = fsample/SR;
        sleepstages(:,2) = sleepstages(:,2)*SR_diff;
        
        % add no of samples before "LightsOff" (reference point for
        % staging)
        sleepstages(:,2) = sleepstages(:,2)+cfg_trl.trl(1,1);
               
        % ----------------------------------------------
        % Add information from SleepCycle Detection
        % ----------------------------------------------
        sleepcycle_file = readtable(strcat(path_sleepcycles, VPname2, '_SCycles', '.txt'));
        
        CycleNo = (sleepcycle_file{:, 1});
        N_REM = (sleepcycle_file{:, 3});
        percentile = (sleepcycle_file{:, 4});
        sleepcycles = [CycleNo, N_REM, percentile];

        % Include Cycle Info in sleep stage info
        sleepstages(:,4) = CycleNo;
        sleepstages(:,5) = N_REM;
        sleepstages(:,6) = percentile;
        sleepstages(:,7) = sleepstages(:,1); % move column with stages to the end
        sleepstages(:,3) = 30*fsample-1; % set 30s to indicate trial duration
        sleepstages(:,1) = sleepstages(:,2); % copy to match cfg_trl
        
        % add duration of trl to first column (note that the sleep stage
        % G3 Marker does NOT refer to the preceding 30s (but following)! => Output marker file from Dominik's Script does though)
        sleepstages(:,1) = sleepstages(:,1)-30*fsample+1;
        
        
        clear CycleNo
        clear N_REM
        clear percentile
        clear sleepcycle_file
        
        %% make new cfg_trl.trl
        cfg_trlSWA.trl = sleepstages; 

        % ----------------------------------------------
        % Segmentation 2 - redefine 30 s trials for SWA Analysis
        %------------------------------------------------        
        tmp_data_SWAsegm   = ft_redefinetrial(cfg_trlSWA, data_cont_segm); %Segmentation
        
        % now segment each 30s epoch into 2s segments and reject those with
        % artefacts
        cfg = []; 
        cfg.length = 2;
        tmp_data_SWAsegm2   = ft_redefinetrial(cfg, tmp_data_SWAsegm); %Segmentation 2s epochs       
        data_SWAsegm_clean = ft_rejectartifact(cfg_artrej_contdata, tmp_data_SWAsegm2);
        
        clear data_cont
        % ----------------------------
        % FT_REJECTVISUAL
        % ----------------------------
        chan_to_rej = {'VEOG', 'E1_2', 'EMG', 'ECG', 'EOG_riglow', 'EOG_lefup'};  % not needed for further analysis, A1/A2 still included!
        
%         % all electrodes to be removed have to be listed here! We have not
%         % removed any elecs during the first round of preprocessing
%         if strcmp(VPname, '1994LUAA_V1_sleep_mel-_LiveAmp')
% 	            chan_to_rej3 = {'F3'};  % F3 shitty
% 	        elseif strcmp(VPname, '1997ALKL_V1_sleep_mel+_LiveAmp')
% 	            chan_to_rej3 = {'F3'};  % F3 shitty
% 	        elseif strcmp(VPname, '1999RTLY_V2_sleep_mel+_LiveAmp')
% 	            chan_to_rej3 = {'C4', 'F8', 'T7', 'F3'};  % C4/F8 dead
% 	        elseif strcmp(VPname, '1995PTAF_V1_sleep_mel-_LiveAmp')
% 	            chan_to_rej3 = {'Fp1'};  % FP1 shitty
% 	        elseif strcmp(VPname, '1995PTAF_V2_sleep_mel+_LiveAmp')
% 	            chan_to_rej3 = {'Fp1'};  % FP1 shitty
% 	        elseif strcmp(VPname, '1996RTHL_V1_sleep_mel-_LiveAmp')
% 	            chan_to_rej3 = {'O2'};  % O2 shitty
% 	        elseif strcmp(VPname, '2000DLAL_V1_sleep_mel+_LiveAmp')
% 	            chan_to_rej3 = {'T8'};  % T8 shitty
%         else
%             chan_to_rej3 = {};
%         end

        chan_to_rej1 = horzcat(chan_to_rej, chan_to_rej3); 
        chan_to_rej1 = unique(chan_to_rej1);
        
        % final cleaning of data
        chan_to_rej2 = ismember(data_cont_segm.label, chan_to_rej1);
        
        cfg = [];
        cfg.channel = data_cont_segm.label(chan_to_rej2 == 0);
        data_cont_segm_finalclean = ft_selectdata(cfg, data_cont_segm); % only removed channels
        data_SWAsegm_finalclean = ft_selectdata(cfg, data_SWAsegm_clean); % removed channels & artefacts
        
        clear tmp_data*
               
        % ----------------------------------
        % Rereference to A1/A2 (digitally linked mastoids)
        % ----------------------------------
        cfg = [];
        cfg.reref = 'yes';
        cfg.implicitref = 'FCz';
%             if strcmp(VPname, '1994LUAA_V1_sleep_mel-_LiveAmp') | strcmp(VPname, '1994LUAA_V2_sleep_mel+_LiveAmp')
%                 cfg.refchannel = {'A2'};  
%             else
            cfg.refchannel = {'A1', 'A2'};
%             end
        data_reref = ft_preprocessing(cfg, data_cont_segm_finalclean);
        save(strcat(VPname, '_reref'), 'data_reref', 'cfg_trlSWA','-v7.3');  %% save rereferenced data
        clear data_cont_segm_finalclean

        data_SWAreref = ft_preprocessing(cfg, data_SWAsegm_finalclean);
        save(strcat(VPname, '_SWAreref'), 'data_SWAreref','-v7.3');  %% save rereferenced data
        clear data_SWAsegm_finalclean
        clear data_reref data_SWAreref
        
%         if k <length(filenames) 
%             interrupt=input('Insert y to continue. Otherwise insert n: ', 's');
%             while ~(or(interrupt=='y', interrupt=='n'))
%                 interrupt=input('Insert y to continue. Otherwise insert n: ', 's');
%             end
%             if interrupt == 'n'
%                 msg = 'You decided to stop here.';
%                 error(msg)
%             end
%         end
%         
%         if strcmp(interrupt, 'y')
%             continue
%         end

    end

end