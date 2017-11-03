function prepare_sydney_lists(orig_folds_folder,bins_list,destination_path)
%note that original fold files should be modified to have file names without the '.bin' extension

%--- Create the dest dir
if(exist(destination_path,'dir'))
    error('Destination folder (%s) already exists! You probably don''t want to overwrite it.',destination_path);
else
    mkdir(destination_path);
end

%--- create the single fold lists
parfor f = 0:3
    orig_fold_name = sprintf('%s/fold%d.txt',orig_folds_folder,f);
    
    dest_filename = sprintf('%s/fold%d_allrot.txt',destination_path,f);
    system(sprintf('grep -f %s %s > %s',orig_fold_name,bins_list,dest_filename));

    dest_filename = sprintf('%s/fold%d_firstrot.txt',destination_path,f);
    system(sprintf('printf "" > %s',dest_filename));
    system(sprintf('for f in `cat %s`; do grep $f %s -m 1  >> %s ; done',orig_fold_name,bins_list,dest_filename));

    dest_filename = sprintf('%s/fold%d_singlerandrot.txt',destination_path,f);
    system(sprintf('printf "" > %s',dest_filename));
    system(sprintf('for f in `cat %s`; do grep $f %s | sort --random-sort | head -n 1  >> %s ; done',orig_fold_name,bins_list,dest_filename));

end

%--- create merged lists
suffixes = {'allrot','firstrot','singlerandrot'};
for is = 1 : numel(suffixes)
    suffix = suffixes{is};
    C = combnk(0:3,3);
    for ic = 1 : size(C,1)
        c = C(ic,:);
        dest_filename = sprintf('%s/folds%d%d%d_%s.txt',destination_path,c,suffix);
        system(sprintf('rm %s',dest_filename));
        for f = c
            fold_name = sprintf('%s/fold%d_%s.txt',destination_path,f,suffix);
            cmd = sprintf('cat %s >> %s',fold_name,dest_filename);
            system(cmd);
        end
    end
end

%--- create shuffled versions
shuffle_dest = [destination_path '/shuffled'];
system(sprintf('mkdir -p %s',shuffle_dest));

d = dir([destination_path '/*.txt']); %get a list of all list files
for i = 1 : numel(d)
    source = [destination_path '/' d(i).name];
    dest = [shuffle_dest '/' d(i).name];
    dest_perm = [dest '.perm'];
    
    perm = shuffle_text_file(source,dest);
    
    %save the permutations for later use
    fp = fopen(dest_perm,'wt');
    fprintf(fp,'%d\n',perm);
    fclose(fp);
end
