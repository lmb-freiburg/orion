function [Cameras, nCameras] = load_camera_v2(FileName,do_sort)

if(~exist('do_sort','var')) 
    do_sort = 1; %by default we want sorting
end

fp = fopen(FileName);
if(fp == -1)
    error(['Could not open the file: ' FileName]);
    return;
end

for i = 1:16, 
    fgets(fp);
end; %skip the header

nCameras = fscanf(fp,'%d',1);

for i = 1 : nCameras
  fgets(fp); %this is needed!
  fgets(fp); %skip the empty line
  fgets(fp); %skip the non-useful filename

  Cameras{i}.ImageFileName = fgetl(fp);
  Cameras{i}.FocalLength = fscanf(fp,'%f',1);
  Cameras{i}.PrincipalPoint = fscanf(fp,'%d',2);
  Cameras{i}.T = fscanf(fp,'%f',3);
  Cameras{i}.Position = fscanf(fp,'%f',3);
  Cameras{i}.RByAxisAngle = fscanf(fp,'%f',3);
  Cameras{i}.RQuaternation = fscanf(fp,'%f',4);

  R = fscanf(fp,'%f',9);
  Cameras{i}.R = reshape(R,3,3)';
  Cameras{i}.NormRadialDistortion = fscanf(fp,'%f',1);
  Cameras{i}.EXIFPos = fscanf(fp,'%f',3);
  
  C = Cameras{i}.Position;
  R = Cameras{i}.R;
  T = Cameras{i}.T;
  f = Cameras{i}.FocalLength;
  K = [f 0 0 ; 0 f 0; 0 0 1];
  heading_point = inv(R) * (inv(K)*[0;0;1] - T);
  heading_vector = heading_point-C;
  heading_vector = heading_vector / norm(heading_vector);
  Cameras{i}.HeadingVector = heading_vector;
  
end

fclose(fp);

if(do_sort)
    Cameras = sort_cameras(Cameras);
end
