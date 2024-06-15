function epoch(data, trlfile)

job{1}.spm.meeg.preproc.epoch.D = {data};
job{1}.spm.meeg.preproc.epoch.trialchoice.trlfile = {trlfile};
job{1}.spm.meeg.preproc.epoch.bc = 1;
job{1}.spm.meeg.preproc.epoch.eventpadding = 0;
job{1}.spm.meeg.preproc.epoch.prefix = 'e';

spm_jobman('run', job);
end
