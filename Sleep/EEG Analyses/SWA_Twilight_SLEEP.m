function [] = SWA_Twilight_SLEEP(path_data, computer)

% Function written by Christine Blume for FFT analysis of the
% Twilight data


%% Load the necessary stuff
if computer == 1
    p = 'R:\Chronobiologie_Forschung\STUDIEN\Twilight\'; % chronovideo
    load(strcat(p, 'Github-copy\Twilight\Sleep\EEG Analyses\layouts\EEG_CB_noREF.mat'));
    load(strcat(p, 'Github-copy\Twilight\Sleep\EEG Analyses\layouts\electrodes_foranalysis.mat'));
    load(strcat(p, 'Github-copy\Twilight\Sleep\EEG Analyses\layouts\electrodes_foranalysis_old.mat'), 'eeg_chans');
    load(strcat(p, 'Github-copy\Twilight\Sleep\EEG Analyses\layouts\LiveAmp_neighbours_FCz.mat'));
    elec = ft_read_sens(strcat(p,'toolboxes_CB\obob_ownft\external\fieldtrip\template\electrode\easycap-M1_CB_FCz.txt'));
elseif computer == 2
    p = 'C:\Users\chris\'; % Basel
    load(strcat(p, 'Documents\GitHub\Twilight\Sleep\EEG Analyses\layouts\EEG_CB_noREF.mat'));
    load(strcat(p, 'Documents\GitHub\Twilight\Sleep\EEG Analyses\layouts\electrodes_foranalysis.mat'));
    load(strcat(p, 'Documents\GitHub\\Twilight\Sleep\EEG Analyses\layouts\LiveAmp_neighbours_FCz.mat'));
    elec = ft_read_sens('E:\toolboxes_CB\obob_ownft\external\fieldtrip\template\electrode\easycap-M1_CB_FCz.txt');
end

cd(path_data)
%% Preparing files
    % Prep filenames for finding all files belonging to the same participant
    % [not actually necessary, only if one wanted to exclude participants
    % with less than 3 nights]
    files = dir('*SWAreref*.mat');
    filenames = {files.name};

    for k = 1:length(filenames)
        if k == 1
        tmpfilenames = (strsplit(filenames{k}, '_'));
        filenames2 = cellstr(tmpfilenames{1});
        else
            tmpfilenames = (strsplit(filenames{k}, '_'));
            tmpfilenames = strcat(tmpfilenames{1});
            filenames2{k} = tmpfilenames;
        end
    end
    clear tmpfilenames
    clear k
%     clear filenames
    clear files
 
    filenames_unique = unique(filenames2); 
    clear filenames2
    
    for k = 1:length(filenames_unique)
        k
        % find files from one participant 
        tmpfile = filenames_unique{k};
        VP_name = tmpfile;
        files_VPn = dir(strcat(tmpfile, '*SWAreref*.mat'));
        files_VPn = {files_VPn.name};
               
        filename1 = string(files_VPn(1));
        data1 = load(string(files_VPn(1)));
        data1 = data1.data_SWAreref;

        filename2 = string(files_VPn(2));
        data2 = load(string(files_VPn(2)));
        data2 = data2.data_SWAreref;

if length(files_VPn) == 3 % there is one participant with only 2 files
        filename3 = string(files_VPn(3));
        data3 = load(string(files_VPn(3)));
        data3 = data3.data_SWAreref;
end
        
        %% Fix excluded channels if necessary and remove A1/A2

            % -------------------------------------------------------
            % Remove A1/A2
            % -------------------------------------------------------
            cfg = [];
            cfg.channel = {'all', '-A1', '-A2'};
            data1 = ft_selectdata(cfg, data1);
            data2 = ft_selectdata(cfg, data2);
            if length(files_VPn) == 3 % there is one participant with only 2 files
                data3 = ft_selectdata(cfg, data3);
            end
    
            % -------------------------------------------------------
            % FT_CHANNELREPAIR TO INTERPOLATE BAD CHANNELS
            % -------------------------------------------------------
            % interpolate bad channels
