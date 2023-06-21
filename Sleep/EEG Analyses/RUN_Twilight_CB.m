%% %%%%% BASEL %%%%%
clear all
addpath('R:\Chronobiologie_Forschung\STUDIEN\Twilight\toolboxes_CB\obob_ownft');
% addpath('E:\toolboxes_CB\obob_ownft'); % christine
obob_init_ft;

% set(0,'DefaultFigureColormap', jet);
set(0,'DefaultFigureColormap', parula);

%------ christine
% addpath('E:\toolboxes_CB\obob_ownft');
% addpath('C:\Users\chris\Documents\GitHub\Twilight\Sleep\EEG Analyses');
% addpath('E:\toolboxes_CB\export_fig\altmany-export_fig-9aba302');

%------ Analysis PC
p = 'R:\Chronobiologie_Forschung\STUDIEN\Twilight\';
addpath(strcat(p, 'toolboxes_CB\obob_ownft'));
addpath(strcat(p, 'GitHub-copy\Twilight\Sleep\EEG Analyses'));
addpath(strcat(p, '\toolboxes_CB\export_fig\altmany-export_fig-9aba302'));

%% ---------------------------------------------
% Preprocessing KDT
% preprocessing_Twilight_KDT(strcat(p, '1_RAW Data (R Drive)\Twilight_EXPERIMENTAL\KDT Data_Fieldtrip\'), 1); % 1 = Analysis PC, 2 = Christine
% preprocessing_Twilight_KDT_followup(strcat(p, '1_RAW Data (R Drive)\Twilight_EXPERIMENTAL\KDT Data_Fieldtrip\'), 1); % 1 = Analysis PC, 2 = Christine
% KDT_Twilight(strcat(p, '1_RAW Data (R Drive)\Twilight_EXPERIMENTAL\KDT Data_Fieldtrip\'), 1); % 1 = Analysis PC, 2 = Christine
% prestats_Twilight_KDT(strcat(p, '1_RAW Data (R Drive)\Twilight_EXPERIMENTAL\KDT Data_Fieldtrip\'), 1); % 1 = Analysis PC, 2 = Christine

%% ----------------------------
% Preprocessing PSG data
% -----------------------------
% preprocessing_Twilight_SLEEP(strcat(p, '1_RAW Data (R Drive)\Twilight_EXPERIMENTAL\Sleep Data_Fieldtrip\'), 1); % 1 = Analysis PC, 2 = Christine
% preprocessing_Twilight_SLEEP_followup(strcat(p, '1_RAW Data (R Drive)\Twilight_EXPERIMENTAL\Sleep Data_Fieldtrip\'), 1); % 1 = Analysis PC, 2 = Christine

% -----------------------------
% ##### SWA data
SWA_Twilight_SLEEP(strcat(p, '1_RAW Data (R Drive)\Twilight_EXPERIMENTAL\Sleep Data_Fieldtrip\'), 1); % 1 = Analysis PC, 2 = Christine
prestats_Twilight_SLEEP_SWA(strcat(p, '1_RAW Data (R Drive)\Twilight_EXPERIMENTAL\Sleep Data_Fieldtrip\'), 1); % 1 = Analysis PC, 2 = Christine