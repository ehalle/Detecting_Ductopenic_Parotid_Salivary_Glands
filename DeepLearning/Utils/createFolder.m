function createFolder(name)
    if ~exist(name, 'dir')
        mkdir(name);
    end
end