function export_3D_model(model,FileName,psz,should_diffuse)

if(isempty(model))
    disp('Error: export_3D_model: Can not write empty data to a file. Skipping.');
    return;
end

if(~exist('psz','var'))
    psz = [];
end

if(~exist('should_diffuse','var'))
    should_diffuse = 0;
end

data.vertex.x = model.x;
data.vertex.y = model.y;
data.vertex.z = model.z;

data.vertex.nx = model.nx;
data.vertex.ny = model.ny;
data.vertex.nz = model.nz;

if(model_has_colors(model))
    if(should_diffuse)
        data.vertex.diffuse_red = model.r*255;
        data.vertex.diffuse_green = model.g*255;
        data.vertex.diffuse_blue = model.b*255;
    else
        data.vertex.red = model.r*255;
        data.vertex.green = model.g*255;
        data.vertex.blue = model.b*255;
    end
end

if(~isempty(psz))
    data.vertex.psz = 0.1*ones(length(model.x),1);
end

if(isfield(model,'face'))
    data.face = model.face;
end

[pathstr, name, ext] = fileparts(FileName);

if(strcmpi(ext,'.ply'))
    nplyWrite(FileName,data);
elseif(strcmpi(ext,'.mat'))
    save(FileName,'data');
else
    error('export_3D_model: Invalid file extension');
end


