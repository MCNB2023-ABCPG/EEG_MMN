function averaging(data)

job{1}.spm.meeg.averaging.average.D = {data};
job{1}.spm.meeg.averaging.average.userobust.robust.ks = 3;
job{1}.spm.meeg.averaging.average.userobust.robust.bycondition = true;
job{1}.spm.meeg.averaging.average.userobust.robust.savew = false;
job{1}.spm.meeg.averaging.average.userobust.robust.removebad = false;
job{1}.spm.meeg.averaging.average.plv = false;
job{1}.spm.meeg.averaging.average.prefix = 'm';

spm_jobman('run', job);
