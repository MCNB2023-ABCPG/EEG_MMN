spm('defaults', 'eeg');

S = [];
dataset_name = 'subject1.bdf';
dataset = fullfile(folder_path_pre, dataset_name);
S.dataset = dataset;
file_name = 'spmeeg_subject1';
output_file = fullfile(folder_path_pre, file_name);
S.outfile = output_file;
S.channels = 'all';
S.timewin = [];
S.blocksize = 3276800;
S.checkboundary = 1;
S.eventpadding = 0;
S.saveorigheader = 0;
S.conditionlabels = {'Undefined'};
S.inputformat = [];
S.chanindx = [];
S.mode = 'continuous';
D = spm_eeg_convert(S);


