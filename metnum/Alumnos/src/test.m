%% leo imagen de entrada
close all, clear all;
%I = imread('test.pgm');
%I = imread('camera.pgm');
I = imread('test.pgm');
figure,imshow(I),title('Imagen original');
%% agrego ruido uniforme 
sr = 100; % a partir de 64 (aprox) el filtrado vale la pena
IR = double(I) + randi([-sr,sr], size(I));
IR = uint8(IR);
figure,imshow(IR),title(['Imagen ruidosa. Interv=+-' num2str(sr)]);
%% filtro

%usamos lambda fijo = 1
lambda = 1; % mejor lambda=1
iters = 1;
IFS = IR;
%Esta parte hace el filtrado todas las veces sucesivas que se quiera
for i=1:iters
    %En la siguiente en particular se llama a la rutina que filtra
    IFS = varfilt(IFS,lambda);
end

fprintf('Lambda=%g\n',lambda);
fprintf('Iteraciones=%d\n',iters);
figure, imshow(IFS);
figure,imshow([I,IR,IFS]),title(['Imagen filtrada, lambda=' num2str(lambda) ' iters=' num2str(iters)]);

%% calculo psnr
% [p,m] = psnr(I, IR);
[p,m] = psnr(I(2:end-1,2:end-1), IR(2:end-1,2:end-1));

fprintf('Calidad imagen ruidosa.\n');
fprintf('PSNR=%g, ECM=%g\n',p,m);

% [p,m] = psnr(I, IF);
[p,m] = psnr(I(2:end-1,2:end-1), IFS(2:end-1,2:end-1));
fprintf('Calidad imagen filtrada.\n');
fprintf('PSNR=%g, ECM=%g\n',p,m);


%%

% Esta seccion de codigo es para ver los beneficios del filtrado. Si les
% interesa, consulten!
figure;
S1 = imfilter(I,fspecial('sobel'));
S2 = imfilter(IR,fspecial('sobel'));
S3 = imfilter(IFS,fspecial('sobel'));
imshow([S1,S2,S3]);