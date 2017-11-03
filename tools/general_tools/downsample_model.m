function new_model = downsample_model(model,st)

new_model.x = model.x(1:st:end);
new_model.y = model.y(1:st:end);
new_model.z = model.z(1:st:end);
if(isfield(model,'nx'))
    new_model.nx = model.nx(1:st:end);
    new_model.ny = model.ny(1:st:end);
    new_model.nz = model.nz(1:st:end);
end
if(isfield(model,'r'))
    new_model.r = model.r(1:st:end);
    new_model.g = model.g(1:st:end);
    new_model.b = model.b(1:st:end);
end
