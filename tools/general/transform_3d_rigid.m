function model3d_new = transform_3d_rigid(model3d,R,T)

if(model_has_normals(model3d))
    [x,y,z,nx,ny,nz] = model_to_components(model3d);
else
    [x,y,z] = model_to_components(model3d);
end
    
xyz = [x y z];
xyz = xyz * R';
xyz  = xyz + repmat(T',length(x),1);

if(model_has_normals(model3d))
    nxyz = [nx ny nz] * R';
    model3d_new = components_to_model(xyz(:,1),xyz(:,2),xyz(:,3),nxyz(:,1),nxyz(:,2),nxyz(:,3));
else
    model3d_new = components_to_model(xyz(:,1),xyz(:,2),xyz(:,3),[],[],[]);
end


if(model_has_colors(model3d))
    model3d_new.r = model3d.r;
    model3d_new.g = model3d.g;
    model3d_new.b = model3d.b;
end

if(model_has_faces(model3d))
    model3d_new.face = model3d.face;
end