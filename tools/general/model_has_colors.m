function r = model_has_colors(model)
r = isfield(model,'r') && length(model.r) > 1;