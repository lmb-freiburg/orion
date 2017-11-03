function [x,y,z,nx,ny,nz,r,g,b] = model_to_components(model)
x = model.x;
y = model.y;
z = model.z;

if(nargout > 3)
    nx = model.nx;
    ny = model.ny;
    nz = model.nz;
end

if(nargout > 6)
    r = model.r;
    g = model.g;
    b = model.b;
end
