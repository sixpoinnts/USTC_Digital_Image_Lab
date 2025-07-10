img1 = imread('Rect1.bmp');
img2 = imread('Rect2.bmp');

% Fourier 变换
F1 = fft2(img1);
F2 = fft2(img2);

% fftshift 把低频部分移动到图像中心
F1_shift = fftshift(F1);
F2_shift = fftshift(F2);

% abs 提取幅度信息
% log(... + 1) 增强对比度
F1_scale = log(abs(F1_shift+1));
F2_scale = log(abs(F2_shift+1));

% 显示原图像和频谱图(imshow(..., []) 自动调整显示比例)
subplot(2,2,1);
imshow(img1, []);
title('Rect1.bmp');

subplot(2,2,2);
imshow(F1_scale, []);
title('幅度变换图像');

subplot(2,2,3);
imshow(img2, []);
title('Rect2.bmp');

subplot(2,2,4);
imshow(F2_scale, []);
title('幅度变换图像');
