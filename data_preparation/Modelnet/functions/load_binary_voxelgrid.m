function v = load_binary_voxelgrid(filename)

fp = fopen(filename,'rb');
sz = fread(fp,3,'uint16');
v = zeros(sz');
v(:) = fread(fp,prod(sz),'uint8');
fclose(fp);