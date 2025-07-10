img = imread('lena.bmp');
[rows, cols] = size(img);
limg = zeros(rows, cols, 'uint8');

fA = input("please input f_A: "); % 斜率
fB = input("please input f_B: "); % 截距

for i = 1 : rows
    for j = 1 : cols
        limg(i,j) = img(i,j) * fA + fB;
    end
end

subplot(1, 2, 1);
imshow(img);
title("original image");

subplot(1, 2, 2); 
imshow(limg);
title("After Linear Transformation");