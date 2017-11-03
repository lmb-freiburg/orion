function [class_label,pose_label] = sydney_generate_class_and_pose_labels(class_name,rotation,old_style)
%%% Note:
%%% Class Label and Pose Label both start from 0.
%%%
%%% If the parameter "old_style" is given, then all the
%%% single-orientation classes will be labeled as rotation-class = 0

if(~exist('old_style','var')), old_style = 0; end;
    
classes =  {'4wd','building','bus','car','pedestrian','pillar','pole','traffic_lights','traffic_sign','tree','truck','trunk','ute','van'};

nrot = [18 9 9 18 1 1 1 9 18 1 18 1 18 18];
% nrot = [12 6 6 12 1 1 1 12 12 1 12 1 12 12];
if(old_style), nrot(nrot == 1) = 0; end;

%--- Find the Class Label
[valid_class,class_label] = ismember(class_name,classes);
if(~valid_class)
    class_label = -1;
    pose_label = -1;
    return;
end
class_label = class_label - 1;     %to start from 0
    
%--- Find the rotation label
cr = cumsum(nrot);
cr = circshift(cr,[0,1]);
cr(1) = 0;
pose_label = cr(class_label+1) + mod(rotation,nrot(class_label+1));

if(old_style)
    pose_label = pose_label+1;
    pose_label(nrot(class_label+1) == 0) = 0;
end
