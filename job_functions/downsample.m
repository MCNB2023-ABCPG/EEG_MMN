function downsample(data)

job{1}.spm.meeg.preproc.downsample.D = {data};
job{1}.spm.meeg.preproc.downsample.fsample_new = 200;
job{1}.spm.meeg.preproc.downsample.method = 'resample';
job{1}.spm.meeg.preproc.downsample.prefix = 'd';

spm_jobman('run', job);
end
