img = imread('lena.bmp');

% Roberts 算子
Roberts = edge(img,"roberts");
% Sobel 算子
Sobel = edge(img,"sobel");
% Prewitt 算子
Prewitt = edge(img,"prewitt");
% 拉普拉斯算子
Laplacian1 = imfilter(img, fspecial("laplacian",0)); % 使用fspecial进行边缘检测
Laplacian2 = imfilter(img, [-1 -1 -1;-1 8 -1; -1 -1 -1]); % 边缘可视化
% Canny 算子
Canny = edge(img,"canny");

% 打印
subplot(3,3,2);
imshow(img);
title('lena.bmp');

subplot(3,3,4);
imshow(Roberts);
title('Roberts');

subplot(3,3,5);
imshow(Sobel);
title('Sobel');

subplot(3,3,6);
imshow(Prewitt);
title('Prewitt');

subplot(3,3,7);
imshow(Laplacian1);
title('Laplacian1');

subplot(3,3,8);
imshow(Laplacian2);
title('Laplacian2');

subplot(3,3,9);
imshow(Canny);
title('Canny');