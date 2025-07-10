img1 = imread('pout.bmp');
img2 = imread('Girl.bmp');

threshold = input("please input threshold:");
n_BLPF = input("please input n_BLPF:");
n_GLPF = input("please input n_GLPF:");

subplot(2,4,1);
imshow(img1, []);
title('pout.bmp');

subplot(2,4,2);
imshow(ILPF(img1, threshold), []);
title('Pout-理想低通滤波器');

subplot(2,4,3);
imshow(BLPF(img1, threshold, n_BLPF), []);
title('Pout-巴特沃斯低通滤波器');

subplot(2,4,4);
imshow(GLPF(img1, threshold, n_GLPF), []);
title('Pout-高斯低通滤波器');

subplot(2,4,5);
imshow(img2, []);
title('Girl.bmp');

subplot(2,4,6);
imshow(ILPF(img2, threshold), []);
title('Girl-理想低通滤波器');

subplot(2,4,7);
imshow(BLPF(img2, threshold, n_BLPF), []);
title('Girl-巴特沃斯低通滤波器');

subplot(2,4,8);
imshow(GLPF(img2, threshold, n_GLPF), []);
title('Girl-高斯低通滤波器');

% 理想低通滤波器(Ideal Low-Pass Filter, ILPF)
function out = ILPF(in, thre) % threshold 阈值
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
    % 滤波后的图像 (.* 逐元素乘法运算符)
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