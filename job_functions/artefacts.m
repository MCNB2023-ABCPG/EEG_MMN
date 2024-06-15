function artefacts(data)

job{1}.spm.meeg.preproc.artefact.D = {data};
job{1}.spm.meeg.preproc.artefact.mode = 'reject';
job{1}.spm.meeg.preproc.artefact.badchanthresh = 0.2;
job{1}.spm.meeg.preproc.artefact.append = true;
job{1}.spm.meeg.preproc.artefact.methods.channels{1}.all = 'all';
job{1}.spm.meeg.preproc.artefact.methods.fun.threshchan.threshold = 80;
job{1}.spm.meeg.preproc.artefact.methods.fun.threshchan.excwin = 1000;
job{1}.spm.meeg.preproc.artefact.prefix = 'a';

spm_jobman('run', job);
end
