function modelnet_binlist2hdf5(DestinationFolder,Pose_plan)

Pose_file=['../poseplans/' Pose_plan '.txt'];
if ~exist(strcat(DestinationFolder,Pose_plan,'/'), 'dir')
    mkdir(strcat(DestinationFolder,Pose_plan,'/'));
end
copyfile(Pose_file,strcat(DestinationFolder,Pose_plan,'/'));

%% ---- Create the lists
rotation_start_index = 1; %this is the original Shapenet convention
collate_singlerots = 0; %it has no effect for modelnet10 , with the current poseplan
alllist_file = sprintf('%s/%s/all.txt',DestinationFolder,Pose_plan);
system(sprintf('find %s -iname ''*.%s'' | sort -V > %s', DestinationFolder,'bin',alllist_file));
modelnet_add_labels_to_list(alllist_file,alllist_file,rotation_start_index,collate_singlerots,Pose_file);

lists_dir = sprintf('%s/%s/lists',DestinationFolder,Pose_plan);
prepare_modelnet_lists(alllist_file,lists_dir,rotation_start_index);

%% --- Create some special HDF5 datasets
binlist_to_hdf5([lists_dir '/shuffled/train_allrot.txt'],[DestinationFolder '/' Pose_plan '/hdf5/train_allrot_shuffled/train.hdf5'],[DestinationFolder '/' Pose_plan '/hdf5/train_allrot_shuffled/train.hdf5.txt'],1000);
binlist_to_hdf5([lists_dir '/test_singlerandrot.txt'],[DestinationFolder '/' Pose_plan '/hdf5/test_singlerandrot/test.hdf5'],[DestinationFolder '/' Pose_plan '/hdf5/test_singlerandrot/test.hdf5.txt'],1000);
binlist_to_hdf5([lists_dir '/test_allrot.txt'],[DestinationFolder '/' Pose_plan '/hdf5/test_allrot/test.hdf5'],[DestinationFolder '/' Pose_plan '/hdf5/test_allrot/test.hdf5.txt'],1000);
