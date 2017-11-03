function [h,h_normals] = visualize_model_and_normals(model,vector_scale,NS,point_size,color)

if(~exist('vector_scale','var'))
    vector_scale = 0;
end

if(~exist('NS','var'))
    NS = 1000;
end

if(~exist('point_size','var'))
    point_size = 20;
end

if(~exist('color','var'))
    color = 'black';
end

% Downsample the model to have a lighter version of it
N = length(model.x);

if(NS ~= 0)
    st = ceil(N/NS);
    model = downsample_model(model,st);
end

%--- display the model and the vectors
if(isfield(model,'r') && ~isempty(model.r))
    h = scatter3(model.x,model.y,model.z,point_size,[model.r ,model.g ,model.b ],'fill');

else
    h = scatter3(model.x,model.y,model.z,point_size,color,'fill');
end
    
if(vector_scale > 0)
    hold on;
    h_normals = quiver3(model.x,model.y,model.z,model.nx,model.ny,model.nz,vector_scale);
end


xlabel('x');
ylabel('y');
zlabel('z');