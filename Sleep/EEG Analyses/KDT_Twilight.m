function [] = KDT_Twilight(path_data, computer)

% Function written by Christine Blume for FFT analysis of the
% Twilight KDT data. Loads all files from one participant per condition and
% appends them to one single file per participant and condition.


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
    
    files = dir('*KDT*_reref.mat');
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
        files_VPn = dir(strcat(tmpfile, '*KDT*_reref.mat'));
        files_VPn = {files_VPn.name};

        VP_name

        % load files BKG
        files_BKG = dir(strcat(VP_name, '*BKG_*reref.mat'));
        tmpfiles_BKG = {files_BKG.name};
        data_BKG = load(string(tmpfiles_BKG(1)));
        data_BKG = data_BKG.data_reref;
            if length(files_BKG) >1 % max 3 files
                tmpfiles_BKG = {files_BKG.name};
                data1 = load(string(tmpfiles_BKG(2)));
                data1 = data1.data_reref;
                % append files
                cfg = [];
                data_BKG = ft_appenddata(cfg, data_BKG, data1);
                if length(files_BKG) == 3 % max 3 files
                    data2 = load(string(tmpfiles_BKG(3)));
                    data2 = data2.data_reref;
                    % append files
                    cfg = [];
                    data_BKG = ft_appenddata(cfg, data_BKG, data2);
                end
            clear data1 data2 tmpfiles_BKG
            end
        clear tmpfiles_BKG

        % load files B
        files_B = dir(strcat(VP_name, '*B_*reref.mat'));
        tmpfiles_B = {files_B.name};
        data_B = load(string(tmpfiles_B(1)));
        data_B = data_B.data_reref;
            if length(files_B) >1 % max 3 files
                tmpfiles_B = {files_B.name};
                data1 = load(string(tmpfiles_B(2)));
                data1 = data1.data_reref;
                % append files
                cfg = [];
                data_B = ft_appenddata(cfg, data_B, data1);
                if length(files_B) == 3 % max 3 files
                    data2 = load(string(tmpfiles_B(3)));
                    data2 = data2.data_reref;
                    % append files
                    cfg = [];
                    data_B = ft_appenddata(cfg, data_B, data2);
                end
            clear data1 data2 tmpfiles_B
            end
        clear tmpfiles_B

        % load files Y
        if strcmp(VP_name, '2001THSU0') == 0 % 2001 THSU: no yellow data/ data excluded
            files_Y = dir(strcat(VP_name, '*Y*_*reref.mat'));
            tmpfiles_Y = {files_Y.name};
            data_Y = load(string(tmpfiles_Y(1)));
            data_Y = data_Y.data_reref;
                if length(files_Y) >1 % max 3 files
                    tmpfiles_Y = {files_Y.name};
                    data1 = load(string(tmpfiles_Y(2)));
                    data1 = data1.data_reref;
                    % append files
                    cfg = [];
                    data_Y = ft_appenddata(cfg, data_Y, data1);
                    if length(files_Y) == 3 % max 3 files
                        data2 = load(string(tmpfiles_Y(3)));
                        data2 = data2.data_reref;
                        % append files
                        cfg = [];
                        data_Y = ft_appenddata(cfg, data_Y, data2);
                    end
                clear data1 data2 tmpfiles_Y
                end
            clear tmpfiles_Y
        end
               

        
        %% Fix excluded channels if necessary and remove A1/A2

            % -------------------------------------------------------
            % Remove A1/A2
            % -------------------------------------------------------
            cfg = [];
            cfg.channel = {'all', '-A1', '-A2'};
            data_BKG = ft_selectdata(cfg, data_BKG);
            data_B = ft_selectdata(cfg, data_B);
            if strcmp(VP_name, '2001THSU0') == 0 % 2001 THSU: no yellow data/ data excluded
                data_Y = ft_selectdata(cfg, data_Y);
            end

            % -------------------------------------------------------
            % FT_CHANNELREPAIR TO INTERPOLATE BAD CHANNELS
            % -------------------------------------------------------
            % interpolate bad channels
