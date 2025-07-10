img = imread('lena.bmp');
subplot(1,3,1); imshow(img,[]); title('lena'); 

% 图像大小
[M, N] = size(img);
total_pixels = M * N;

% 1 统计灰度级中每个像素在整幅图像中的个数
% hist_counts: 灰度直方图
hist_counts = zeros(1, 256); % 灰度级从 0 到 255
for i = 0:255
    hist_counts(i+1) = sum(img(:) == i); % 统计每个灰度级出现次数
end

% 2 计算每个像素在整幅图像的概率分布
prob = hist_counts / total_pixels;

% 3 对灰度级进行遍历搜索，计算当前灰度值下前景背景类间概率
omega = zeros(1, 256); % 累积概率
mu = zeros(1, 256); % 累积均值
for t = 0:255
    omega(t+1) = sum(prob(1:t+1));   % 前景累计概率 w0
    mu(t+1) = sum((0:t).*prob(1:t+1)); % 前景累计均值 mu0
end
% w1 = 1-w0
% mu1 = (mu - w0 * mu0) / w1

% 总体均值（全局均值）
global_mean = mu(end);

% 4 通过目标函数计算出类内与类间方差下对应的阈值
g = zeros(1, 256); % 类间方差 
for t = 0:255
    if omega(t+1) == 0 || omega(t+1) == 1
        g(t+1) = 0; % 跳过无效情况
        continue;
    end
    mu0 = mu(t+1);
    mu1 = (global_mean - omega(t+1)*mu0) / (1 - omega(t+1));
    % g = w0 * w1 * (mu0 - mu1)^2
    g(t+1) = omega(t+1) * (1 - omega(t+1)) * (mu0 - mu1)^2;
end

% 找到最大类间方差对应的阈值
[~, best_t] = max(g);

% 返回归一化后的阈值
T = double(best_t - 1) / 255;

G = graythresh(img);
subplot(1,3,2); imshow(imbinarize(img, T),[]); title('手动OTSU函数'); 
subplot(1,3,3); imshow(imbinarize(img, G),[]); title('graythresh函数'); 
