 average_job{1}.spm.meeg.preproc.crop.D = {average_power};
average_job{1}.spm.meeg.preproc.crop.timewin = [0 300];
average_job{1}.spm.meeg.preproc.crop.freqwin = [-Inf Inf];
average_job{1}.spm.meeg.preproc.crop.channels{1}.all = 'all';
average_job{1}.spm.meeg.preproc.crop.prefix = 'p';
average_job{2}.spm.meeg.preproc.crop.D = {average_power};
average_job{2}.spm.meeg.preproc.crop.timewin = [0 300];
average_job{2}.spm.meeg.preproc.crop.freqwin = [-Inf Inf];
average_job{2}.spm.meeg.preproc.crop.channels{1}.all = 'all';
average_job{2}.spm.meeg.preproc.crop.prefix = 'p';
average_job{3}.spm.meeg.averaging.average.D(1) = cfg_dep('Crop: Cropped M/EEG datafile', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
average_job{3}.spm.meeg.averaging.average.userobust.standard = false;
average_job{3}.spm.meeg.averaging.average.plv = true;
average_job{3}.spm.meeg.averaging.average.prefix = 'm';
average_job{4}.spm.meeg.averaging.average.D(1) = cfg_dep('Crop: Cropped M/EEG datafile', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
average_job{4}.spm.meeg.averaging.average.userobust.standard = false;
average_job{4}.spm.meeg.averaging.average.plv = false;
average_job{4}.spm.meeg.averaging.average.prefix = 'm';

%spm_jobman('run', average_job);