%             origchans = {'Fp1','Fp2','F3','F4','C3','C4','P3','P4','O1','O2','F7','F8','T7','T8','P7','P8','Fz','Cz','Pz','Oz','FPz','FCz'};
%             elec = ft_read_sens('E:\toolboxes_CB\obob_ownft\external\fieldtrip\template\electrode\easycap-M1_CB_FCz.txt');
            
            %data1
            data1.origlabel = elec.label;
            idxelec = match_str(data1.origlabel, data1.label); 
            badchans = data1.origlabel(find(ismember(1:length(data1.origlabel),idxelec)~=1)); % gives index of bad channel/missing electrode

            cfg = [];
            cfg.method = 'spline';
            cfg.neighbours = LiveAmp_neighbours;
            cfg.badchannel = badchans;
            cfg.elec = elec;
            cfg.senstype = 'EEG';
            data1_chanrepair = ft_channelrepair(cfg, data1);
            
            %data2
            data2.origlabel = elec.label;
            idxelec = match_str(data2.origlabel, data2.label); 
            badchans = data2.origlabel(find(ismember(1:length(data2.origlabel),idxelec)~=1)); % gives index of bad channel/missing electrode

            cfg = [];
            cfg.method = 'spline';
            cfg.neighbours = LiveAmp_neighbours;
            cfg.badchannel = badchans;
            cfg.elec = elec;
            cfg.senstype = 'EEG';
            data2_chanrepair = ft_channelrepair(cfg, data2);
            
            %data3
            if length(files_VPn) == 3 % there is one participant with only 2 files
                data3.origlabel = elec.label;
                idxelec = match_str(data3.origlabel, data3.label); 
                badchans = data3.origlabel(find(ismember(1:length(data3.origlabel),idxelec)~=1)); % gives index of bad channel/missing electrode
    
                cfg = [];
                cfg.method = 'spline';
                cfg.neighbours = LiveAmp_neighbours;
                cfg.badchannel = badchans;
                cfg.elec = elec;
                cfg.senstype = 'EEG';
                data3_chanrepair = ft_channelrepair(cfg, data3);
            end
            
            data1 = data1_chanrepair;
            data2 = data2_chanrepair;

            if length(files_VPn) == 3 % there is one participant with only 2 files
                data3 = data3_chanrepair;
            end

            clear data*_chanrepair
        
        %% FFT analysis
        cfg = [];
        cfg.method = 'mtmfft';
        cfg.output = 'pow';
        cfg.keeptrials = 'yes';
        cfg.foi = 0.5:0.5:5; 
        cfg.taper = 'hanning'; %Fieldtrip: For signals lower than 30 Hz it is recommend to use only a single taper, e.g. a Hanning taper as shown above
        
        fft_data1 = ft_freqanalysis(cfg, data1);
        fft_data2 = ft_freqanalysis(cfg, data2);
        if length(files_VPn) == 3 % there is one participant with only 2 files
            fft_data3 = ft_freqanalysis(cfg, data3);
        end

        
        
%% Save results

%% FFT
% data 1
    % Save
    split = (strsplit(filename1, '_'));
    savename = strcat(split{1}, '_', split{2}, '_', split{3}, '_', split{4}, '_', 'SWA_FFT');
    save(savename, 'fft_data1', '-v7.3'); 
    clear savename
    
% data 2
    % Save
    split = (strsplit(filename2, '_'));
    savename = strcat(split{1}, '_', split{2}, '_', split{3}, '_', split{4}, '_', 'SWA_FFT');
    save(savename, 'fft_data2', '-v7.3'); 
    clear savename
    
% data 3
    % Save
    if length(files_VPn) == 3 % there is one participant with only 2 files
        split = (strsplit(filename3, '_'));
        savename = strcat(split{1}, '_', split{2}, '_', split{3}, '_', split{4}, '_', 'SWA_FFT');
        save(savename, 'fft_data3', '-v7.3'); 
        clear savename
    end
        
    end

clearvars -except path_data layout LiveAmp_neighbours

end

