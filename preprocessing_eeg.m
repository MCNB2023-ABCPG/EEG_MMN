function preprocessing_eeg(folder_path_root, spm_path)

% initialization
if ~exist('spm_path', 'var')
    spm_path = '/Users/angelaseo/Documents/spm-main';
end

% set root path
if ~exist('folder_path_root','var')
    folder_path_root = fileparts(matlab.desktop.editor.getActiveFilename);
end

addpath(spm_path)
addpath(fullfile(folder_path_root,'job_functions'))
spm('defaults', 'eeg') 
spm_jobman('initcfg')

% specifying data, participant and run paths
folder_path_data = fullfile(folder_path_root, 'DATA'); % DATA foulder path
folder_base_sub = {'SUB1'}; 

% specifying the steps: fill in switch_prep
% 1 - convert
% 2 - montage
% 3 - prepare
% 4 - high-pass filter
% 5 - downsample
% 6 - low-pass filter
% 7 - epoch
% 8 - artefacts
% 9 - averaging

switch_prep = [4];


for i = 1:numel(folder_base_sub)

    S = []; % init empty structure
    S.folder_path_data = folder_path_data; % add data folder path
    S.folder_base_sub = folder_base_sub{i}; % add subject path
    
    % participant PRE directory
    folder_path_pre = fullfile(S.folder_path_data, S.folder_base_sub, 'PRE'); % Folder PRE for preprocessing path for the participant

        % Convert
        if any(switch_prep == 1)
            % select dataset
            dataset_path = cellstr(spm_select('ExtFPListRec', folder_path_pre, 'subject1.bdf', 1));
            
            % select channel selection
            chanfile_path = cellstr(spm_select('ExtFPListRec', folder_path_root, 'channelselection.mat', 1));
            
            % run
            convert(dataset_path, chanfile_path);
        end

        % Montage
        if any (switch_prep == 2)
            % select converted data file
            converted_file_path = spm_select('ExtFPListRec', folder_path_pre, '^spm.*\.mat$', 1);
          
            % select averaged and rereferenced eog
            montage_file_path = spm_select('ExtFPListRec', folder_path_root, 'avref_eog.mat', 1);
           
            % run
            montage(converted_file_path, montage_file_path);
        end

        % Prepare
        if any (switch_prep == 3)
            %select data file
            converted_file_path = spm_select('ExtFPListRec', folder_path_pre, '^Mspm.*\.mat$', 1);
        
            % select EEG sensor file
            eegsens_file_path = spm_select('ExtFPListRec', folder_path_root, 'sensors.pol', 1);

            % run
            prepare(converted_file_path, eegsens_file_path)
        end

        % High-pass Filter
        if any (switch_prep == 4)

            % select data file
            prepared_file_path = spm_select('ExtFPListRec', folder_path_pre, '^Mspm.*\.mat$', 1);
            
            % run
            highpassfilter(prepared_file_path)
        end

        % Downsample
        if any (switch_prep == 5)
            % select data file
            highpassed_filtered_file_path = spm_select('ExtFPListRec', folder_path_pre, '^fMspm.*\.mat$', 1);
            
            % run
            downsample(highpassed_filtered_file_path)
        end

        % Low-pass filter
        if any (switch_prep == 5)

            % select data file
            downsampled_file_path = spm_select('ExtFPListRec', folder_path_pre, '^dfMspm.*\.mat$', 1);

            % run
            lowpassfilter(downsampled_file_path)
        end

        % Epoch
        if any (switch_prep == 6)
            % select data file
            lowpass_filtered_file_path = spm_select('ExtFPListRec', folder_path_pre, '^fdfMspm.*\.mat$', 1);

            % select trial file
            trial_def_file_path = spm_select('ExtFPListRec', folder_path_root, 'trialdef.mat', 1);

            % run
            epoch(lowpass_filtered_file_path, trial_def_file_path)
        end

        % Artefacts
        if any (switch_prep == 7)

            % select data file
            epoched_file_path = spm_select('ExtFPListRec', folder_path_pre, '^efdfMspm.*\.mat$', 1);

            % run
            artefacts(epoched_file_path)
        end

        % Averaging
        if any (switch_prep == 8)

            % select data file
            artefact_removed_file_path = spm_select('ExtFPListRec', folder_path_pre, '^efdfMspm.*\.mat$', 1);

            % run
            averaging(artefact_removed_file_path)
        end

end
end