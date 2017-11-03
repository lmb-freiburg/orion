% In this version of this function we try to return a (NxNxN) cube, while still 
% keeping the aspect ratio

function [voxel_model] = pointcloud_to_voxels_3(model,N,bbox,voxelization_type,binaryMax)

if(isempty(model.x))
    warning('empty model passed to this function!');
    voxel_model = zeros([N N N]);
    
    return;
end

if(~exist('bbox','var'))
    bbox = [];
end

if(~exist('voxelization_type','var'))
    voxelization_type = 'binary';
end

if(~exist('binaryMax','var'))
    binaryMax = 1; %This is only for backward compatibilty. Otherwise it should be 255 to be compatible with 'intensity' type, in addition to other benefits!
end

[X,Y,Z] = model_to_components(model);

%--- Obtain the boundaries of the object, taking into account the bbox if
%needed
if(isempty(bbox))
    mX = min(X);
    MX = max(X);
    mY = min(Y);
    MY = max(Y);
    mZ = min(Z);
    MZ = max(Z);
else
    %-- in case of a bounding box, we only need to check the 4 corners
    x1 = bbox(1);
    y1 = bbox(2);
    z1 = bbox(3);
    w = bbox(4);
    h = bbox(5);
    d = bbox(6);
    x2 = x1+w;
    y2 = y1+h;
    z2 = z1+d;
    phi = bbox(7);

    cornersX = [x1 x1 x2 x2];
    cornersY = [y1 y2 y1 y2];
    xc = mean([x1,x2]);
    yc = mean([y1,y2]);
    
    % rotate the coordinates around the center
    cornersX = cornersX-repmat(xc,1,size(cornersX,2));
    cornersY = cornersY-repmat(yc,1,size(cornersX,2));
    rotated = [cosd(phi) -sind(phi); sind(phi) cosd(phi)]*[cornersX;cornersY];
    cornersX = rotated(1,:)+repmat(xc,1,size(cornersX,2));
    cornersY = rotated(2,:)+repmat(yc,1,size(cornersY,2));

    %-- now pick the limits of the corner coordinates
    mX = min(cornersX);
    MX = max(cornersX);
    mY = min(cornersY);
    MY = max(cornersY);
    mZ = min([z1,z2]); %z is interpreted differently, as the rotation is only around z
    MZ = max([z1,z2]);
    
end

maxmax = max([MX-mX,MY-mY,MZ-mZ]);
if(maxmax == 0) maxmax = 1; end %This happens only when there's a single point in the scene (the empty scene case has been taken care of before);


N1 = round(N*(MX-mX)/maxmax);
N2 = round(N*(MY-mY)/maxmax);
N3 = round(N*(MZ-mZ)/maxmax);

% This happens when the input point cloud is in in fact less than 3D 
if(~N1), N1 = 1;end;
if(~N2), N2 = 1;end;
if(~N3), N3 = 1;end;

voxel_model = zeros(N1,N2,N3);

ax = 1/(MX-mX)*(N1-1);
bx = -mX;
ay = 1/(MY-mY)*(N2-1);
by = -mY;
az = 1/(MZ-mZ)*(N3-1);
bz = -mZ;

% This happens when the input point cloud is in fact less than 3D 
if isnan(ax), ax = 0; end;
if isnan(ay), ay = 0; end;
if isnan(az), az = 0; end;

X2 = round(ax*(X+bx))+1;
Y2 = round(ay*(Y+by))+1;
Z2 = round(az*(Z+bz))+1;

switch(voxelization_type )
    case 'binary'
        voxel_model(sub2ind(size(voxel_model),X2,Y2,Z2)) = binaryMax ;
    case 'density'
        [C,ia,ic] = unique([X2,Y2,Z2],'rows');
        h = hist(ic,1:max(ic));
        ind = sub2ind(size(voxel_model),C(:,1),C(:,2),C(:,3));
        voxel_model(ind) = h;
        
        %max normalization
        voxel_model = voxel_model ./ max(voxel_model(:)) * 255;
    otherwise
        error('voxelization type not supported');
end

% Add the required symmetric zero padding to make it a cube
Nzx = floor( (N - N1)/2 );
Nzy = floor( (N - N2)/2 );
Nzz = floor( (N - N3)/2 );
final = zeros(N,N,N);
final(Nzx+1:Nzx+N1 , Nzy+1:Nzy+N2 ,Nzz+1:Nzz+N3) = voxel_model;
voxel_model = final;
