function perm = shuffle_text_file(filename,dest_file,perm)

the_lines = fileread(filename);
the_lines = regexp(the_lines,'(.*?)\n','tokens');

if(~exist('perm','var'))
    perm = randperm(length(the_lines));
end

dest_lines = the_lines(perm);

fp = fopen(dest_file,'wt');
for i = 1 : length(dest_lines)
    fprintf(fp,'%s\n',dest_lines{i}{1});
end
fclose(fp);

