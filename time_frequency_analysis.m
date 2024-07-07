% Time-Frequency Analysis 
function time_frequency_analysis(folder_path_root, spm_path)
% initialization
if ~exist('spm_path', 'var')
    spm_path = '/Users/angelaseo/Documents/spm-main';
end

% set root path
if ~exist('folder_path_root','var')
    folder_path_root = fileparts(matlab.desktop.editor.getActiveFilename);
end

addpath(spm_path)
spm('defaults', 'eeg')
spm_jobman('initcfg')

% specifying data, participant and run paths
folder_path_data = fullfile(folder_path_root, 'DATA'); % DATA folder path
folder_base_sub = {'SUB1'};

for i = 1:numel(folder_base_sub)

    S = []; % init empty structure
    S.folder_path_data = folder_path_data; % add data folder path
    S.folder_base_sub = folder_base_sub{i}; % add subject path
    
    % participant PRE directory
    folder_path_pre = fullfile(S.folder_path_data, S.folder_base_sub, 'PRE'); % Folder PRE for preprocessing path for the participant
    
    % select STATS directory
    folder_path_stats = fullfile(S.folder_path_data, S.folder_base_sub, 'STATS');

    % Wavelet estimation
    job = [];
    preprocessed_file = spm_select('FPList', folder_path_pre, '^aefdfMspm.*\.mat$');
    job{1}.spm.meeg.tf.tf.D = {preprocessed_file};
    job{1}.spm.meeg.tf.tf.channels{1}.all = 'all';
    job{1}.spm.meeg.tf.tf.frequencies = [6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40];
    job{1}.spm.meeg.tf.tf.timewin = [-Inf Inf];
    job{1}.spm.meeg.tf.tf.method.morlet.ncycles = 5;
    job{1}.spm.meeg.tf.tf.method.morlet.timeres = 0;
    job{1}.spm.meeg.tf.tf.method.morlet.subsample = 5;
    job{1}.spm.meeg.tf.tf.phase = 1;
    job{1}.spm.meeg.tf.tf.prefix = '';

    spm_jobman('run', job);

    move converted subject folder to STATS
    power_file = 'tf_aefdfMspmeeg_subject1.mat';
    movefile(fullfile(folder_path_pre, power_file), fullfile(folder_path_stats, power_file))

    phase_file = 'tph_aefdfMspmeeg_subject1.mat';
    movefile(fullfile(folder_path_pre, phase_file), fullfile(folder_path_stats, phase_file))

    % Crop
end
