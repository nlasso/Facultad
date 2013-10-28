function [X] = gausssei(A,b,x0)
%GAUSSSEI Summary of this function goes here
%   Detailed explanation goes here
    A = double(A);
    b = double(b);
    x0= double(x0);
    L = tril(A,-1);
    U = triu(A,1);
    U = U*(-1); 
    D = diag(diag(A));
    L = L * (-1);
    c = inv(D-L)*b;
    T = inv(D-L)*U;
    k = 0;
    X = x0
    while k < 30;
        X = T*X + c;
        k = k+1;
    end
end

