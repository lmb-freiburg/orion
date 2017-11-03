function [x,y,z,nx,ny,nz,red,green,blue] = import_3D_model(FileName,prefer_mat_file)

if(~exist(FileName,'file'))
    error('Specified file does not exist:%s',FileName);
end

if(~exist('prefer_mat_file','var'))
    prefer_mat_file = 0;
end

[pathstr, name, ext] = fileparts(FileName);

if(strcmpi(ext,'.ply'))
    
    % check to see if there's a .mat file corresponding to the .ply file
    ply_info = dir(FileName);
    ply_date = datenum(ply_info.date);

    [pathstr, name, ext] = fileparts(FileName);
    mat_file = [pathstr, '/' ,name, '.mat'];
    mat_info = dir(mat_file);

    mat_file_is_there = 0;
    if(length(mat_info) ~= 0) %if there is a mat file (and it is newer than the ply file)
        mat_date = datenum(mat_info.date);
        if  mat_date>ply_date
            mat_file_is_there = 1;
        end
    end
    
    
    %now try to open the right file
    if(prefer_mat_file)
        if(mat_file_is_there)
            load(mat_file);
        else
            data = nplyRead(FileName);
            save([pathstr, '/' ,name, '.mat'],'data');
            msgbox('A .mat version of your .ply file is now saved in the same location. You can use that instead!','replace');
        end
    else
        data = nplyRead(FileName);
    end
    
elseif(strcmpi(ext,'.mat'))
    load(FileName);
else
    error('Invalid file extension');
end

x = data.vertex.x;
y = data.vertex.y;
z = data.vertex.z;
    
try
    nx = data.vertex.nx;
    ny = data.vertex.ny;
    nz = data.vertex.nz;
catch
    try
        nx = data.vertex.vsfm_cnx;
        ny = data.vertex.vsfm_cny;
        nz = data.vertex.vsfm_cnz;
    catch
        nx = [];
        ny = [];
        nz = [];
    end
end

try
    red = data.vertex.r/255;
    green = data.vertex.g/255;
    blue = data.vertex.b/255;
catch
    try
        red = data.vertex.red/255;
        green = data.vertex.green/255;
        blue = data.vertex.blue/255;
    catch
        try
            red = data.vertex.diffuse_red/255;
            green = data.vertex.diffuse_green/255;
            blue = data.vertex.diffuse_blue/255;
        catch
            red = .2;
            green = .2;
            blue = .2;
        end
    end
end

if(nargout == 1)
    model.x = x;
    model.y = y;
    model.z = z;
    model.nx = nx;
    model.ny = ny;
    model.nz = nz;
    model.r = red;
    model.g = green;
    model.b = blue;

    if(isfield(data,'face'))
        model.face = data.face;
    end
    
    x = model;
end
    