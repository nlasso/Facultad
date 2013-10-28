%% Intro a imagenes
I = imread('lena.pgm');
imshow(I);
I(1:10,1:10)
figure;
imshow(I(1:10,1:10));


%% Todo es una imagen
figure;
imagesc(rand(16));

figure;
imshow(repmat(I(1:3:size(I,1),1:3:size(I,2)),3,3));

%% Las procesamos como matrices comunes

I2 = imread('../Senales/256x256/barbara.pgm');
figure;
% Que hace lo siguiente?
imshow(I+I2);

%% Generando ruido

IR = double(I) + randi([-50,50], size(I));
IR = uint8(IR);
figure;
% Que tipo de imagen queda?
imshow(IR);

%% Ruidos de Matlab
figure;
imshow(imnoise(I,'gaussian'))
figure;
imshow(imnoise(I,'salt & pepper'))




