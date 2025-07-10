img1 = imread('pout.bmp');
img2 = imread('Girl.bmp');

% 输入阈值，n值
threshold = input("please input threshold:");
n_BHPF = input("please input n_BHPF:");
n_GHPF = input("please input n_GHPF:");

subplot(2,4,1);
imshow(img1, []);
title('pout.bmp');

subplot(2,4,2);
imshow(IHPF(img1, threshold), []);
title('Pout-理想高通滤波器');

subplot(2,4,3);
imshow(BHPF(img1, threshold, n_BHPF), []);
title('Pout-巴特沃斯高通滤波器');

subplot(2,4,4);
imshow(GHPF(img1, threshold, n_GHPF), []);
title('Pout-高斯高通滤波器');

subplot(2,4,5);
imshow(img2, []);
title('Girl.bmp');

subplot(2,4,6);
imshow(IHPF(img2, threshold), []);
title('Girl-理想高通滤波器');

subplot(2,4,7);
imshow(BHPF(img2, threshold, n_BHPF), []);
title('Girl-巴特沃斯高通滤波器');

subplot(2,4,8);
imshow(GHPF(img2, threshold, n_GHPF), []);
title('Girl-高斯高通滤波器');

% 理想高通滤波器(Ideal High-Pass Filter, IHPF)
function out = IHPF(in, thre)
    [r,l,~] = size(in);
    % 傅里叶变换并移动低频
    F = fft2(in);
    f_shift = fftshift(F);
    % 频率坐标
    [u,v] = meshgrid(-l/2 : l/2-1, -r/2 : r/2-1); 
    % 计算到原点的距离
    dist = hypot(u,v);
    % 滤波器函数 H(u,v) 小于阈值时为 1，大于阈值时为 0
    H = (dist > thre);
    % 滤波后的图像
    graph = f_shift .* H;
    % 傅里叶逆变换
    out = abs(ifft2(ifftshift(graph)));
end

% 巴特沃斯高通滤波器(Butterworth High-Pass Filter, BHPF)
function out = BHPF(in, thre, n)
    [r,l,~] = size(in);
    % 傅里叶变换并移动低频
    F = fft2(in);
    f_shift = fftshift(F);
    % 频率坐标
    [u,v] = meshgrid(-l/2 : l/2-1, -r/2 : r/2-1); 
    % 到原点的距离
    dist = hypot(u,v);
    % 滤波器函数 H(u,v) = 1/(1+(D(u,v)/D0)^2n))
    H = 1 ./ (1 + ((thre ./ dist) .^ (2 * n)));
    % 滤波后的图像
    graph = f_shift .* H;
    % 傅里叶逆变换
    out = abs(ifft2(ifftshift(graph)));
end

% 高斯高通滤波器(Gaussian High-Pass Filter, GHPF)
function out = GHPF(in, thre, n)
    [r,l,~] = size(in);
    % 傅里叶变换并移动低频
    F = fft2(in);
    f_shift = fftshift(F);
    % 频率坐标
    [u,v] = meshgrid(-l/2 : l/2-1, -r/2 : r/2-1); 
    % 计算到原点的距离
    dist = hypot(u,v);
    % 滤波器函数 H(u,v) = exp(-(D(u,v)/threshold)^n)
    H = exp(-(thre ./ dist) .^ n);
    % 滤波后的图像
    graph = f_shift .* H;
    % 傅里叶逆变换
    out = abs(ifft2(ifftshift(graph)));
end

% 振铃效应: 在信号的边缘或者图像的边界处出现的波动现象，在图像中表现为条纹的形式
% 原因或许是如理想高通滤波器，截止比较陡峭