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

% 超限邻域平均法去除图像中的噪声
threshold = input("please input threshold: ");
out_pepper = out_aver(pepper, threshold);
out_gaussian = out_aver(gaussian, threshold);
out_random = out_aver(random, threshold);

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
imshow(out_pepper);
title('椒盐超限邻域平均滤波');

subplot(3,3,8);
imshow(out_gaussian);
title('高斯超限邻域平均滤波');

subplot(3,3,9);
imshow(out_random);
title('随机超限邻域平均滤波');

% 超限邻域平均滤波器
function [out] = out_aver(in, threshold)
    out = in;
    [row, cols] = size(out);
    for i = 2 : (row - 1) % 避免越界
        for j = 2 : (cols - 1)
            % 计算均值
            % 提取当前像素 (i,j) 周围的 3x3 区域
            temp = in(i-1 : i+1, j-1 : j+1);
            % 使用两次 mean 函数计算这个区域的平均值
            mean_value = mean(mean(temp(:)));
            % 判断是否超越均值
            if(abs(double(in(i,j)) - mean_value) > threshold)
                out(i,j) = mean_value;
            end
        end
    end
end