function model3d = components_to_model(x,y,z,nx,ny,nz,r,g,b)

if(nargin == 1)
    y = x(:,2);
    z = x(:,3);
    if(size(x,2) > 3)
        nx = x(:,4);
        ny = x(:,5);
        nz = x(:,6);
    end
    x = x(:,1);
end

model3d.x = x;
model3d.y = y;
model3d.z = z;

if(nargin > 3)
    model3d.nx = nx;
    model3d.ny = ny;
    model3d.nz = nz;
end

if(nargin > 6)
    model3d.r = r;
    model3d.g = g;
    model3d.b = b;
end
    