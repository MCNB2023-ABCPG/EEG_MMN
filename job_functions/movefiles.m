function movefiles(files, target)

for i = 1:numel(files)
    movefile(files{i}, target)

end