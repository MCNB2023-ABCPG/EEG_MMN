function second_level_analysis_eeg(folder_path_root, spm_path)
% initialization
if ~exist('spm_path', 'var')
    spm_path = '/Users/angelaseo/Documents/spm-main';
    %spm_path = '/Users/pschm/spm12_dev_main';
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

for i = 1:numel(folder_base_sub)

    S = []; % init empty structure
    S.folder_path_data = folder_path_data; % add data folder path
    S.folder_base_sub = folder_base_sub{i}; % add subject path
    
    % participant PRE directory
    folder_path_pre = fullfile(S.folder_path_data, S.folder_base_sub, 'PRE'); % Folder PRE for preprocessing path for the participant
    
    % select STATS directory
    folder_path_stats = fullfile(S.folder_path_data, S.folder_base_sub, 'STATS');

      % select ERP folder 
    folder_path_ERP = fullfile(folder_path_stats, 'ERP');

    % Create TFA folder if it doesn't exist
    if ~exist(folder_path_ERP, 'dir')
            mkdir(folder_path_ERP);
    end

% Convert to NIFTI Image
    preprocessed_image = spm_select('FPList', folder_path_pre, '^aefdfMspm.*\.mat$');
    convert2image(preprocessed_image)

    % move converted subject folder to STATS
    basename = 'aefdfMspmeeg_subject1';
    movefile(fullfile(folder_path_pre, basename), fullfile(folder_path_ERP, basename))

  % Factorial Design Specification
    job = [];
    subject_folder =  'aefdfMspmeeg_subject1';
    job{1}.spm.stats.factorial_design.dir = {folder_path_ERP};
    
    % Selecting nii files for condition_standard
    condition1 = spm_select('ExtFPList', fullfile(folder_path_ERP, subject_folder), '^condition_standard.*\.nii$');
    job{1}.spm.stats.factorial_design.des.t2.scans1 = cellstr(condition1);

    % Select nii files for condition_rare
    condition2 = spm_select('ExtFPList', fullfile(folder_path_ERP, subject_folder), '^condition_rare.*\.nii$');
    job{1}.spm.stats.factorial_design.des.t2.scans2 = cellstr(condition2);

    job{1}.spm.stats.factorial_design.des.t2.dept = 0;
    job{1}.spm.stats.factorial_design.des.t2.variance = 1;
    job{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
    job{1}.spm.stats.factorial_design.des.t2.ancova = 0;
    job{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    job{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    job{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    job{1}.spm.stats.factorial_design.masking.im = 1;
    job{1}.spm.stats.factorial_design.masking.em = {''};
    job{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    job{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    job{1}.spm.stats.factorial_design.globalm.glonorm = 1;

    spm_jobman('run', job);

    % Estimate
    design_file = spm_select('FPList', folder_path_ERP, '^SPM.mat$');    %selecting the desgin matrix specified earlier

    job = [];
    job{1}.spm.stats.fmri_est.spmmat = {design_file};
    job{1}.spm.stats.fmri_est.write_residuals = 0;
    job{1}.spm.stats.fmri_est.method.Classical = 1;

    spm_jobman('run', job)

    % Contrasts
    design_file = spm_select('FPList', folder_path_ERP, '^SPM.mat$');

    job = [];
    job{1}.spm.stats.con.spmmat = {design_file};
    job{1}.spm.stats.con.consess{1}.fcon.name = 'standard>rare';
    job{1}.spm.stats.con.consess{1}.fcon.weights = [1 -1]; % can be switched around
    job{1}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
    job{1}.spm.stats.con.delete = 0;

    spm_jobman('run', job);

    % Reporting Results
    design_file = spm_select('FPList', folder_path_ERP, '^SPM.mat$');

    job = [];
    job{1}.spm.stats.results.spmmat = {design_file};
    job{1}.spm.stats.results.conspec.titlestr = '';
    job{1}.spm.stats.results.conspec.contrasts = 1;
    job{1}.spm.stats.results.conspec.threshdesc = 'FWE'; 
    job{1}.spm.stats.results.conspec.thresh = 0.05;
    job{1}.spm.stats.results.conspec.extent = 0;
    job{1}.spm.stats.results.conspec.conjunction = 1;
    job{1}.spm.stats.results.conspec.mask.none = 1;
    job{1}.spm.stats.results.units = 2;
    job{1}.spm.stats.results.export{1}.ps = true;

    spm_jobman('run', job);

end


    