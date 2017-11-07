function modelnet_add_labels_to_list(source_list_file,dest_list_file,rotation_start_index,all_singlerots_to_zero,Pose_file)

list = textread(source_list_file,'%s');
Pose=importdata(Pose_file,'\t');
%parfor
parfor i = 1 : numel(list)
    [class_name,rotation] = modelnet_extract_classname_and_rot_from_filename(list{i});
    [class_label,pose_label] = modelnet_generate_class_and_pose_labels(class_name,rotation-rotation_start_index,all_singlerots_to_zero,Pose);
    list{i} = sprintf('%s %d %d %d' ,list{i},1,class_label,pose_label);
end

%--- write the modified list to the destination file
fp = fopen(dest_list_file,'wt');
fprintf(fp,'%s\n',list{:});
fclose(fp);
