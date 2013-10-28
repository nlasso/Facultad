function [X] = jacobi(A,b,x0)
%JACOBI Summary of this function goes here
%   Detailed explanation goes here
    X = double(x0);
    s = 0.0;
    k = 0;
    A = double(A);
    b = double(b);
    while k < 30;
        temp = X;
        for i = 1:size(b)
            sum = dot(A(i,:),X) - A(i,i)*X(i);
            
            %for j = 1: size(A);
             %   if i ~= j
             %       s = s + A(i,j) * temp(j);
             %   end        
            %end
            X(i) = (b(i) - sum) / A(i,i);
            %s = 0;
        end
        k = k + 1;
    end
end

