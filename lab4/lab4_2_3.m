img1 = imread('Rect1.bmp');
img2 = imread('Rect2.bmp');

% Fourier 变换
F1 = fft2(img1);
F2 = fft2(img2);

% 取幅度进行逆变换
IF1 = uint8(ifft2(abs(F1)));
IF2 = uint8(ifft2(abs(F2)));

% 相位逆变换
% 取相位
F1_angle = angle(F1);
F2_angle = angle(F2);

% 逆变换 exp(1i * 相位): 复数频谱; 10000: 频率分量的幅度
IF1_angle = uint8(abs(ifft2(10000 * exp(1i * F1_angle))));
IF2_angle = uint8(abs(ifft2(10000 * exp(1i * F2_angle))));

% 显示原图像和频谱图
subplot(2,3,1);
imshow(img1, []);
title('Rect1.bmp');

subplot(2,3,2);
imshow(IF1, []);
title('幅度逆变换图像');

subplot(2,3,3);
imshow(IF1_angle, []);
title('相位逆变换图像');

subplot(2,3,4);
imshow(img2, []);
title('Rect2.bmp');

subplot(2,3,5);
imshow(IF2, []);
title('幅度逆变换图像');

subplot(2,3,6);
imshow(IF2_angle, []);
title('相位逆变换图像');

% 人眼对图像的相频特性比幅频特性更敏感