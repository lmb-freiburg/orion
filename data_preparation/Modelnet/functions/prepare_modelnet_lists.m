function prepare_modelnet_lists(all_list,destination_path,first_rot_index)

%--- Create the dest dir
if(exist(destination_path,'dir'))
    error('Destination folder (%s) already exists! You probably don''t want to overwrite it.',destination_path);
else
    mkdir(destination_path);
end

%--- create the main lists
for set = {'train','test'}
    dest_filename = sprintf('%s/%s_allrot.txt',destination_path,set{1}); %again, set{1} does not mean only 'train', it's a for loop!
    system(sprintf('grep ''/%s/'' %s > %s',set{1},all_list,dest_filename));


    dest_filename = sprintf('%s/%s_firstrot.txt',destination_path,set{1});
    system(sprintf('printf "" > %s',dest_filename));

    system(sprintf('grep ''/%s/'' %s | grep "_%d.bin" > %s',set{1},all_list,first_rot_index,dest_filename));

    %if(set{1} == 'test')
    dest_filename = sprintf('%s/%s_singlerandrot.txt',destination_path,set{1});
    system(sprintf('printf "" > %s',dest_filename));

    system(sprintf('grep ''/%s/'' %s | sed ''s|\\_[0-9]\\+\\.bin.*$||'' | uniq > .temp_unique_list',set{1},all_list));

    system(sprintf('for f in `cat .temp_unique_list`; do grep $f %s | sort --random-sort | head -n 1  >> %s ; done',all_list,dest_filename));

    system('rm .temp_unique_list');

    %end
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
