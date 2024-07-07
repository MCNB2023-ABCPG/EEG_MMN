% Time-Frequency Analysis 
function time_frequency_analysis(folder_path_root, spm_path)
% initialization
if ~exist('spm_path', 'var')
    spm_path = '/Users/greta/Desktop/spm12';
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

    % Wavelet estimation
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

    % % Move files to TFA folder
    movefile(spm_select('FPList', folder_path_pre, '^aefdfMspm.*\.mat$'), folder_path_TFA);

    
    % Crop
    %Initialize a cell array to store job structure for the power file
    crop_job_power = [];

    % First job for power_file
    power_file = spm_select('FPList', folder_path_pre, '^tf_aefdfMspm.*\.mat$');

    crop_job_power{1}.spm.meeg.preproc.crop.D = {power_file};
    crop_job_power{1}.spm.meeg.preproc.crop.timewin = [0 100];
    crop_job_power{1}.spm.meeg.preproc.crop.freqwin = [-Inf Inf];
    crop_job_power{1}.spm.meeg.preproc.crop.channels{1}.all = 'all';
    crop_job_power{1}.spm.meeg.preproc.crop.prefix = 'p';

    % Run the crop job for the power file
    spm_jobman('run', crop_job_power);

    % Move files to TFA folder
    files_to_move = spm_select('FPList', folder_path_pre, '^tf_aefdfMspm.*\.mat$');
    for j = 1:size(files_to_move, 1)
        movefile(strtrim(files_to_move(j, :)), folder_path_TFA);
    end

    % Initialize a cell array to store job structure for the phase file
    crop_job_phase = [];

        % Second job for phase_file
    phase_file = spm_select('FPList', folder_path_pre, '^tph_aefdfMspm.*\.mat$');

    crop_job_phase{1}.spm.meeg.preproc.crop.D = {phase_file};
    crop_job_phase{1}.spm.meeg.preproc.crop.timewin = [0 100];
    crop_job_phase{1}.spm.meeg.preproc.crop.freqwin = [-Inf Inf];
    crop_job_phase{1}.spm.meeg.preproc.crop.channels{1}.all = 'all';
    crop_job_phase{1}.spm.meeg.preproc.crop.prefix = 'p';

        % Run the crop job for the phase file
    spm_jobman('run', crop_job_phase);

    % Move files to TFA folder
    files_to_move = spm_select('FPList', folder_path_pre, '^tph_aefdfMspm.*\.mat$');
    for j = 1:size(files_to_move, 1)
        movefile(strtrim(files_to_move(j, :)), folder_path_TFA);
    end



%   % Average

    average_job = [];
    average_power = spm_select('FPList', folder_path_TFA, '^tf_aefdfMspm.*\.mat$');

    average_job{1}.spm.meeg.preproc.crop.D = {average_power};
    average_job{1}.spm.meeg.preproc.crop.timewin = [0 300];
    average_job{1}.spm.meeg.preproc.crop.freqwin = [-Inf Inf];
    average_job{1}.spm.meeg.preproc.crop.channels{1}.all = 'all';
    average_job{1}.spm.meeg.preproc.crop.prefix = 'p';
    average_job{2}.spm.meeg.preproc.crop.D = {average_power};
    average_job{2}.spm.meeg.preproc.crop.timewin = [0 300];
    average_job{2}.spm.meeg.preproc.crop.freqwin = [-Inf Inf];
    average_job{2}.spm.meeg.preproc.crop.channels{1}.all = 'all';
    average_job{2}.spm.meeg.preproc.crop.prefix = 'p';
    average_job{3}.spm.meeg.averaging.average.D(1) = cfg_dep('Crop: Cropped M/EEG datafile', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
    average_job{3}.spm.meeg.averaging.average.userobust.standard = false;
    average_job{3}.spm.meeg.averaging.average.plv = true;
    average_job{3}.spm.meeg.averaging.average.prefix = 'm';
    average_job{4}.spm.meeg.averaging.average.D(1) = cfg_dep('Crop: Cropped M/EEG datafile', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
    average_job{4}.spm.meeg.averaging.average.userobust.standard = false;
    average_job{4}.spm.meeg.averaging.average.plv = false;
    average_job{4}.spm.meeg.averaging.average.prefix = 'm';

    spm_jobman('run', average_job);
    % 

    % Baseline rescaling

    baseline_job = [];

    baseline_rescaled = spm_select('FPList', folder_path_TFA, '^m.*tf_aefdfMspm.*\.mat$');

    baseline_job{1}.spm.meeg.tf.rescale.D = {baseline_rescaled};
    baseline_job{1}.spm.meeg.tf.rescale.method.LogR.baseline.timewin = [0 100];
    baseline_job{1}.spm.meeg.tf.rescale.method.LogR.baseline.pooledbaseline = 0;
    baseline_job{1}.spm.meeg.tf.rescale.method.LogR.baseline.Db = [];
    baseline_job{1}.spm.meeg.tf.rescale.prefix = 'r';

    spm_jobman('run', baseline_job);
% 
end
