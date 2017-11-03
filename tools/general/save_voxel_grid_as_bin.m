function save_voxel_grid_as_bin(voxel,filename)

fp = fopen(filename,'w');
fwrite(fp,uint16(size(voxel)),'uint16');
fwrite(fp,uint8(voxel),'uint8');
fclose(fp);