function binlist_to_hdf5(bins_list,h5_filename,h5_text_filename,chunk_size,run_on_cluster,write_just_this_chunk)
%%%
%%% In this function we assume the list is formatted as '%s %d %d %d'
%%% where the first integer is ignored, the second is class label and the 
%%% 3rd one is the pose_label.
%%% We put the pose-label in the file, eventhough sometimes it's not used; It's safe -- tested!
%%%

%-- Load the list
[files,l1,l2,l3] = textread(bins_list,'%s %d %d %d');
N = numel(files);

if(~exist('chunk_size','var')), chunk_size = 10000;end
nchunks = ceil(N/chunk_size);

%-- Create the target dir(s) if needed
[pathstr,~,~] = fileparts(h5_filename);
system(['mkdir -p ' pathstr]);
[pathstr,~,~] = fileparts(h5_text_filename);
system(['mkdir -p ' pathstr]);

%-- See which chunks should we create
if(exist('write_just_this_chunk','var') && any(write_just_this_chunk))
    chunk_list = write_just_this_chunk;
else
    chunk_list = 1 : nchunks;
end

%--- create the text file containing names of files (only if we should!)
if(numel(chunk_list) == nchunks)
    create_the_text_file(h5_text_filename,h5_filename,nchunks)
end


%--- If we should submit jobs to cluster
if(exist('run_on_cluster','var') && run_on_cluster)
    
       
    for the_chunk = chunk_list
        cmd = sprintf(['matlabD -nosplash -r "run ~/startup.m; '...
            'binlist_to_hdf5(''%s'',''%s'',''%s'',%d,0,%d); '...
            'exit"'],bins_list,h5_filename,h5_text_filename,chunk_size,the_chunk);
        
	temp_job_dir= [ getenv('HOME') '/temp_cluster_job' ];
        [~,~,wait_file{the_chunk}] = cluster_submit_job('lmbtorque',cmd,temp_job_dir,6,'6G',0,'',3,0);
        pause(1);
    end

    return;
end
    
fprintf('Source: %s\nDestination1: %s\nDestination2: %s\n',bins_list,h5_filename,h5_text_filename);

%--- Load the first bin to obtain the dimensions
temp_v = load_binary_voxelgrid(files{1});
d1= size(temp_v,1);
d2= size(temp_v,2);
d3= size(temp_v,3);


if(~exist('write_just_this_chunk','var')), 
    write_just_this_chunk = 0;
end

for c = chunk_list
    fprintf('Chunk: %d/%d\n',c,nchunks);
    
    written_sofar = (c-1)*chunk_size;
    this_chunk_size = min(chunk_size,N-written_sofar);
    ind1 = written_sofar+1;
    ind2 = ind1+this_chunk_size-1;
    
    %--- Load bins one by one and keep in memory
    disp('Loading bin files...');
    Data = zeros(d1,d2,d3,1,this_chunk_size);
    tic
    for i = 1 : this_chunk_size %I have tried parfor here previously. It makes it slower!!
        data = load_binary_voxelgrid(files{ind1+i-1});
        Data(:,:,:,1,i) = data;
        if(~mod(i,50)), fprintf('%d ',i);end            
    end
    fprintf('\n');
    toc
    Data = uint8(Data);


    %-- Write the hdf5 file(s)
    disp('Writing the hdf5 file(s)...');
    
    %- get the appropriate filename for this chunk
    filename = get_chunk_filename(c,h5_filename);
    
    if(exist(filename,'file')),delete(filename);end

    h5create(filename,'/data',[d3 d2 d1 1 this_chunk_size],'Datatype','uint8');
    h5create(filename,'/label',[1 this_chunk_size]);
    h5create(filename,'/label_pose',[1 this_chunk_size])
    h5write(filename,'/data',Data);
    h5write(filename,'/label',l2(ind1:ind2)');
    h5write(filename,'/label_pose',l3(ind1:ind2)');

end
end

function filename = get_chunk_filename(chunk,h5_filename)
   if chunk == 1
       filename = h5_filename;
   else
       filename = sprintf('%s.%04d',h5_filename,chunk);
   end
end

function create_the_text_file(textfilename,h5filename,nchunks)
   fp = fopen(textfilename,'wt');
   for c = 1 : nchunks
       fprintf(fp,'%s\n',get_chunk_filename(c,h5filename));
   end
   fclose(fp);
end
