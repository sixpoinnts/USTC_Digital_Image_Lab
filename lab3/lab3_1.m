img = imread('lena.bmp');

% 3% 椒盐噪声
pepper = imnoise(img, 'salt & pepper', 0.03);
% 高斯噪声
gaussian = imnoise(img,'gaussian');
% 随机噪声
[row, cols] = size(img);
random = img;
for i = 1:row
    for j = 1:cols
        if(pepper(i,j) ~= img(i,j))
            random(i,j) = uint8(rand() * 255);
        end
    end
end

% 1.用均值滤波器去除图像中的噪声（3x3窗口）
fpepper = imfilter(pepper, fspecial("average",3));
fgaussian = imfilter(gaussian, fspecial("average",3));
frandom = imfilter(random, fspecial("average",3));

% 显示
subplot(3,3,2);
imshow(img);
title('lena.bmp');

subplot(3,3,4);
imshow(pepper);
title('椒盐噪声');

subplot(3,3,5);
imshow(gaussian);
title('高斯噪声');

subplot(3,3,6);
imshow(random);
title('随机噪声');

subplot(3,3,7);
imshow(fpepper);
title('椒盐均值滤波');

subplot(3,3,8);
imshow(fgaussian);
title('高斯均值滤波');

subplot(3,3,9);
imshow(frandom);
title('随机均值滤波');