function [class_name,rotation] = sydney_extract_classname_and_rot_from_filename(filename)

s = strsplit(filename,{'.','/'});
class_name = s{end-3};
rotation = str2double(s{end-1}(end-1:end));