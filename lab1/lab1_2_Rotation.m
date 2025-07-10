clc,clear,close all
img = imread("cameraman.bmp");
[rows, cols, channels] = size(img);

% input theta and translate to rad
theta = input("please input theta:");
thetarad = deg2rad(theta);

% image center
cx = cols / 2;
cy = rows / 2;

% Rotation Matrix
RMatrix = [cos(thetarad), -sin(thetarad), 0;
           sin(thetarad), cos(thetarad),  0;
           0,             0,              1];

% 绕中心点旋转的运算矩阵
TMatrix = [1 0 cx;
           0 1 cy; 
           0 0 1];
TMatrix_T = [1 0 -cx;
             0 1 -cy; 
             0 0  1];
opMatrix = TMatrix * RMatrix * TMatrix_T;

% Nearest Neighbor Interpolation 最近邻法
% 需要使用反变换，找到旋转之前的点计算像素值
nnimg = zeros(rows, cols, channels, 'uint8');
for i= 1 : cols
    for j = 1 : rows
        % translate every pixel
        p = inv(opMatrix) * [i; j; 1] ;
        x = fix(p(1,1));
        y = fix(p(2,1));
        if((x >= 1) && (x <= cols) && (y >= 1) && (y <= rows))
            for k = 1 : channels
                % 该点的像素值
                nnimg(j, i, k) = img(y, x, k);
            end
        end
    end
end

% Bilinear Interpolation 双线性插值
bimg = zeros(rows, cols, channels, 'uint8');
for i= 1 : cols
    for j = 1 : rows
        p = inv(opMatrix) * [i; j; 1];
        x = p(1,1);
        y = p(2,1);
        if ((x >= 1) && (x <= cols) && (y >= 1) && (y <= rows))
            % 4 point (x1, y2) (x2, y2) 
            %         (x1, y1) (x2, y1）
            x1 = floor(x);
            x2 = ceil(x);
            y1 = floor(y);
            y2 = ceil(y);
            for k = 1 : channels
                % x, y 为整数
                if( x == x1 && y == y1 )
                    bimg(j, i, k) = img(y, x, k);
                % x 为整数
                elseif (x == x1) 
                    p1_val = (y2 - y) * img(y1, x1, k);
                    p3_val = (y - y1) * img(y2, x1, k);
                    bimg(j, i, k) = p1_val + p3_val;
                % y 为整数
                elseif (y == y1) 
                    p1_val = (x2 - x) * img(y1, x1, k);
                    p2_val = (x - x1) * img(y1, x2, k);
                    bimg(j, i, k) = p1_val + p2_val;
                % 正常情况
                else
                    p1_val = (x2 - x) * (y2 - y) * img(y1, x1, k);
                    p2_val = (x - x1) * (y2 - y) * img(y1, x2, k);
                    p3_val = (x2 - x) * (y - y1) * img(y2, x1, k);
                    p4_val = (x - x1) * (y - y1) * img(y2, x2, k);
                    bimg(j, i, k) = p1_val + p2_val + p3_val + p4_val;
                end
            end
        end
    end
end

figure;

subplot(1, 3, 1);
imshow(img);
title("original image");

subplot(1, 3, 2); 
imshow((nnimg));
title("Nearest Neighbor Interpolation");

subplot(1, 3, 3); 
imshow((bimg));
title("Bilinear Interpolation");

% 最近邻插值法：简单快速，但可能导致图像质量下降
% 双线性插值法：计算复杂度较高，但生成的图像更平滑、质量更高