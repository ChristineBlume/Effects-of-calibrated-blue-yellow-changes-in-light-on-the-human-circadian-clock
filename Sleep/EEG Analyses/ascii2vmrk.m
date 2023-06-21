%% Write BV Marker files from Sleepstaging Results
addpath('C:\Users\chris\Nextcloud\1 Forschung\11 Matlab scripts\SleepScience');
addpath('E:\toolboxes_CB\eeglab2021.0');
eeglab
dpjh_write_stages_120716('stagePath', 'E:\10 Data\14-Twilight\Twilight\1_RAW Data (R Drive)\Twilight_EXPERIMENTAL\SleepStaging_G3\for_SleepCycles_2022-11-15\already processed 15-22-2022',...
    'sRate', 500, 'fileFormat', '.csv', 'markerDistance', 30, 'writeOut', 1); % start eeglab by typing eeglab in the console first if this is not working