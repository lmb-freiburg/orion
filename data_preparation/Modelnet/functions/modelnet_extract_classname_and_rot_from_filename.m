function [class_name,rotation] = modelnet_extract_classname_and_rot_from_filename(filename)

s = strsplit(filename,{'.','/'});
class_name = s{end-4};
r = strsplit(s{end-1},'_');
rotation = str2double(r(end));
