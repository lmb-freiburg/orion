function X = find_intersections_of_a_set_of_lines_IGNORE_Z(P,V)

X = {};
for i = 1 : length(P)
    for j = i+1 : length(P)
        p1 = P{i}(1:2);
        v1 = V{i}(1:2);
        p2 = P{j}(1:2);
        v2 = V{j}(1:2);
        x = find_line_intersection(p1,v1,p2,v2);
        if(~isempty(x))
            X{end+1} = x;
        end
    end
end