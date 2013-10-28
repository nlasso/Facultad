function [X] = householder(A,b)
%HOUSEHOLDER Summary of this function goes here
%   Detailed explanation goes here
R = A;
Q = eye(size(A));
for k=1:size(A)-1;
    
    x = b;
    for i=1:size(b);
        if (i>=k)
            x(i) = R(i,k);
        else x(i) = 0;
        end
    end

    y = b;
    y(k) = norm(x);
    for i=1:size(b);
        if(i~=k)
            y(i) = 0;
        end
    end
    a = x-y;
    u = (x - y);

    H = eye(size(A)) - (2/norm(a)^2)*((u)*(u'));
   
    Q = H*Q;
    R = H*R;

    
end
b1 = Q*b;
X = R\b1;

end

