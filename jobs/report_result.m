% List of open inputs
% Results Report: Contrast(s) - cfg_entry
nrun = X; % enter the number of runs here
jobfile = {'/Users/angelaseo/Desktop/GitHub/EEG_MMN/jobs/report_result_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(1, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Results Report: Contrast(s) - cfg_entry
end
spm('defaults', 'EEG');
spm_jobman('run', jobs, inputs{:});
