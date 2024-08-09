% Time-Frequency Analysis 
function time_frequency_analysis(folder_path_root, spm_path)
% initialization
if ~exist('spm_path', 'var')
    %spm_path = '/Users/greta/Desktop/spm12';
    %spm_path = '/Users/pschm/spm12_dev_main';
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

    % select TFA folder 
    folder_path_TFA = fullfile(folder_path_stats, 'TFA');

    % Create TFA folder if it doesn't exist
    if ~exist(folder_path_TFA, 'dir')
            mkdir(folder_path_TFA);
    end

    %% Wavelet estimation
    wavelet_job = [];
    preprocessed_file = spm_select('FPList', folder_path_pre, '^aefdfMspm.*\.mat$');
    wavelet_job{1}.spm.meeg.tf.tf.D = {preprocessed_file};
    wavelet_job{1}.spm.meeg.tf.tf.channels{1}.all = 'all';
    wavelet_job{1}.spm.meeg.tf.tf.frequencies = [6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40];
    wavelet_job{1}.spm.meeg.tf.tf.timewin = [-Inf Inf];
    wavelet_job{1}.spm.meeg.tf.tf.method.morlet.ncycles = 5;
    wavelet_job{1}.spm.meeg.tf.tf.method.morlet.timeres = 0;
    wavelet_job{1}.spm.meeg.tf.tf.method.morlet.subsample = 5;
    wavelet_job{1}.spm.meeg.tf.tf.phase = 1;
    wavelet_job{1}.spm.meeg.tf.tf.prefix = '';

    spm_jobman('run', wavelet_job);

    % Move files to TFA folder
    copyfile(spm_select('FPList', folder_path_pre, '^aefdfMspm.*\.mat$'), folder_path_TFA);

    
    %% Crop
    %Initialize a cell array to store job structure for the power file
    crop_job_power = [];

    % First job for power_file
    power_file = spm_select('FPList', folder_path_pre, '^tf_aefdfMspm.*\.mat$');

    crop_job_power{1}.spm.meeg.preproc.crop.D = {power_file};
    crop_job_power{1}.spm.meeg.preproc.crop.timewin = [-90 200];
    crop_job_power{1}.spm.meeg.preproc.crop.freqwin = [-Inf Inf];
    crop_job_power{1}.spm.meeg.preproc.crop.channels{1}.all = 'all';
    crop_job_power{1}.spm.meeg.preproc.crop.prefix = 'p';

    % Run the crop job for the power file
    spm_jobman('run', crop_job_power);

    % Move files to TFA folder
    files_to_move = spm_select('FPList', folder_path_pre, '^ptf_aefdfMspm.*\.mat$');
    for j = 1:size(files_to_move, 1)
        movefile(strtrim(files_to_move(j, :)), folder_path_TFA);
    end

    % Initialize a cell array to store job structure for the phase file
    crop_job_phase = [];

    % Second job for phase_file
    phase_file = spm_select('FPList', folder_path_pre, '^tph_aefdfMspm.*\.mat$');

    crop_job_phase{1}.spm.meeg.preproc.crop.D = {phase_file};
    %crop_job_phase{1}.spm.meeg.preproc.crop.timewin = [0 100];
    crop_job_phase{1}.spm.meeg.preproc.crop.timewin = [-90 200];
    crop_job_phase{1}.spm.meeg.preproc.crop.freqwin = [-Inf Inf];
    crop_job_phase{1}.spm.meeg.preproc.crop.channels{1}.all = 'all';
    crop_job_phase{1}.spm.meeg.preproc.crop.prefix = 'p';

    % Run the crop job for the phase file
    spm_jobman('run', crop_job_phase);

    % Move files to TFA folder
    files_to_move = spm_select('FPList', folder_path_pre, '^ptph_aefdfMspm.*\.mat$');
    for j = 1:size(files_to_move, 1)
        movefile(strtrim(files_to_move(j, :)), folder_path_TFA);
    end

    %% Average
    average_job = [];
    average_power = spm_select('FPList', folder_path_TFA, '^ptf_aefdfMspm.*\.mat$');
    average_phase = spm_select('FPList', folder_path_TFA, '^ptph_aefdfMspm.*\.mat$');
    
    average_job{1}.spm.meeg.averaging.average.D = {average_power};
    average_job{1}.spm.meeg.averaging.average.userobust.standard = false;
    average_job{1}.spm.meeg.averaging.average.plv = false;
    average_job{1}.spm.meeg.averaging.average.prefix = 'm';
    average_job{2}.spm.meeg.averaging.average.D = {average_phase};
    average_job{2}.spm.meeg.averaging.average.userobust.standard = false;
    average_job{2}.spm.meeg.averaging.average.plv = true;
    average_job{2}.spm.meeg.averaging.average.prefix = 'm';

    spm_jobman('run', average_job);


    %% Baseline rescaling
    baseline_job = [];
    baseline_rescaled = spm_select('FPList', folder_path_TFA, '^m.*tf_aefdfMspm.*\.mat$');
    baseline_job{1}.spm.meeg.tf.rescale.D = {baseline_rescaled};
    %baseline_job{1}.spm.meeg.tf.rescale.method.LogR.baseline.timewin = [0 100];
    baseline_job{1}.spm.meeg.tf.rescale.method.LogR.baseline.timewin = [-90 200];
    baseline_job{1}.spm.meeg.tf.rescale.method.LogR.baseline.pooledbaseline = 0;
    baseline_job{1}.spm.meeg.tf.rescale.method.LogR.baseline.Db = [];
    baseline_job{1}.spm.meeg.tf.rescale.prefix = 'r';

    spm_jobman('run', baseline_job);


    %% Contrasting conditions
    job = [];
    power = spm_select('FPList', folder_path_TFA, '^rmptf.*\.mat$');
    phase = spm_select('FPList', folder_path_TFA, '^mptph.*\.mat$');

    job{1}.spm.meeg.averaging.contrast.D = {power};
    job{1}.spm.meeg.averaging.contrast.contrast.c = [1 -1];
    job{1}.spm.meeg.averaging.contrast.contrast.label = '1';
    job{1}.spm.meeg.averaging.contrast.weighted = 1;
    job{1}.spm.meeg.averaging.contrast.prefix = 'w';
    job{2}.spm.meeg.averaging.contrast.D = {phase};
    job{2}.spm.meeg.averaging.contrast.contrast.c = [1 -1];
    job{2}.spm.meeg.averaging.contrast.contrast.label = '2';
    job{2}.spm.meeg.averaging.contrast.weighted = 1;
    job{2}.spm.meeg.averaging.contrast.prefix = 'w';

    spm_jobman('run', job);

    %% Creating 2D Time Frequency Images
    job = [];
    power = spm_select('FPList', folder_path_TFA, '^rmptf.*\.mat$');
    phase = spm_select('FPList', folder_path_TFA, '^mptph.*\.mat$');

    job{1}.spm.meeg.images.convert2images.D = {power};
    job{1}.spm.meeg.images.convert2images.mode = 'time x frequency';
    job{1}.spm.meeg.images.convert2images.conditions = {};
    job{1}.spm.meeg.images.convert2images.channels{1}.type = 'EEG';
    job{1}.spm.meeg.images.convert2images.timewin = [-Inf Inf];
    job{1}.spm.meeg.images.convert2images.freqwin = [-Inf Inf];
    job{1}.spm.meeg.images.convert2images.prefix = 'eeg_img_pow';

    job{2}.spm.meeg.images.convert2images.D = {phase};
    job{2}.spm.meeg.images.convert2images.mode = 'time x frequency';
    job{2}.spm.meeg.images.convert2images.conditions = {};
    job{2}.spm.meeg.images.convert2images.channels{1}.type = 'EEG';
    job{2}.spm.meeg.images.convert2images.timewin = [-Inf Inf];
    job{2}.spm.meeg.images.convert2images.freqwin = [-Inf Inf];
    job{2}.spm.meeg.images.convert2images.prefix = 'eeg_img_pha';

    spm_jobman('run', job);
    
end
