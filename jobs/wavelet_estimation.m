% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/Users/greta/Documents/GitHub/EEG_MMN/jobs/wavelet_estimation_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'EEG');
spm_jobman('run', jobs, inputs{:});
