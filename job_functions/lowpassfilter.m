function lowpassfilter(data)

job{1}.spm.meeg.preproc.filter.D = {data};
job{1}.spm.meeg.preproc.filter.type = 'butterworth';
job{1}.spm.meeg.preproc.filter.band = 'low';
job{1}.spm.meeg.preproc.filter.freq = 30;
job{1}.spm.meeg.preproc.filter.dir = 'twopass';
job{1}.spm.meeg.preproc.filter.order = 5;
job{1}.spm.meeg.preproc.filter.prefix = 'f';
spm_jobman('run', job);
end
