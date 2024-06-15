function prepare(data, eegsens)
job = [];
job{1}.spm.meeg.preproc.prepare.D = {data};
job{1}.spm.meeg.preproc.prepare.task{1}.loadeegsens.eegsens = {eegsens};
job{1}.spm.meeg.preproc.prepare.task{1}.loadeegsens.megmatch.nomatch = 1;

spm_jobman('run', job);
end