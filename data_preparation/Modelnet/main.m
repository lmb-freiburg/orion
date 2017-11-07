addpath(genpath('polygon2voxel/'));
addpath(genpath('functions/'));

modelnet10_classes = {'bathtub','bed','chair','desk','dresser','monitor','night_stand','sofa','table','toilet'};
modelnet40_classes = {'airplane','bathtub','bed','bench','bookshelf','bottle','bowl','car',...
    'chair','cone','cup','curtain','desk','door','dresser','flower_pot','glass_box',...
    'guitar','keyboard','lamp','laptop','mantel','monitor','night_stand','person',...
    'piano','plant','radio','range_hood','sink','sofa','stairs','stool','table',...
    'tent','toilet','tv_stand','vase','wardrobe','xbox'};


%-------------------- Modelnet10 Data Preparation ---------------
%----------------------------------------------------------------
%----------------------------------------------------------------
off_path='../../datasets/ModelNet10';
mat_path='../../datasets/ModelNet10_voxelized_mat';
bin_path = '../../datasets/ModelNet10_bin_from_mat/';

%--- convert original .off to .mat files------
%----------------(voxel grids)----------------
%---------------------------------------------
volume_size = 24;
pad_size = 3;
angle_inc = 30;
modelnet_off2mat(off_path,mat_path,modelnet10_classes,volume_size,pad_size,angle_inc);

%---------------------------------------------
%---------- convert .mat to .bin files -------
%---------------------------------------------
D = 3; %padding on each side.
%We convert 30 to 36, such that after cropping we get 32, similar to what voxnet does
modelnet_mat2bin(D,mat_path,bin_path,modelnet10_classes);

%---------------------------------------------
%--------- convert bin to HDF5 chunks --------
%---------------------------------------------
Pose_plan='poseplan_MN10';
modelnet_binlist2hdf5(bin_path,Pose_plan);
%---------------------------------------------



%-------------------- Modelnet40 Data Preparation ---------------
%----------------------------------------------------------------
%----------------------------------------------------------------
off_path='../../datasets/ModelNet40';
mat_path='../../datasets/ModelNet40_voxelized_mat';
bin_path = '../../datasets/ModelNet40_bin_from_mat/';

%--- convert original .off to .mat files------
%----------------(voxel grids)----------------
%---------------------------------------------
volume_size = 24;
pad_size = 3;
angle_inc = 30;
modelnet_off2mat(off_path,mat_path,modelnet40_classes,volume_size,pad_size,angle_inc);

%---------------------------------------------
%---------- convert .mat to .bin files -------
%---------------------------------------------
D = 3; %padding on each side. 
%We convert 30 to 36, such that after cropping we get 32,similar to what voxnet does
modelnet_mat2bin(D,mat_path,bin_path,modelnet40_classes);

%---------------------------------------------
%--------- convert bin to HDF5 chunks --------
%---------------------------------------------
Pose_plan='poseplan_MN40';
modelnet_binlist2hdf5(bin_path,Pose_plan);
%---------------------------------------------
