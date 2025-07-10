img = imread('cameraman.bmp');
subplot(1,3,1);
imshow(img,[]);
title('cameraman.bmp');

% 图像块的颜色范围阈值
threshold = 0.35;

% 四叉树分割 2: 最小块边长 (mindim) 
qtree = qtdecomp(img, threshold, 2);
block = zeros(size(qtree));

% 可视化四叉树分割的结果（白线标注）
for dim = [256 128 64 32 16 8 4 2]
    % 计算当前dim在图像中的数量
    numblocks = length(find(qtree == dim));
    if(numblocks > 0)
        % 创建创建边框模板 values 大小为 dim x dim x numblocks
        values = repmat(uint8(1), [dim dim numblocks]);
        values(2:dim, 2:dim, :) = 0;
        % 插入边框
        block = qtsetblk(block,qtree,dim,values);
    end
end

% 分割结果
ans1 = img;
ans1(block==1) = 255; % 将边界置为白色
subplot(1,3,2);
imshow(ans1,[]);
title('分裂后的图像');

% 为区域分割得到每个块进行标记
tag = 0;
for dim = [64 32 16 8 4 2]
    % 找到 dim x dim 块在图形中的位置
    % val：包含所有符合条件的块的数据，形状为 [dim, dim, n]
    [val, r , c] = qtgetblk(img, qtree, dim); 
    if ~isempty(val) % val 非空
        for i = 1 : length(r) % length(r) 当前尺寸下块的数量
            tag = tag + 1;
            block(r(i):r(i) + dim - 1, c(i): c(i) + dim - 1) = tag; 
        end
    end
end

% 合并极差较小的块
for i = 1 : tag
    bound = boundarymask(block==i, 4) & (~(block == i));
    % 查找边界掩码中值为 1 的像素点的行列坐标
    [r, l] = find(bound == 1);
    for k = 1 : size(r,1)
        % 将相邻分块的像素值合并到一个数组中
        merge = img((block == i) | (block == block(r(k), l(k))));
        % 计算合并后像素的极差是否小于阈值
        if (range(merge(:)) < threshold * 256)
            block(block == block(r(k), l(k))) = i;
        end
    end
end

% 检测并标记图像中不同区域之间的边界
ans2 = img;
for tag = 1 : 255
    for i = 1 : 255
        % 如果当前像素点处于两个不同的分块的边界上
        if (block(tag, i) ~= block(tag, i + 1) || block(tag, i) ~= block(tag + 1, i))
            ans2(tag, i) = 255; % 设置边界为白色
        end
    end
end

subplot(1,3,3);
imshow(ans2,[]);
title('分裂合并后的图像');