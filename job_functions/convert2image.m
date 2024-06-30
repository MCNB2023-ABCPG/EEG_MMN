function convert2image(image_file)

job{1}.spm.meeg.images.convert2images.D = {image_file};
job{1}.spm.meeg.images.convert2images.mode = 'scalp x time';
job{1}.spm.meeg.images.convert2images.conditions = {};
job{1}.spm.meeg.images.convert2images.channels{1}.type = 'EEG';
job{1}.spm.meeg.images.convert2images.timewin = [-Inf Inf];
job{1}.spm.meeg.images.convert2images.freqwin = [-Inf Inf];
job{1}.spm.meeg.images.convert2images.prefix = '';

spm_jobman('run', job);
end