img1 = imread('Rect1.bmp');
img2 = imread('Rect2.bmp');

% 傅里叶变换
F1 = fft2(img1);
F2 = fft2(img2);

% 共轭逆变换
% 取共轭
F1_conj = conj(F1);
F2_conj = conj(F2);

% 逆变换
IF1_conj = ifft2(F1_conj);
IF2_conj = ifft2(F2_conj);

% 打印
subplot(2,2,1);
imshow(img1, []);
title('Rect1.bmp');

subplot(2,2,2);
imshow(IF1_conj, []);
title('共轭逆变换图像');

subplot(2,2,3);
imshow(img2, []);
title('Rect2.bmp');

subplot(2,2,4);
imshow(IF2_conj, []);
title('共轭逆变换图像');