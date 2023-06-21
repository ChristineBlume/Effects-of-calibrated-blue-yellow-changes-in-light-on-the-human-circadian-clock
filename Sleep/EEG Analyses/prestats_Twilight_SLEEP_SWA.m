function prestats_Twilight_SLEEP_SWA (path_data, computer)

% Function written by Christine Blume.

%% Load the necessary stuff
clearvars -except path_data computer

% path_data = 'E:\10 Data\12-ALocGlo\rawdata_ALocGlo_oddball\LightSleep_EXP';
% 
% computer = 2;

if computer == 1
    p = 'R:\Chronobiologie_Forschung\STUDIEN\Twilight\'; % chronovideo
    load(strcat(p, 'Github-copy\Twilight\Sleep\EEG Analyses\layouts\EEG_CB_noREF.mat'));
    load(strcat(p, 'Github-copy\Twilight\Sleep\EEG Analyses\layouts\electrodes_foranalysis.mat'));
    load(strcat(p, 'Github-copy\Twilight\Sleep\EEG Analyses\layouts\LiveAmp_neighbours_FCz.mat'));
    elec = ft_read_sens(strcat(p,'toolboxes_CB\obob_ownft\external\fieldtrip\template\electrode\easycap-M1_CB_FCz.txt'));
elseif computer == 2
    p = 'C:\Users\chris\'; % Basel
    load(strcat(p, 'Documents\GitHub\Twilight\Sleep\EEG Analyses\layouts\EEG_CB_noREF.mat'));
    load(strcat(p, 'Documents\GitHub\Twilight\Sleep\EEG Analyses\layouts\electrodes_foranalysis.mat'));
    load(strcat(p, 'Documents\GitHub\Twilight\Sleep\EEG Analyses\layouts\LiveAmp_neighbours_FCz.mat'));
end

cd(path_data)

%% Load files, average
files_BKG        = dir('*BKG_*SWA_FFT.mat');
filenames_BKG    = {files_BKG.name};
files_B       = dir('*B_*SWA_FFT.mat');
filenames_B   = {files_B.name};
files_Y       = dir('*Y_*SWA_FFT.mat');
filenames_Y   = {files_Y.name};
clear files_*

% from [0.5:0.5:5] % available freqs
freq_selec = 1:9; % 0.5-4.5 Hz

% Prepare matrices for saving the results
cyc_data_all_p = NaN(60,16); % 3x NREM & 3x REM x 10 percentiles, 16 participants
cyc_data_all = NaN(6,16); %3x NREM & 3x REM, 16 participants

