function new_model = rotate_3D_model_around_z(model,phi)

r = [cosd(phi) -sind(phi) 0 ; sind(phi) cosd(phi) 0 ; 0 0 1];
new_model = transform_3d_rigid(model,r,[0;0;0]);

end

