img = imread('lena.bmp');
[rows, cols] = size(img);
epimg = zeros(rows, cols, 'uint8');

x1 = input("x1:");
y1 = input("y1:");
x2 = input("x2:");
y2 = input("y2:");

for i = 1:rows
    for j = 1:cols
        x = img(i, j);
        if(x < x1)
            epimg(i, j) = y1 / x1 * x;
        else
            if(x <= x2)
                epimg(i, j) = (y2 - y1)/(x2 - x1) * (x - x1) + y1;
            else
                epimg(i, j) = (255 - y2)/(255 - x2) * (x - x2) + y2;
            end
        end
    end
end

subplot(1, 2, 1);
imshow(img);
title("original image");

subplot(1, 2, 2); 
imshow(epimg);
title("After Gray Expanding");