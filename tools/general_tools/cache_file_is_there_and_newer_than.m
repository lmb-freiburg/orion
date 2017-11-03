function r = cache_file_is_there_and_newer_than(cache_file,main_file)

r = false;
main_info = dir(main_file);
main_date = datenum(main_info.date);
cache_info = dir(cache_file);
if(~isempty(cache_info)) %if there is a cache file (and it is newer than the main file)
    cache_date = datenum(cache_info.date);
    if  cache_date>main_date
        r = true;
    end
end
