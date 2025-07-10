% clear
clc,clear,close all

% read image
img = imread("alphabet1.jpg");
% size(img) 返回 行数，列数，RGB 
[rows, cols, channels] = size(img);

% create blank image
tsimg = zeros(rows, cols, channels, 'uint8');

% input translate data
tx = input("Horizontal translation amount:");
ty = input("Vertical translation amount:");

% create translation matrix
TMatrix = [1 0 tx;
           0 1 ty; 
           0 0 1];

% translation
for i = 1 : rows
    for j = 1 : cols
        % translate every pixel
        p = TMatrix * [j; i; 1];
        x = p(1,1);
        y = p(2,1);
        % copy new img
        if((x >= 1) && (x <= cols) && (y >= 1) && (y <= rows))
            for k = 1 : channels
                tsimg(y, x, k) = img(i, j, k);
            end
        end
    end
end

% show
figure;
subplot(1, 2, 1);
imshow(img);
title("original image");

subplot(1, 2, 2);
imshow(tsimg);
title("translated image");
