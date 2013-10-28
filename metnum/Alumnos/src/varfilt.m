function img_out = varfilt(img_in,Lambda)
% Variational filter for image img_in
% Lambda: weighing factor

% Armado de todo el sistema de ecuaciones para el filtrado
Dim = size(img_in);
NInc = prod(Dim);

Utilde = Lambda*double(img_in(:));

B = [[-1*ones(NInc-Dim(1),1);zeros(Dim(1),1)] [-1*ones(NInc-1,1);0] ...
    (Lambda + 4)*ones(NInc,1) [0;-1*ones(NInc-1,1)] [zeros(Dim(1),1);-1*ones(NInc-Dim(1),1)]];
d = [-Dim(1) -1 0 1 Dim(1)];
K2 = spdiags(B,d,NInc,NInc);

iBound = [[ones(1,Dim(2));1:Dim(2)] [Dim(1)*ones(1,Dim(2));1:Dim(2)] ...
    [2:Dim(1)-1;ones(1,Dim(1)-2)] [2:Dim(1)-1;Dim(2)*ones(1,Dim(1)-2)]];

icount = iBound(1,:) + Dim(1)*(iBound(2,:)-1);

K2(icount,:) = 0;
K2(icount,icount) = diag(ones(length(icount),1));

% A partir de aca el sistema esta armado en la variable K2 y la imagen
% ruidosa esta en Utilde



% Aca se debe resolver el sistema para obtener la aproximacion de la imagen
% original


% Resolucion por \
Usol = K2\Utilde;
x0 = rand(size(K2),1);
% Resolucion por QR
UQR = householder(K2,Utilde);

% Resolucion por Jacobi
%UJacobi = jacobi(K2,Utilde,x0);

% Resolucion por Gauss-Seidel
%UGS = gausssei(K2,Utilde,x0);


% Incluir codigo para chequear la similitud de las soluciones


% Codigo para ecualizar la solucion
%UJacobi = UJacobi - min(UJacobi);
%UJacobi = UJacobi / max(UJacobi);
%UJacobi = uint8(UJacobi*255);
%img_out = reshape(UJacobi,Dim);

UQR = UQR - min(UQR);
UQR = UQR / max(UQR);
UQR = uint8(UQR*255);
img_out = reshape(UQR,Dim);

%UGS = UGS - min(UGS);
%UGS = UGS / max(UGS);
%UGS = uint8(UGS*255);
%img_out = reshape(UGS,Dim);
end
