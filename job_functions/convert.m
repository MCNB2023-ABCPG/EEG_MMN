function convert(dataset, chanfile)
job = [];
job{1}.spm.meeg.convert.dataset = {dataset};
job{1}.spm.meeg.convert.mode.continuous.readall = 1;
job{1}.spm.meeg.convert.channels{1}.chanfile = {chanfile};
job{1}.spm.meeg.convert.outfile = '';
job{1}.spm.meeg.convert.eventpadding = 0;
job{1}.spm.meeg.convert.blocksize = 3276800;
job{1}.spm.meeg.convert.checkboundary = 1;
job{1}.spm.meeg.convert.saveorigheader = 0;
job{1}.spm.meeg.convert.inputformat = 'autodetect';

spm_jobman('run', job);
end
