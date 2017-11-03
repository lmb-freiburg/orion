function [frame_file_names,view_points] = find_frame_file_names_and_viewpoints(cameras,R,T,azimuth_correction)

for i = 1 : numel(cameras)
    C = cameras{i}.Position;
    C = R*C+T;

    view_points(i,:) = atan2(C(2),C(1))*180/pi +  azimuth_correction; % (i,:) is used only to make it a column vector
    frame_file_names(i,:) = {cameras{i}.ImageFileName}';
    
end

view_points(view_points < 0) = view_points(view_points < 0)+360;
view_points(view_points > 360) = view_points(view_points > 360)-360;
