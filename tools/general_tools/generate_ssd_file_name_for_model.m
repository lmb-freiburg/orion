function ssd_file_name = generate_ssd_file_name_for_model(ply_file_name,OC_level)

if(exist('OC_level','var'))
    ssd_file_name = sprintf('%s.ssd%d.ply',ply_file_name ,OC_level);
else
    ssd_file_name = sprintf('%s.ssd.ply',ply_file_name);
end