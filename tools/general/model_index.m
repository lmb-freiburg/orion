function new_model = model_index(model,index)

new_model = make_empty_3D_model();

new_model.x = model.x(index);
new_model.y = model.y(index);
new_model.z = model.z(index);

if(model_has_normals(model))
    new_model.nx = model.nx(index);
    new_model.ny = model.ny(index);
    new_model.nz = model.nz(index);
end
if(model_has_colors(model))
    new_model.r = model.r(index);
    new_model.g = model.g(index);
    new_model.b = model.b(index);
end
if(model_has_faces(model))
    if(islogical(index))
        index = find(index);
    end
    new_model.face = keep_valid_faces(model.face,index);
end