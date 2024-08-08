%-----------------------------------------------------------------------
% Job saved on 05-Jul-2024 19:10:05 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.meeg.preproc.crop.D = {'/Users/greta/Documents/GitHub/EEG_MMN/DATA/SUB1/STATS/tf_spmeeg_subject1.mat'};
matlabbatch{1}.spm.meeg.preproc.crop.timewin = [-100 800];
matlabbatch{1}.spm.meeg.preproc.crop.freqwin = [-Inf Inf];
matlabbatch{1}.spm.meeg.preproc.crop.channels{1}.all = 'all';
matlabbatch{1}.spm.meeg.preproc.crop.prefix = 'p';
matlabbatch{2}.spm.meeg.preproc.crop.D = {'/Users/greta/Documents/GitHub/EEG_MMN/DATA/SUB1/STATS/tf_spmeeg_subject1.mat'};
matlabbatch{2}.spm.meeg.preproc.crop.timewin = [-100 800];
matlabbatch{2}.spm.meeg.preproc.crop.freqwin = [-Inf Inf];
matlabbatch{2}.spm.meeg.preproc.crop.channels{1}.all = 'all';
matlabbatch{2}.spm.meeg.preproc.crop.prefix = 'p';
matlabbatch{3}.spm.meeg.averaging.average.D(1) = cfg_dep('Crop: Cropped M/EEG datafile', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{3}.spm.meeg.averaging.average.userobust.standard = false;
matlabbatch{3}.spm.meeg.averaging.average.plv = true;
matlabbatch{3}.spm.meeg.averaging.average.prefix = 'm';
matlabbatch{4}.spm.meeg.averaging.average.D(1) = cfg_dep('Crop: Cropped M/EEG datafile', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{4}.spm.meeg.averaging.average.userobust.standard = false;
matlabbatch{4}.spm.meeg.averaging.average.plv = false;
matlabbatch{4}.spm.meeg.averaging.average.prefix = 'm';
