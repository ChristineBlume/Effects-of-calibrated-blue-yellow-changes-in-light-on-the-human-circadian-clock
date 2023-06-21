function prestats_Twilight_KDT (path_data, computer)

% Function written by Christine Blume for the Twilight Data.
% extracts frequency range and averages across electrodes.

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
files_BKG        = dir('*BKG_KDT_FFT.mat');
filenames_BKG    = {files_BKG.name};
files_B       = dir('*B_KDT_FFT.mat');
filenames_B   = {files_B.name};
files_Y       = dir('*Y_KDT_FFT.mat');
filenames_Y   = {files_Y.name};
clear files_*

% from [0.5:0.5:12] % available freqs
freq_theta = 8:14; % 4-7 Hz
freq_alpha = 16:24; % 8-12 Hz

% Prepare matrices for saving the results
KDT_data_all_frontal = NaN(6,16); % 3 KDTs, 2 freqs (alpha/theta), 16 participants
KDT_data_all_central = NaN(6,16); % 3 KDTs, 2 freqs (alpha/theta), 16 participants
KDT_data_all_parocc = NaN(6,16); % 3 KDTs, 2 freqs (alpha/theta), 16 participants

% matrices: Cols = Pbn; rows = KDT1_theta/KDT1_alpha/KDT2_theta/KDT2_alpha
% etc.

% NOTE: No data for KDT_yellow 1002THSU => Last column will stay empty

