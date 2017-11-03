function X = find_line_intersection(P1,V1,P2,V2)

if(length(P1) ~= 2)
    error('This function only works in 2D');
end    

A = [V1(1),-V2(1) ; V1(2) -V2(2)];
B = P2-P1;
if(det(A) == 0)
    X = [];
    return;
end

K = inv(A)*B;

X = P1 + K(1)*V1;
