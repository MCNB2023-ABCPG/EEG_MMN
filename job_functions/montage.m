function montage(converted_data, montage_file)
job = [];
job{1}.spm.meeg.preproc.montage.D = {converted_data};
job{1}.spm.meeg.preproc.montage.mode.write.montspec.montage.montagefile = {montage_file};
job{1}.spm.meeg.preproc.montage.mode.write.montspec.montage.keepothers = 0;
job{1}.spm.meeg.preproc.montage.mode.write.blocksize = 655360;
job{1}.spm.meeg.preproc.montage.mode.write.prefix = 'M';

spm_jobman('run', job);
end