%             origchans = {'Fp1','Fp2','F3','F4','C3','C4','P3','P4','O1','O2','F7','F8','T7','T8','P7','P8','Fz','Cz','Pz','Oz','FPz','FCz'};
%             elec = ft_read_sens('E:\toolboxes_CB\obob_ownft\external\fieldtrip\template\electrode\easycap-M1_CB_FCz.txt');
            
            %data_BKG
            data_BKG.origlabel = elec.label;
            idxelec = match_str(data_BKG.origlabel, data_BKG.label); 
            badchans = data_BKG.origlabel(find(ismember(1:length(data_BKG.origlabel),idxelec)~=1)); % gives index of bad channel/missing electrode

            cfg = [];
            cfg.method = 'spline';
            cfg.neighbours = LiveAmp_neighbours;
            cfg.badchannel = badchans;
            cfg.elec = elec;
            cfg.senstype = 'EEG';
            data_BKG_chanrepair = ft_channelrepair(cfg, data_BKG);
            
            %data_B
            data_B.origlabel = elec.label;
            idxelec = match_str(data_B.origlabel, data_B.label); 
            badchans = data_B.origlabel(find(ismember(1:length(data_B.origlabel),idxelec)~=1)); % gives index of bad channel/missing electrode

            cfg = [];
            cfg.method = 'spline';
            cfg.neighbours = LiveAmp_neighbours;
            cfg.badchannel = badchans;
            cfg.elec = elec;
            cfg.senstype = 'EEG';
            data_B_chanrepair = ft_channelrepair(cfg, data_B);
            
            %data_Y
            if strcmp(VP_name, '2001THSU0') == 0 % 2001 THSU: no yellow data/ data excluded
                data_Y.origlabel = elec.label;
                idxelec = match_str(data_Y.origlabel, data_Y.label); 
                badchans = data_Y.origlabel(find(ismember(1:length(data_Y.origlabel),idxelec)~=1)); % gives index of bad channel/missing electrode
    
                cfg = [];
                cfg.method = 'spline';
                cfg.neighbours = LiveAmp_neighbours;
                cfg.badchannel = badchans;
                cfg.elec = elec;
                cfg.senstype = 'EEG';
                data_Y_chanrepair = ft_channelrepair(cfg, data_Y);
            end
            
            data_BKG = data_BKG_chanrepair;
            data_B = data_B_chanrepair;
            if strcmp(VP_name, '2001THSU0') == 0 % 2001 THSU: no yellow data/ data excluded
                data_Y = data_Y_chanrepair;
            end

            clear data*_chanrepair
        
        %% FFT analysis
        cfg = [];
        cfg.method = 'mtmfft';
        cfg.output = 'pow';
        cfg.keeptrials = 'yes';
        cfg.foi = 0.5:0.5:12; 
        cfg.taper = 'hanning'; %Fieldtrip: For signals lower than 30 Hz it is recommend to use only a single taper, e.g. a Hanning taper as shown above
        
        fft_data_BKG = ft_freqanalysis(cfg, data_BKG);
        fft_data_B = ft_freqanalysis(cfg, data_B);
        if strcmp(VP_name, '2001THSU0') == 0 % 2001 THSU: no yellow data/ data excluded
            fft_data_Y = ft_freqanalysis(cfg, data_Y);
        end

        
        
%% Save results

%% FFT
% data BKG
    % Save
    savename = strcat(VP_name, '_', 'BKG', '_', 'KDT_FFT');
    save(savename, 'fft_data_BKG', '-v7.3'); 
    clear savename
    
% data B
    % Save
    savename = strcat(VP_name, '_', 'B', '_', 'KDT_FFT');
    save(savename, 'fft_data_B', '-v7.3'); 
    clear savename
    
% data Y
    % Save
    if strcmp(VP_name, '2001THSU0') == 0 % 2001 THSU: no yellow data/ data excluded
        savename = strcat(VP_name, '_', 'Y', '_', 'KDT_FFT');
        save(savename, 'fft_data_Y', '-v7.3'); 
        clear savename
    end
        
    end

clearvars -except path_data layout LiveAmp_neighbours

end