%% loop through files BKG
for k = 1:length(filenames_BKG)
    
    data = load(filenames_BKG{k});
    data = data.fft_data_BKG;
    
    % select electrodes & freqs
    % ---- FRONTAL/ KDT1
    cfg = [];
    cfg.channel = {'Fz', 'F3', 'F4'};
    cfg.trials = find(data.trialinfo(:,1) == 1); % KDT1
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_frontal(1,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_frontal(2,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- FRONTAL/ KDT2
    cfg = [];
    cfg.channel = {'Fz', 'F3', 'F4'};
    cfg.trials = find(data.trialinfo(:,1) == 2); % KDT2
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_frontal(3,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_frontal(4,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- FRONTAL/ KDT3
    cfg = [];
    cfg.channel = {'Fz', 'F3', 'F4'};
    cfg.trials = find(data.trialinfo(:,1) == 3); % KDT3
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_frontal(5,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_frontal(6,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- CENTRAL/ KDT1
    cfg = [];
    cfg.channel = {'Cz', 'C3', 'C4'};
    cfg.trials = find(data.trialinfo(:,1) == 1); % KDT1
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_central(1,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_central(2,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- CENTRAL/ KDT2
    cfg = [];
    cfg.channel = {'Cz', 'C3', 'C4'};
    cfg.trials = find(data.trialinfo(:,1) == 2); % KDT2
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_central(3,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_central(4,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- CENTRAL/ KDT3
    cfg = [];
    cfg.channel = {'Cz', 'C3', 'C4'};
    cfg.trials = find(data.trialinfo(:,1) == 3); % KDT3
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_central(5,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_central(6,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- PARIETO-OCCIPITAL/ KDT1
    cfg = [];
    cfg.channel = {'Pz', 'P3', 'P4', 'O2', 'Oz', 'O1'};
    cfg.trials = find(data.trialinfo(:,1) == 1); % KDT1
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_parocc(1,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_parocc(2,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- PARIETO-OCCIPITAL/ KDT2
    cfg = [];
    cfg.channel = {'Pz', 'P3', 'P4', 'O2', 'Oz', 'O1'};
    cfg.trials = find(data.trialinfo(:,1) == 2); % KDT2
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_parocc(3,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_parocc(4,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    
    % ---- PARIETO-OCCIPITAL/ KDT3
    cfg = [];
    cfg.channel = {'Pz', 'P3', 'P4', 'O2', 'Oz', 'O1'};
    cfg.trials = find(data.trialinfo(:,1) == 3); % KDT3
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_parocc(5,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_parocc(6,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
end

%just renaming
KDT_data_all_frontal_BKG = KDT_data_all_frontal;
KDT_data_all_central_BKG = KDT_data_all_central;
KDT_data_all_parocc_BKG = KDT_data_all_parocc;

% save data
save('KDT_data_all_frontal_BKG', 'KDT_data_all_frontal_BKG','-v7.3');  %% save data
writematrix(KDT_data_all_frontal_BKG,'KDT_data_all_frontal_BKG.csv') 

save('KDT_data_all_central_BKG', 'KDT_data_all_central_BKG','-v7.3');  %% save data
writematrix(KDT_data_all_central_BKG,'KDT_data_all_central_BKG.csv') 

save('KDT_data_all_parocc_BKG', 'KDT_data_all_parocc_BKG','-v7.3');  %% save data
writematrix(KDT_data_all_parocc_BKG,'KDT_data_all_parocc_BKG.csv') 

clear KDT_data_all*
    
clear filenames_BKG

%% BLUE

% Prepare matrices for saving the results
KDT_data_all_frontal = NaN(6,16); % 3 KDTs, 2 freqs (alpha/theta), 16 participants
KDT_data_all_central = NaN(6,16); % 3 KDTs, 2 freqs (alpha/theta), 16 participants
KDT_data_all_parocc = NaN(6,16); % 3 KDTs, 2 freqs (alpha/theta), 16 participants

% matrices: Cols = Pbn; rows = KDT1_theta/KDT1_alpha/KDT2_theta/KDT2_alpha
% etc.

% loop through files B
for k = 1:length(filenames_B)
    
    data = load(filenames_B{k});
    data = data.fft_data_B;
    
    % select electrodes & freqs
    % ---- FRONTAL/ KDT1
    cfg = [];
    cfg.channel = {'Fz', 'F3', 'F4'};
    cfg.trials = find(data.trialinfo(:,1) == 1); % KDT1
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_frontal(1,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_frontal(2,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- FRONTAL/ KDT2
    cfg = [];
    cfg.channel = {'Fz', 'F3', 'F4'};
    cfg.trials = find(data.trialinfo(:,1) == 2); % KDT2
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_frontal(3,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_frontal(4,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- FRONTAL/ KDT3
    cfg = [];
    cfg.channel = {'Fz', 'F3', 'F4'};
    cfg.trials = find(data.trialinfo(:,1) == 3); % KDT3
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_frontal(5,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_frontal(6,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- CENTRAL/ KDT1
    cfg = [];
    cfg.channel = {'Cz', 'C3', 'C4'};
    cfg.trials = find(data.trialinfo(:,1) == 1); % KDT1
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_central(1,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_central(2,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- CENTRAL/ KDT2
    cfg = [];
    cfg.channel = {'Cz', 'C3', 'C4'};
    cfg.trials = find(data.trialinfo(:,1) == 2); % KDT2
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_central(3,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_central(4,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- CENTRAL/ KDT3
    cfg = [];
    cfg.channel = {'Cz', 'C3', 'C4'};
    cfg.trials = find(data.trialinfo(:,1) == 3); % KDT3
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_central(5,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_central(6,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- PARIETO-OCCIPITAL/ KDT1
    cfg = [];
    cfg.channel = {'Pz', 'P3', 'P4', 'O2', 'Oz', 'O1'};
    cfg.trials = find(data.trialinfo(:,1) == 1); % KDT1
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_parocc(1,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_parocc(2,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- PARIETO-OCCIPITAL/ KDT2
    cfg = [];
    cfg.channel = {'Pz', 'P3', 'P4', 'O2', 'Oz', 'O1'};
    cfg.trials = find(data.trialinfo(:,1) == 2); % KDT2
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_parocc(3,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_parocc(4,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    
    % ---- PARIETO-OCCIPITAL/ KDT3
    cfg = [];
    cfg.channel = {'Pz', 'P3', 'P4', 'O2', 'Oz', 'O1'};
    cfg.trials = find(data.trialinfo(:,1) == 3); % KDT3
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_parocc(5,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_parocc(6,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
end

%just renaming
KDT_data_all_frontal_B = KDT_data_all_frontal;
KDT_data_all_central_B = KDT_data_all_central;
KDT_data_all_parocc_B = KDT_data_all_parocc;

% save data
save('KDT_data_all_frontal_B', 'KDT_data_all_frontal_B','-v7.3');  %% save data
writematrix(KDT_data_all_frontal_B,'KDT_data_all_frontal_B.csv') 

save('KDT_data_all_central_B', 'KDT_data_all_central_B','-v7.3');  %% save data
writematrix(KDT_data_all_central_B,'KDT_data_all_central_B.csv') 

save('KDT_data_all_parocc_B', 'KDT_data_all_parocc_B','-v7.3');  %% save data
writematrix(KDT_data_all_parocc_B,'KDT_data_all_parocc_B.csv') 

clear KDT_data_all*
    
clear filenames_B

%% YELLOW

% Prepare matrices for saving the results
KDT_data_all_frontal = NaN(6,16); % 3 KDTs, 2 freqs (alpha/theta), 16 participants
KDT_data_all_central = NaN(6,16); % 3 KDTs, 2 freqs (alpha/theta), 16 participants
KDT_data_all_parocc = NaN(6,16); % 3 KDTs, 2 freqs (alpha/theta), 16 participants

% matrices: Cols = Pbn; rows = KDT1_theta/KDT1_alpha/KDT2_theta/KDT2_alpha
% etc.

% loop through files Y
for k = 1:length(filenames_Y)
    
    data = load(filenames_Y{k});
    data = data.fft_data_Y;
    
    % select electrodes & freqs
    % ---- FRONTAL/ KDT1
    cfg = [];
    cfg.channel = {'Fz', 'F3', 'F4'};
    cfg.trials = find(data.trialinfo(:,1) == 1); % KDT1
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_frontal(1,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_frontal(2,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- FRONTAL/ KDT2
    cfg = [];
    cfg.channel = {'Fz', 'F3', 'F4'};
    cfg.trials = find(data.trialinfo(:,1) == 2); % KDT2
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_frontal(3,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_frontal(4,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- FRONTAL/ KDT3
    cfg = [];
    cfg.channel = {'Fz', 'F3', 'F4'};
    cfg.trials = find(data.trialinfo(:,1) == 3); % KDT3
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_frontal(5,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_frontal(6,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- CENTRAL/ KDT1
    cfg = [];
    cfg.channel = {'Cz', 'C3', 'C4'};
    cfg.trials = find(data.trialinfo(:,1) == 1); % KDT1
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_central(1,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_central(2,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- CENTRAL/ KDT2
    cfg = [];
    cfg.channel = {'Cz', 'C3', 'C4'};
    cfg.trials = find(data.trialinfo(:,1) == 2); % KDT2
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_central(3,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_central(4,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- CENTRAL/ KDT3
    cfg = [];
    cfg.channel = {'Cz', 'C3', 'C4'};
    cfg.trials = find(data.trialinfo(:,1) == 3); % KDT3
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_central(5,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_central(6,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- PARIETO-OCCIPITAL/ KDT1
    cfg = [];
    cfg.channel = {'Pz', 'P3', 'P4', 'O2', 'Oz', 'O1'};
    cfg.trials = find(data.trialinfo(:,1) == 1); % KDT1
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_parocc(1,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_parocc(2,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    clear KDT
    
    % ---- PARIETO-OCCIPITAL/ KDT2
    cfg = [];
    cfg.channel = {'Pz', 'P3', 'P4', 'O2', 'Oz', 'O1'};
    cfg.trials = find(data.trialinfo(:,1) == 2); % KDT2
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_parocc(3,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_parocc(4,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
    
    % ---- PARIETO-OCCIPITAL/ KDT3
    cfg = [];
    cfg.channel = {'Pz', 'P3', 'P4', 'O2', 'Oz', 'O1'};
    cfg.trials = find(data.trialinfo(:,1) == 3); % KDT3
    KDT = ft_selectdata(cfg, data);
    KDT_data_all_parocc(5,k) = mean(KDT.powspctrm(:,:,freq_theta), 'all', 'omitnan');
    KDT_data_all_parocc(6,k) = mean(KDT.powspctrm(:,:,freq_alpha), 'all', 'omitnan');
end

%just renaming
KDT_data_all_frontal_Y = KDT_data_all_frontal;
KDT_data_all_central_Y = KDT_data_all_central;
KDT_data_all_parocc_Y = KDT_data_all_parocc;

% save data
save('KDT_data_all_frontal_Y', 'KDT_data_all_frontal_Y','-v7.3');  %% save data
writematrix(KDT_data_all_frontal_Y,'KDT_data_all_frontal_Y.csv') 

save('KDT_data_all_central_Y', 'KDT_data_all_central_Y','-v7.3');  %% save data
writematrix(KDT_data_all_central_Y,'KDT_data_all_central_Y.csv') 

save('KDT_data_all_parocc_Y', 'KDT_data_all_parocc_Y','-v7.3');  %% save data
writematrix(KDT_data_all_parocc_Y,'KDT_data_all_parocc_Y.csv') 

clear KDT_data_all*
    
clear filenames_Y
end
