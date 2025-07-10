img = imread('pout.bmp');

% 输入阈值，n值
threshold = input("please input threshold:");
n_BHFF = input("please input n_BHFF:");
n_GHFF = input("please input n_EHFF:");
a = input("please input a:");
b = input("please input b:");

% 显示
subplot(3,3,1);
imshow(img, []);
title('pout.bmp');

% 先经过高频增强滤波，再进行直方图均衡化，显示结果图像
subplot(3,3,4);
imshow(IHFF(img, threshold, a, b), []);
title('理想高通滤波器');

subplot(3,3,5);
imshow(BHFF(img, threshold, n_BHFF, a, b), []);
title('巴特沃斯高通滤波器');

subplot(3,3,6);
imshow(GHFF(img, threshold, n_GHFF, a, b), []);
title('高斯高通滤波器');

% 先进行直方图均衡化，再经过高频增强滤波，显示结果图像
subplot(3,3,7);
imshow(histeq(img), []);
title('直方图均衡化-理想高通滤波器图像');

subplot(3,3,8);
imshow(histeq(img), []);
title('直方图均衡化-巴特沃斯高通滤波器图像');

subplot(3,3,9);
imshow(histeq(img), []);
title('直方图均衡化-高斯高通滤波器图像');

% 理想高频增强滤波器(Ideal High-frequency Filter, IHFF)
function out = IHFF(in, thre, a, b)
    [r,l,~] = size(in);
    F = fft2(in);
    f_shift = fftshift(F);
    [u,v] = meshgrid(-l/2 : l/2-1, -r/2 : r/2-1); 
    dist = hypot(u,v);
    H = (dist > thre);
    H = a * H + b; % 高频增强
    graph = f_shift .* H;
    out = abs(ifft2(ifftshift(graph)));
end

% 巴特沃斯高频滤波器(Butterworth High-frequency Filter, BHPF)
function out = BHFF(in, thre, n, a, b)
    [r,l,~] = size(in);
    F = fft2(in);
    f_shift = fftshift(F);
    [u,v] = meshgrid(-l/2 : l/2-1, -r/2 : r/2-1); 
    dist = hypot(u,v);
    H = 1 ./ (1 + ((thre ./ dist) .^ (2 * n)));
    H = a * H + b; % 高频增强
    graph = f_shift .* H;
    out = abs(ifft2(ifftshift(graph)));
end

% 高斯高频滤波器(Gaussian High-frequency Filter, GHPF)
function out = GHFF(in, thre, n, a, b)
    [r,l,~] = size(in);
    F = fft2(in);
    f_shift = fftshift(F);
    [u,v] = meshgrid(-l/2 : l/2-1, -r/2 : r/2-1); 
    dist = hypot(u,v);
    H = exp(-(thre ./ dist) .^ n);
    H = a * H + b; % 高频增强
    graph = f_shift .* H;
    out = abs(ifft2(ifftshift(graph)));
end

% 先高频增强滤波，再进行直方图均衡化：
% 有更明显的边缘和细节，图像的视觉效果较好，但出现有过度曝光和细节丢失的现象

% 先进行直方图均衡化，再经过高频增强滤波
% 改善图像的对比度，但视觉效果不如上图