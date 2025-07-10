img = imread('lena.bmp');

min = input("下限:");
max = input("上限:");

histogram(img, 'BinLimits', [min, max]);
% 'BinLimits' 参数: 限制直方图的显示范围