%% Prepare Layout
clear all
addpath('C:\Program Files\MATLAB\toolboxes_CB\obob_ownft');
addpath('C:\Users\chris\Nextcloud\1 Forschung\03 Projects\1 Schrödinger\LocGlob_Oddball\Analysis');
obob_init_ft;

set(0,'DefaultFigureColormap', jet);
cd('C:\Users\chris\Nextcloud\1 Forschung\03 Projects\1 Schrödinger\LocGlob_Oddball\Analysis\layouts');

%% 
cfg = [];
cfg.layout = 'EEG_CB_REF.lay';
cfg.output = 'EEG_CB_REF.mat';
layout = ft_prepare_layout(cfg);