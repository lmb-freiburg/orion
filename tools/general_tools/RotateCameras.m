function cameras = RotateCameras(cameras,R,T)

for i = 1 : length(cameras)
    cameras{i}.Position = R*cameras{i}.Position+T;
    cameras{i}.HeadingVector = R*cameras{i}.HeadingVector;
end