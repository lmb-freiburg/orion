% Inspired by: http://buntworthy.github.io/Read-VisualSFM-NVM-file/
function Cameras = load_camera_from_nvm(filename,do_sort)

if(~exist('do_sort','var')) 
    do_sort = 1; %by default we want sorting
end

fid = fopen(filename);
c = textscan(fid,'%s');

if strcmp(c{1}(2),'FixedK')
    offset = 9;
    numCameras = str2double(c{1}(8));
else
    offset = 3;
    numCameras = str2double(c{1}(2));
end

for i = 1:numCameras
    Cameras{i}.ImageFileName = c{1}{11*(i-1) + offset};
    Cameras{i}.FocalLength = str2double(c{1}(11*(i-1) + offset + 1));
    Cameras{i}.RQuaternation = str2double(c{1}(11*(i-1) + offset + 2:11*(i-1) + offset + 5));
    Cameras{i}.Position = str2double(c{1}(11*(i-1) + offset + 6:11*(i-1) + offset + 8));
    %Cameras{i}.distortion = str2double(c{1}(11*(i-1) + offset + 9));
end


if(do_sort)
    Cameras = sort_cameras(Cameras);
end