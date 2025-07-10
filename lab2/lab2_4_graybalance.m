img = imread('pout.bmp');

% 显示 pout.m 的直方图
subplot(3, 2, 1); 
imshow(img);
title("原图");

subplot(3, 2, 2); 
histogram(img);
title("pout.m 的直方图");

% 用直方图均衡对图像 pout.bmp 进行增强
ans1 = histeq(img);

% 显示增强后的图像及其直方图
subplot(3, 2, 3); 
imshow(ans1);
title("增强图");

subplot(3, 2, 4); 
histogram(ans1);
title("增强后图像的直方图");

% 用原始图像 pout.bmp 进行直方图规定化处理，将直方图规定化为高斯分布
ans2 = histeq(img, normpdf((0:1:255),60,10));
%  指定目标灰度分布，这里使用均值为 127、标准差为 40 的高斯分布

% 显示规定化后的图像及其直方图
subplot(3, 2, 5); 
imshow(ans2);
title("规定化后的图像");

subplot(3, 2, 6); 
histogram(ans2);
title("规定化后图像的直方图");