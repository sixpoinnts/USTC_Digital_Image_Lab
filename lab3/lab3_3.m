img = imread('lena.bmp');

% 添加噪声
pepper = imnoise(img, 'salt & pepper', 0.03);
gaussian = imnoise(img,'gaussian');
[row, cols] = size(img);
random = img;
for i = 1:row
    for j = 1:cols
        if(pepper(i,j) ~= img(i,j))
            random(i,j) = uint8(rand() * 255);
        end
    end
end

% 中值滤波
med_pepper = medfilt2(pepper);
med_gaussian = medfilt2(gaussian);
med_random = medfilt2(random);

% 打印图像
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
imshow(med_pepper);
title('椒盐中值滤波');

subplot(3,3,8);
imshow(med_gaussian);
title('高斯中值滤波');

subplot(3,3,9);
imshow(med_random);
title('随机中值滤波');