% loop through files BKG
for k = 1:length(filenames_BKG)
    
    data = load(filenames_BKG{k});
    if isfield(data, 'fft_data1') %can be fft_data1/2/3
        data = data.fft_data1;
    elseif isfield(data, 'fft_data2')
        data = data.fft_data2;
    elseif isfield(data, 'fft_data3')
        data = data.fft_data3;
    end
    
    % select frontal channels
    cfg = [];
    cfg.channel = {'Fz', 'F3', 'F4'};
    data_red = ft_selectdata(cfg, data);
    
    % select trials - first for each percentile and then for the whole
    % cycle 1
    % ---- NREM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 1); % cycle 1, NREM, percentile / last col: sleep stage
    cyc_NR_1_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(1,k) = mean(cyc_NR_1_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 2);
    cyc_NR_1_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(2,k) = mean(cyc_NR_1_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 3);
    cyc_NR_1_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(3,k) = mean(cyc_NR_1_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 4);
    cyc_NR_1_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(4,k) = mean(cyc_NR_1_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 5);
    cyc_NR_1_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(5,k) = mean(cyc_NR_1_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 6);
    cyc_NR_1_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(6,k) = mean(cyc_NR_1_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 7);
    cyc_NR_1_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(7,k) = mean(cyc_NR_1_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 8);
    cyc_NR_1_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(8,k) = mean(cyc_NR_1_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 9);
    cyc_NR_1_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(9,k) = mean(cyc_NR_1_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 10);
    cyc_NR_1_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(10,k) = mean(cyc_NR_1_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0);
    cyc_NR_1 = ft_selectdata(cfg, data_red);
    cyc_data_all(1,k) = mean(cyc_NR_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_NR*
    
    % ---- REM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 1); % cycle 1, REM, percentile
    cyc_R_1_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(11,k) = mean(cyc_R_1_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 2);
    cyc_R_1_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(12,k) = mean(cyc_R_1_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 3);
    cyc_R_1_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(13,k) = mean(cyc_R_1_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 4);
    cyc_R_1_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(14,k) = mean(cyc_R_1_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 5);
    cyc_R_1_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(15,k) = mean(cyc_R_1_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 6);
    cyc_R_1_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(16,k) = mean(cyc_R_1_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 7);
    cyc_R_1_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(17,k) = mean(cyc_R_1_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 8);
    cyc_R_1_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(18,k) = mean(cyc_R_1_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 9);
    cyc_R_1_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(19,k) = mean(cyc_R_1_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 10);
    cyc_R_1_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(20,k) = mean(cyc_R_1_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1);
    cyc_R_1 = ft_selectdata(cfg, data_red);
    cyc_data_all(2,k) = mean(cyc_R_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_R*
    
    % cycle 2
    % ---- NREM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 1); % cycle 2, NREM, percentile
    cyc_NR_2_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(21,k) = mean(cyc_NR_2_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 2);
    cyc_NR_2_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(22,k) = mean(cyc_NR_2_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 3);
    cyc_NR_2_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(23,k) = mean(cyc_NR_2_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 4);
    cyc_NR_2_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(24,k) = mean(cyc_NR_2_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 5);
    cyc_NR_2_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(25,k) = mean(cyc_NR_2_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 6);
    cyc_NR_2_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(26,k) = mean(cyc_NR_2_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 7);
    cyc_NR_2_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(27,k) = mean(cyc_NR_2_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 8);
    cyc_NR_2_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(28,k) = mean(cyc_NR_2_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 9);
    cyc_NR_2_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(29,k) = mean(cyc_NR_2_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 10);
    cyc_NR_2_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(30,k) = mean(cyc_NR_2_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0);
    cyc_NR_2 = ft_selectdata(cfg, data_red);
    cyc_data_all(3,k) = mean(cyc_NR_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_NR*
    
    % ---- REM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 1); % cycle 2, REM, percentile
    cyc_R_2_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(31,k) = mean(cyc_R_2_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 2);
    cyc_R_2_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(32,k) = mean(cyc_R_2_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 3);
    cyc_R_2_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(33,k) = mean(cyc_R_2_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 4);
    cyc_R_2_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(34,k) = mean(cyc_R_2_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 5);
    cyc_R_2_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(35,k) = mean(cyc_R_2_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 6);
    cyc_R_2_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(36,k) = mean(cyc_R_2_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 7);
    cyc_R_2_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(37,k) = mean(cyc_R_2_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 8);
    cyc_R_2_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(38,k) = mean(cyc_R_2_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 9);
    cyc_R_2_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(39,k) = mean(cyc_R_2_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 10);
    cyc_R_2_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(40,k) = mean(cyc_R_2_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1);
    cyc_R_2 = ft_selectdata(cfg, data_red);
    cyc_data_all(4,k) = mean(cyc_R_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_R*
    
    % cycle 3
    % ---- NREM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 1); % cycle 2, NREM, percentile
    cyc_NR_3_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(41,k) = mean(cyc_NR_3_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 2);
    cyc_NR_3_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(42,k) = mean(cyc_NR_3_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 3);
    cyc_NR_3_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(43,k) = mean(cyc_NR_3_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 4);
    cyc_NR_3_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(44,k) = mean(cyc_NR_3_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 5);
    cyc_NR_3_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(45,k) = mean(cyc_NR_3_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 6);
    cyc_NR_3_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(46,k) = mean(cyc_NR_3_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 7);
    cyc_NR_3_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(47,k) = mean(cyc_NR_3_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 8);
    cyc_NR_3_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(48,k) = mean(cyc_NR_3_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 9);
    cyc_NR_3_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(49,k) = mean(cyc_NR_3_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 10);
    cyc_NR_3_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(50,k) = mean(cyc_NR_3_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0);
    cyc_NR_3 = ft_selectdata(cfg, data_red);
    cyc_data_all(5,k) = mean(cyc_NR_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_NR*
    
    % ---- REM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 1); % cycle 2, REM, percentile
    cyc_R_3_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(51,k) = mean(cyc_R_3_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 2);
    cyc_R_3_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(52,k) = mean(cyc_R_3_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 3);
    cyc_R_3_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(53,k) = mean(cyc_R_3_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 4);
    cyc_R_3_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(54,k) = mean(cyc_R_3_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 5);
    cyc_R_3_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(55,k) = mean(cyc_R_3_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 6);
    cyc_R_3_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(56,k) = mean(cyc_R_3_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 7);
    cyc_R_3_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(57,k) = mean(cyc_R_3_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 8);
    cyc_R_3_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(58,k) = mean(cyc_R_3_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 9);
    cyc_R_3_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(59,k) = mean(cyc_R_3_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 10);
    cyc_R_3_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(60,k) = mean(cyc_R_3_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1);
    cyc_R_3 = ft_selectdata(cfg, data_red);
    cyc_data_all(6,k) = mean(cyc_R_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_R* 
    clear data_red
end

%just renaming
cyc_data_all_p_BKG = cyc_data_all_p;
cyc_data_all_BKG = cyc_data_all;

% save data
save('cyc_data_all_p_BKG', 'cyc_data_all_p_BKG','-v7.3');  %% save data
save('cyc_data_all_BKG', 'cyc_data_all_BKG','-v7.3');  %% save data
writematrix(cyc_data_all_p_BKG,'cyc_data_all_p_BKG.csv') 
writematrix(cyc_data_all_BKG,'cyc_data_all_BKG.csv') 

clear cyc*
    
clear filenames_BKG

% loop through files BLUE (B)
for k = 1:length(filenames_B)
    data = load(filenames_B{k});
    
    if isfield(data, 'fft_data1') %can be fft_data1 or _data2
        data = data.fft_data1;
    elseif isfield(data, 'fft_data2')
        data = data.fft_data2;
    elseif isfield(data, 'fft_data3')
        data = data.fft_data3;
    end
    
    
    % select frontal channels
    cfg = [];
    cfg.channel = {'Fz', 'F3', 'F4'};
    data_red = ft_selectdata(cfg, data);
    
    % select trials - first for each percentile and then for the whole
    % cycle 1
    % ---- NREM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 1); % cycle 1, NREM, percentile/ last col: sleep stage
    cyc_NR_1_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(1,k) = mean(cyc_NR_1_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 2);
    cyc_NR_1_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(2,k) = mean(cyc_NR_1_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 3);
    cyc_NR_1_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(3,k) = mean(cyc_NR_1_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 4);
    cyc_NR_1_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(4,k) = mean(cyc_NR_1_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 5);
    cyc_NR_1_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(5,k) = mean(cyc_NR_1_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 6);
    cyc_NR_1_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(6,k) = mean(cyc_NR_1_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 7);
    cyc_NR_1_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(7,k) = mean(cyc_NR_1_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 8);
    cyc_NR_1_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(8,k) = mean(cyc_NR_1_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 9);
    cyc_NR_1_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(9,k) = mean(cyc_NR_1_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 10);
    cyc_NR_1_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(10,k) = mean(cyc_NR_1_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0);
    cyc_NR_1 = ft_selectdata(cfg, data_red);
    cyc_data_all(1,k) = mean(cyc_NR_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_NR*
    
    % ---- REM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 1); % cycle 1, REM, percentile/ last col: sleep stage
    cyc_R_1_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(11,k) = mean(cyc_R_1_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 2);
    cyc_R_1_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(12,k) = mean(cyc_R_1_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 3);
    cyc_R_1_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(13,k) = mean(cyc_R_1_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 4);
    cyc_R_1_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(14,k) = mean(cyc_R_1_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 5);
    cyc_R_1_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(15,k) = mean(cyc_R_1_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 6);
    cyc_R_1_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(16,k) = mean(cyc_R_1_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 7);
    cyc_R_1_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(17,k) = mean(cyc_R_1_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 8);
    cyc_R_1_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(18,k) = mean(cyc_R_1_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 9);
    cyc_R_1_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(19,k) = mean(cyc_R_1_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 10);
    cyc_R_1_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(20,k) = mean(cyc_R_1_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1);
    cyc_R_1 = ft_selectdata(cfg, data_red);
    cyc_data_all(2,k) = mean(cyc_R_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_R*
    
    % cycle 2
    % ---- NREM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 1); % cycle 2, NREM, percentile
    cyc_NR_2_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(21,k) = mean(cyc_NR_2_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 2);
    cyc_NR_2_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(22,k) = mean(cyc_NR_2_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 3);
    cyc_NR_2_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(23,k) = mean(cyc_NR_2_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 4);
    cyc_NR_2_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(24,k) = mean(cyc_NR_2_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 5);
    cyc_NR_2_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(25,k) = mean(cyc_NR_2_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 6);
    cyc_NR_2_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(26,k) = mean(cyc_NR_2_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 7);
    cyc_NR_2_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(27,k) = mean(cyc_NR_2_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 8);
    cyc_NR_2_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(28,k) = mean(cyc_NR_2_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 9);
    cyc_NR_2_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(29,k) = mean(cyc_NR_2_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 10);
    cyc_NR_2_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(30,k) = mean(cyc_NR_2_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0);
    cyc_NR_2 = ft_selectdata(cfg, data_red);
    cyc_data_all(3,k) = mean(cyc_NR_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_NR*
    
    % ---- REM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 1); % cycle 2, REM, percentile
    cyc_R_2_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(31,k) = mean(cyc_R_2_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 2);
    cyc_R_2_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(32,k) = mean(cyc_R_2_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 3);
    cyc_R_2_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(33,k) = mean(cyc_R_2_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 4);
    cyc_R_2_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(34,k) = mean(cyc_R_2_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 5);
    cyc_R_2_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(35,k) = mean(cyc_R_2_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 6);
    cyc_R_2_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(36,k) = mean(cyc_R_2_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 7);
    cyc_R_2_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(37,k) = mean(cyc_R_2_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 8);
    cyc_R_2_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(38,k) = mean(cyc_R_2_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 9);
    cyc_R_2_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(39,k) = mean(cyc_R_2_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 10);
    cyc_R_2_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(40,k) = mean(cyc_R_2_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1);
    cyc_R_2 = ft_selectdata(cfg, data_red);
    cyc_data_all(4,k) = mean(cyc_R_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_R*
    
    % cycle 3
    % ---- NREM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 1); % cycle 2, NREM, percentile, last col: sleep stage
    cyc_NR_3_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(41,k) = mean(cyc_NR_3_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 2);
    cyc_NR_3_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(42,k) = mean(cyc_NR_3_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 3);
    cyc_NR_3_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(43,k) = mean(cyc_NR_3_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 4);
    cyc_NR_3_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(44,k) = mean(cyc_NR_3_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 5);
    cyc_NR_3_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(45,k) = mean(cyc_NR_3_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 6);
    cyc_NR_3_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(46,k) = mean(cyc_NR_3_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 7);
    cyc_NR_3_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(47,k) = mean(cyc_NR_3_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 8);
    cyc_NR_3_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(48,k) = mean(cyc_NR_3_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 9);
    cyc_NR_3_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(49,k) = mean(cyc_NR_3_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 10);
    cyc_NR_3_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(50,k) = mean(cyc_NR_3_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0);
    cyc_NR_3 = ft_selectdata(cfg, data_red);
    cyc_data_all(5,k) = mean(cyc_NR_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_NR*
    
    % ---- REM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 1); % cycle 2, REM, percentile/ last col: sleep stage
    cyc_R_3_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(51,k) = mean(cyc_R_3_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 2);
    cyc_R_3_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(52,k) = mean(cyc_R_3_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 3);
    cyc_R_3_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(53,k) = mean(cyc_R_3_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 4);
    cyc_R_3_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(54,k) = mean(cyc_R_3_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 5);
    cyc_R_3_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(55,k) = mean(cyc_R_3_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 6);
    cyc_R_3_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(56,k) = mean(cyc_R_3_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 7);
    cyc_R_3_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(57,k) = mean(cyc_R_3_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 8);
    cyc_R_3_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(58,k) = mean(cyc_R_3_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 9);
    cyc_R_3_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(59,k) = mean(cyc_R_3_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 10);
    cyc_R_3_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(60,k) = mean(cyc_R_3_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1);
    cyc_R_3 = ft_selectdata(cfg, data_red);
    cyc_data_all(6,k) = mean(cyc_R_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_R* 
    clear data_red
end

%just renaming
cyc_data_all_p_B = cyc_data_all_p;
cyc_data_all_B = cyc_data_all;

% save data
save('cyc_data_all_p_B', 'cyc_data_all_p_B','-v7.3');  %% save data
save('cyc_data_all_B', 'cyc_data_all_B','-v7.3');  %% save data
writematrix(cyc_data_all_p_B,'cyc_data_all_p_B.csv') 
writematrix(cyc_data_all_B,'cyc_data_all_B.csv') 

clear cyc*
    
clear filenames_B

% loop through files YELLOW (Y)
for k = 1:length(filenames_Y)
    data = load(filenames_Y{k});
    
    if isfield(data, 'fft_data1') %can be fft_data1 or _data2
        data = data.fft_data1;
    elseif isfield(data, 'fft_data2')
        data = data.fft_data2;
    elseif isfield(data, 'fft_data3')
        data = data.fft_data3;
    end
    
    
    % select frontal channels
    cfg = [];
    cfg.channel = {'Fz', 'F3', 'F4'};
    data_red = ft_selectdata(cfg, data);
    
    % select trials - first for each percentile and then for the whole
    % cycle 1
    % ---- NREM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 1); % cycle 1, NREM, percentile
    cyc_NR_1_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(1,k) = mean(cyc_NR_1_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 2);
    cyc_NR_1_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(2,k) = mean(cyc_NR_1_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 3);
    cyc_NR_1_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(3,k) = mean(cyc_NR_1_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 4);
    cyc_NR_1_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(4,k) = mean(cyc_NR_1_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 5);
    cyc_NR_1_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(5,k) = mean(cyc_NR_1_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 6);
    cyc_NR_1_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(6,k) = mean(cyc_NR_1_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 7);
    cyc_NR_1_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(7,k) = mean(cyc_NR_1_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 8);
    cyc_NR_1_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(8,k) = mean(cyc_NR_1_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 9);
    cyc_NR_1_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(9,k) = mean(cyc_NR_1_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 10);
    cyc_NR_1_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(10,k) = mean(cyc_NR_1_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 0);
    cyc_NR_1 = ft_selectdata(cfg, data_red);
    cyc_data_all(1,k) = mean(cyc_NR_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_NR*
    
    % ---- REM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 1); % cycle 1, REM, percentile
    cyc_R_1_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(11,k) = mean(cyc_R_1_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 2);
    cyc_R_1_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(12,k) = mean(cyc_R_1_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 3);
    cyc_R_1_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(13,k) = mean(cyc_R_1_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 4);
    cyc_R_1_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(14,k) = mean(cyc_R_1_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 5);
    cyc_R_1_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(15,k) = mean(cyc_R_1_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 6);
    cyc_R_1_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(16,k) = mean(cyc_R_1_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 7);
    cyc_R_1_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(17,k) = mean(cyc_R_1_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 8);
    cyc_R_1_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(18,k) = mean(cyc_R_1_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 9);
    cyc_R_1_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(19,k) = mean(cyc_R_1_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 10);
    cyc_R_1_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(20,k) = mean(cyc_R_1_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 1 & data_red.trialinfo(:,2) == 1);
    cyc_R_1 = ft_selectdata(cfg, data_red);
    cyc_data_all(2,k) = mean(cyc_R_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_R*
    
    % cycle 2
    % ---- NREM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 1); % cycle 2, NREM, percentile
    cyc_NR_2_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(21,k) = mean(cyc_NR_2_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 2);
    cyc_NR_2_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(22,k) = mean(cyc_NR_2_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 3);
    cyc_NR_2_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(23,k) = mean(cyc_NR_2_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 4);
    cyc_NR_2_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(24,k) = mean(cyc_NR_2_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 5);
    cyc_NR_2_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(25,k) = mean(cyc_NR_2_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 6);
    cyc_NR_2_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(26,k) = mean(cyc_NR_2_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 7);
    cyc_NR_2_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(27,k) = mean(cyc_NR_2_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 8);
    cyc_NR_2_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(28,k) = mean(cyc_NR_2_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 9);
    cyc_NR_2_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(29,k) = mean(cyc_NR_2_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 10);
    cyc_NR_2_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(30,k) = mean(cyc_NR_2_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 0);
    cyc_NR_2 = ft_selectdata(cfg, data_red);
    cyc_data_all(3,k) = mean(cyc_NR_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_NR*
    
    % ---- REM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 1); % cycle 2, REM, percentile
    cyc_R_2_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(31,k) = mean(cyc_R_2_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 2);
    cyc_R_2_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(32,k) = mean(cyc_R_2_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 3);
    cyc_R_2_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(33,k) = mean(cyc_R_2_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 4);
    cyc_R_2_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(34,k) = mean(cyc_R_2_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 5);
    cyc_R_2_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(35,k) = mean(cyc_R_2_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 6);
    cyc_R_2_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(36,k) = mean(cyc_R_2_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 7);
    cyc_R_2_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(37,k) = mean(cyc_R_2_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 8);
    cyc_R_2_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(38,k) = mean(cyc_R_2_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 9);
    cyc_R_2_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(39,k) = mean(cyc_R_2_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 10);
    cyc_R_2_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(40,k) = mean(cyc_R_2_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 2 & data_red.trialinfo(:,2) == 1);
    cyc_R_2 = ft_selectdata(cfg, data_red);
    cyc_data_all(4,k) = mean(cyc_R_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_R*
    
    % cycle 3
    % ---- NREM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 1); % cycle 2, NREM, percentile
    cyc_NR_3_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(41,k) = mean(cyc_NR_3_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 2);
    cyc_NR_3_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(42,k) = mean(cyc_NR_3_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 3);
    cyc_NR_3_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(43,k) = mean(cyc_NR_3_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 4);
    cyc_NR_3_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(44,k) = mean(cyc_NR_3_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 5);
    cyc_NR_3_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(45,k) = mean(cyc_NR_3_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 6);
    cyc_NR_3_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(46,k) = mean(cyc_NR_3_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 7);
    cyc_NR_3_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(47,k) = mean(cyc_NR_3_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 8);
    cyc_NR_3_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(48,k) = mean(cyc_NR_3_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 9);
    cyc_NR_3_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(49,k) = mean(cyc_NR_3_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0 & data_red.trialinfo(:,3) == 10);
    cyc_NR_3_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(50,k) = mean(cyc_NR_3_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 0);
    cyc_NR_3 = ft_selectdata(cfg, data_red);
    cyc_data_all(5,k) = mean(cyc_NR_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_NR*
    
    % ---- REM
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 1); % cycle 2, REM, percentile
    cyc_R_3_1 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(51,k) = mean(cyc_R_3_1.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 2);
    cyc_R_3_2 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(52,k) = mean(cyc_R_3_2.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 3);
    cyc_R_3_3 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(53,k) = mean(cyc_R_3_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 4);
    cyc_R_3_4 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(54,k) = mean(cyc_R_3_4.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 5);
    cyc_R_3_5 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(55,k) = mean(cyc_R_3_5.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 6);
    cyc_R_3_6 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(56,k) = mean(cyc_R_3_6.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 7);
    cyc_R_3_7 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(57,k) = mean(cyc_R_3_7.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 8);
    cyc_R_3_8 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(58,k) = mean(cyc_R_3_8.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 9);
    cyc_R_3_9 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(59,k) = mean(cyc_R_3_9.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1 & data_red.trialinfo(:,3) == 10);
    cyc_R_3_10 = ft_selectdata(cfg, data_red);
    cyc_data_all_p(60,k) = mean(cyc_R_3_10.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    
    cfg = [];
    cfg.trials = find(data_red.trialinfo(:,1) == 3 & data_red.trialinfo(:,2) == 1);
    cyc_R_3 = ft_selectdata(cfg, data_red);
    cyc_data_all(6,k) = mean(cyc_R_3.powspctrm(:,:,freq_selec), 'all', 'omitnan');
    clear cyc_R* 
    clear data_red
end

%just renaming
cyc_data_all_p_Y = cyc_data_all_p;
cyc_data_all_Y = cyc_data_all;

% save data
save('cyc_data_all_p_Y', 'cyc_data_all_p_Y','-v7.3');  %% save data
save('cyc_data_all_Y', 'cyc_data_all_Y','-v7.3');  %% save data
writematrix(cyc_data_all_p_Y,'cyc_data_all_p_Y.csv') 
writematrix(cyc_data_all_Y,'cyc_data_all_Y.csv') 

clear cyc*
    
clear filenames_Y
end
