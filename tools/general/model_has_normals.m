function r = model_has_normals(model)
r = isfield(model,'nx') && ~isempty(model.nx);