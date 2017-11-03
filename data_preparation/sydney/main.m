function main
 
%-- Settings
rotation_randomization = 0;
nRotations = 18;
voxelization_type =  'binary';%or 'density'
binaryMax = 1;
basic_dimension = 28; %The final size is this + 2*D
D = 4; %Padding
output_type = 'bin'; %or 'mat'
aligned = 'aligned'; %or 'nonaligned'
rotation_start_index = 0;
collate_singlerots = 0;
current_dir = [pwd '/'];
destination_basepath = [current_dir '../../datasets/Sydney/bin-28-36'];

%--- Add necessary paths
addpath('../../tools/general/');
addpath('../../tools/nply/');

%--- Generate a list of ply files
switch(aligned)
      case 'aligned',
	ply_folder = [current_dir '../../datasets/Sydney/sydney_ply_aligned'];
      otherwise,
	ply_folder = [current_dir '../../datasets/Sydney/sydney_ply'];
end
	
sourcelist = create_ply_list(ply_folder);


%--- Generate an informative name for the destination path
if(strcmp(voxelization_type,'binary'))
    destination_path = sprintf('%s/%s_rot%d_rand%d_%s%d',destination_basepath,aligned,nRotations,rotation_randomization,voxelization_type,binaryMax);
else
    destination_path = sprintf('%s/%s_rot%d_rand%d_%s',destination_basepath,aligned,nRotations,rotation_randomization,voxelization_type);
end

if(collate_singlerots)
    destination_path = [destination_path '_collatesingles'];
end

%--- Create the dest dir
if(exist(destination_path,'dir'))
    error('Destination folder already exists! You probably don''t want to overwrite it:\n%s',destination_path);
else
    mkdir(destination_path);
end

%------------------------------------- Main loop on files
list = textread(sourcelist,'%s');
parfor i = 1 : numel(list)
    i
    %-- Load the model
    model = import_3D_model(list{i});
    
    [pathstr,base_name,ext] = fileparts(list{i});
    
    
    %--- Loop on rotations
    for r = 0:nRotations-1
        rotation = r*360/nRotations;
        
        if(rotation_randomization)
            R = 360/nRotations * 0.80; %we consider a margin
            rotation = rotation +rand()*R-R/2;
        end
        
        rmodel = rotate_3D_model_around_z(model,rotation);

        %-- Convert to voxel
        voxel = pointcloud_to_voxels_3(rmodel,basic_dimension,[],voxelization_type,binaryMax);

        avoxel = zeros(size(voxel)+2*D);
        avoxel(1+D:end-D,1+D:end-D,1+D:end-D) = voxel;
            
        %-- Save the voxel grid
        switch(output_type)
            case 'mat'
                saver(avoxel,destination_path,base_name,i,r+rotation_start_index);
            case 'bin'
                binary_saver(avoxel,destination_path,base_name,i,r+rotation_start_index);
        end
        
    end
end

%-- save the environment variables for future reference
save(sprintf('%s/settings.mat',destination_path));

%-- Create the list.txt and put it into the destination
alllist_file = sprintf('%s/all.txt',destination_path);
system(sprintf('find %s -iname ''*.%s'' | sort -V > %s', destination_path,output_type,alllist_file));
sydney_add_labels_to_list(alllist_file,alllist_file,rotation_start_index,collate_singlerots);

%--- generate the lists based on various folds
orig_folds_folder = [current_dir '../../datasets/Sydney/original/sydney-urban-objects-dataset/folds'];
our_folds_folder = [current_dir '../../datasets/Sydney/folds'];
patch_fold_files(orig_folds_folder,our_folds_folder);
lists_dir = sprintf('%s/lists',destination_path);
prepare_sydney_lists(our_folds_folder,alllist_file,lists_dir);


%=============================== Some auxiliary functions
function list_file = create_ply_list(folder)
  list_file = './ply_list.txt';
  system(sprintf('find %s/*.ply | sort -V > %s',folder,list_file));

function patch_fold_files(orig_folder,dest_folder)
  system(sprintf('mkdir %s && cp %s/*.txt %s',dest_folder,orig_folder,dest_folder));
  system(sprintf('sed -i ''s#\\.bin##'' %s/*txt',dest_folder));

function saver(voxel,destination_path,base_name,i,r)
  dest_filename = sprintf('%s/%s_r%02d.mat',destination_path,base_name,r);
  save(dest_filename,'voxel');

function binary_saver(voxel,destination_path,base_name,i,r)
  dest_filename = sprintf('%s/%s_r%02d.bin',destination_path,base_name,r);
  save_voxel_grid_as_bin(voxel,dest_filename);
