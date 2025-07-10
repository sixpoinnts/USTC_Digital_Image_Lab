img = imread('Girl.bmp');

% 椒盐噪声
pepper = imnoise(img, 'salt & pepper', 0.1);
% 高斯噪声
gaussian = imnoise(img,'gaussian');

% 输入阈值，n值
threshold = input("please input threshold:");
n_BLPF = input("please input n_BLPF:");
n_GLPF = input("please input n_GLPF:");

% 去噪
Pepper_ILPF = ILPF(pepper, threshold);
Pepper_BLPF = BLPF(pepper, threshold, n_BLPF);
Pepper_GLPF = GLPF(pepper, threshold, n_GLPF);

Gaussian_ILPF = ILPF(gaussian, threshold);
Gaussian_BLPF = BLPF(gaussian, threshold, n_BLPF);
Gaussian_GLPF = GLPF(gaussian, threshold, n_GLPF);

% 显示
subplot(3,4,1);
imshow(img, []);
title('Girl.bmp');

subplot(3,4,5);
imshow(pepper, []);
title('椒盐噪声图像');

subplot(3,4,6);
imshow(Pepper_ILPF, []);
title('理想低通滤波器椒盐噪声图像');

subplot(3,4,7);
imshow(Pepper_BLPF, []);
title('巴特沃斯低通滤波器椒盐噪声图像');

subplot(3,4,8);
imshow(Pepper_GLPF, []);
title('高斯低通滤波器椒盐噪声图像');

subplot(3,4,9);
imshow(gaussian, []);
title('高斯噪声图像');

subplot(3,4,10);
imshow(Gaussian_ILPF, []);
title('理想低通滤波器高斯噪声图像');

subplot(3,4,11);
imshow(Gaussian_BLPF, []);
title('巴特沃斯低通滤波器高斯噪声图像');

subplot(3,4,12);
imshow(Gaussian_GLPF, []);
title('高斯低通滤波器高斯噪声图像');

% 理想低通滤波器(Ideal Low-Pass Filter, ILPF)
function out = ILPF(in, thre)
    [r,l,~] = size(in);
    % 傅里叶变换并移动低频
    F = fft2(in);
    f_shift = fftshift(F);
    % 用 meshgrid 从给定的向量创建二维网格坐标矩阵
    [u,v] = meshgrid(-l/2 : l/2-1, -r/2 : r/2-1); 
    % 计算到原点的距离
    dist = hypot(u,v);
    % 滤波器函数 H(u,v) 小于阈值时为 1，大于阈值时为 0
    H = (dist <= thre);
    % 滤波后的图像
    graph = f_shift .* H;
    % 傅里叶逆变换
    out = abs(ifft2(ifftshift(graph)));
end

% 巴特沃斯低通滤波器(Butterworth Low-Pass Filter, BLPF)
function out = BLPF(in, thre, n)
    [r,l,~] = size(in);
    % 傅里叶变换并移动低频
    F = fft2(in);
    f_shift = fftshift(F);
    % 频率坐标
    [u,v] = meshgrid(-l/2 : l/2-1, -r/2 : r/2-1); 
    % 到原点的距离
    dist = hypot(u,v);
    % 滤波器函数 H(u,v) = 1/(1+(D(u,v)/D0)^2n))
    H = 1 ./ (1 + ((dist ./ thre) .^ (2 * n)));
    % 滤波后的图像
    graph = f_shift .* H;
    % 傅里叶逆变换
    out = abs(ifft2(ifftshift(graph)));
end

% 高斯低通滤波器(Gaussian Low-Pass Filter, GLPF)
function out = GLPF(in, thre, n)
    [r,l,~] = size(in);
    % 傅里叶变换并移动低频
    F = fft2(in);
    f_shift = fftshift(F);
    % 频率坐标
    [u,v] = meshgrid(-l/2 : l/2-1, -r/2 : r/2-1); 
    % 计算到原点的距离
    dist = hypot(u,v);
    % 滤波器函数 H(u,v) = exp(-(D(u,v)/threshold)^n)
    H = exp(-(dist ./ thre) .^ n);
    % 滤波后的图像
    graph = f_shift .* H;
    % 傅里叶逆变换
    out = abs(ifft2(ifftshift(graph)));
end