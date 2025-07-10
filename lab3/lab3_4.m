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

% 用中值滤波器去除图像中的噪声
threshold = input("please input threshold: ");
outmed_pepper = out_med(pepper, threshold);
outmed_gaussian = out_med(gaussian, threshold);
outmed_random = out_med(random, threshold);

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
imshow(outmed_pepper);
title('椒盐超限中值滤波');

subplot(3,3,8);
imshow(outmed_gaussian);
title('高斯超限中值滤波');

subplot(3,3,9);
imshow(outmed_random);
title('随机超限中值滤波');

% 超限中值滤波器
function [out] = out_med(in, threshold)
    out = in;
    [row, cols] = size(out);
    for i = 2 : (row - 1)
        for j = 2 : (cols - 1)
            % 计算中值
            window = in(i-1 : i+1, j-1 : j+1);
            med_value = median(window(:));
            % 判断是否超越均值
            if(abs(double(in(i,j)) - double(med_value)) > threshold)
                out(i,j) = med_value;
            end
        end
    end
end