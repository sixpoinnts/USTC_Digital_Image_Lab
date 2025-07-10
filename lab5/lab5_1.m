img = imread('flower1.jpg');

% 运动模糊处理器 运动位移 30 个像素、运动方向 45 度
blur_filter = fspecial("motion", 30, 45);

% 运动模糊图像 'conv': 指定进行卷积操作 
%             'circular'：边界处理的方式为循环
motion_img = imfilter(im2double(img), blur_filter, 'conv', 'circular');
% 采用逆滤波进行恢复 Inverse Filtering
if_img = deconvwnr(motion_img, blur_filter);
% 采用维纳滤波进行恢复 Wiener Filtering (无噪声)
wf_img = deconvwnr(motion_img, blur_filter);

% 加高斯噪声 均值:0 标准差:0.0001
noisy = imnoise(motion_img, 'gaussian', 0, 0.0001);
% 逆滤波
if_gimg = deconvwnr(noisy, blur_filter);
% 维纳滤波
wf_gimg = deconvwnr(noisy, blur_filter, 0.0001);

subplot(3,3,2);
imshow(img, []);
title('flower1.jpg');

subplot(3,3,4);
imshow(motion_img, []);
title('运动模糊图像');

subplot(3,3,5);
imshow(if_img, []);
title('采用逆滤波恢复的运动模糊图像');

subplot(3,3,6);
imshow(wf_img, []);
title('采用维纳滤波恢复的运动模糊图像');

subplot(3,3,7);
imshow(noisy, []);
title('加高斯噪声');

subplot(3,3,8);
imshow(if_gimg, []);
title('采用逆滤波恢复的高斯噪声图像');

subplot(3,3,9);
imshow(wf_gimg, []);
title('采用维纳滤波恢复的高斯噪声图像');