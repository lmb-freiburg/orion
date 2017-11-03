function sydney_add_labels_to_list(source_list_file,dest_list_file,rotation_start_index,all_singlerots_to_zero)

list = textread(source_list_file,'%s');
parfor i = 1 : numel(list)
    [class_name,rotation] = sydney_extract_classname_and_rot_from_filename(list{i});
    [class_label,pose_label] = sydney_generate_class_and_pose_labels(class_name,rotation-rotation_start_index,all_singlerots_to_zero);
    list{i} = sprintf('%s %d %d %d' ,list{i},1,class_label,pose_label);
end

%--- write the modified list to the destination file
fp = fopen(dest_list_file,'wt');
fprintf(fp,'%s\n',list{:});
fclose(fp);