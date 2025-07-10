clc,clear,close all
img = imread("cameraman.bmp");
[rows, cols, channels] = size(img);

% input x:c and y:d
c = input("please input c:");
d = input("please input d:");
C = fix(c * cols);
D = fix(d * rows);

% Scaling Matrix
SMatrix = [c, 0, 0;
           0, d, 0;
           0, 0, 1];

% Nearest Neighbor Interpolation
nnimg = zeros(D, C, channels, 'uint8');
for i = 1 : C % 行
    for j = 1 : D % 列
        p = inv(SMatrix) * [i; j; 1];
        x = fix(p(1,1));
        y = fix(p(2,1));
        if ((x >= 1) && (x <= cols) && (y >= 1) && (y <= rows))
            for k = 1 : channels
                nnimg(j, i, k) = img(y, x, k);
            end
        end
    end
end

% Bilinear Interpolation
bimg = zeros(D, C, channels, 'uint8');
for i = 1 : C % 行
    for j = 1 : D % 列
        p = inv(SMatrix) * [i;j;1];
        x = fix(p(1,1));
        y = fix(p(2,1));
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