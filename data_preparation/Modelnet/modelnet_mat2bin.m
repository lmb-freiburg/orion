function modelnet_mat2bin(D,SourceFolder,DestinationFolder,modelnet_classes)
%%% This function loads the files in the folders one by one, and saves the bin
%%% versions to a similar subdir in the destination (tries to create it).
%%% We go folder by folder, so that Matlab doesn't need to call the SLOW
%%% fileparts function to find the folder names


only_modelnet_classes = 1;

%--- Generate folders list
temp_folders_list_file = 'temp_modelnet_folders.txt';
disp('Generating folders list...');
if(~only_modelnet_classes)
    system(sprintf('find %s -mindepth 3 -type d > %s',SourceFolder,temp_folders_list_file));
else
    modelnet_forgrep = sprintf('%s\\|',modelnet_classes{:});
    modelnet_forgrep = modelnet_forgrep(1:end-2);
    system(sprintf('find %s -mindepth 3 -maxdepth 3 -type d | grep ''%s'' > %s',SourceFolder,modelnet_forgrep,temp_folders_list_file));
end

%--- Load the folders list
folders_list = textread(temp_folders_list_file,'%s');

%--- Loop on the folders
disp('Converting files...');
tic;
for d = 1 : numel(folders_list)
    d
    folder = folders_list{d};
    
    %--- Make the destination subfolder
    relative_folder = folder(length(SourceFolder)+2:end);
    cmd = sprintf('mkdir %s/classes/%s -p',DestinationFolder,relative_folder)
    system(cmd);
    
    %--- Get the list of files in each folder
    files_list = dir(sprintf('%s/*mat',folder));
    
    %--- Loop on file names
     parfor f = 1 : numel(files_list)

        filename = [files_list(f).name];
        fullfilename = [SourceFolder '/' relative_folder '/' filename];
        
        %- Load the Mat file
        v = load(fullfilename);
        v = v.instance;
        
        %-- padding
        avoxel = zeros(size(v)+2*D);
        avoxel(1+D:end-D,1+D:end-D,1+D:end-D) = v;
        v = avoxel;

        
        %- Generate the bin filename
        dest_filename = [DestinationFolder '/classes/' relative_folder '/' filename(1:end-3) 'bin'];
        
        %- Save the bin
        save_voxel_grid_as_bin(v,dest_filename);
        
    end
end
disp('Done');
toc

