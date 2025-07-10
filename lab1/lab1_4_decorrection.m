clc,clear,close all
img1 = imread("alphabet1.jpg");
img2 = imread("alphabet2.jpg");

[rows1, cols1, channels1] =size(img1);
[rows2, cols2, channels2] = size(img2);

subplot(1, 3, 1);
imshow(img1);
title("original image");

subplot(1, 3, 2); 
imshow((img2));
title("Geometric Distortion image");

% 选点
[x, y] = ginput(8);
u1 = x(1); v1 = y(1); x1 = x(2); y1 = y(2);
u2 = x(3); v2 = y(3); x2 = x(4); y2 = y(4);
u3 = x(5); v3 = y(5); x3 = x(6); y3 = y(6);
u4 = x(7); v4 = y(7); x4 = x(8); y4 = y(8);

% 投影变换 Projective Transformation
% [ u         [ x
%   v   = M *   y
%   1 ]         1 ]
% 需要求出 M 矩阵。

% 对于每一对控制点 (x,y) 和 (u,v)，根据投影变换公式：
%   u = (m11x + m12y + m13) / (m31x + m32y + 1)
%   v = (m21x + m22y + m13) / (m31x + m32y + 1)
% 消除分母，改写为:
%   (m31x + m32y + 1)u = m11x + m12y + m13
%   (m31x + m32y + 1)v = m21x + m22y + m13
% 整理得到:
%   u = m11x + m12y + m13 - m31xu - m32yu
%   v = m21x + m22y + m23 - m31xv - m32yv
% 每个控制点会生成两行:
% [ x1 y1 1 0  0  0 -x1u1 -y1u1 ;
%   0  0  0 x1 y1 1 -x1v1 -y1v1 ];

% 4 对控制点生成 8×8 的矩阵 A 如下：
A=[x1 y1 1 0  0  0 -x1*u1 -y1*u1;
   0  0  0 x1 y1 1 -x1*v1 -y1*v1;
   x2 y2 1 0  0  0 -x2*u2 -y2*u2;
   0  0  0 x2 y2 1 -x2*v2 -y2*v2;
   x3 y3 1 0  0  0 -x3*u3 -y3*u3;
   0  0  0 x3 y3 1 -x3*v3 -y3*v3;
   x4 y4 1 0  0  0 -x4*u4 -y4*u4;
   0  0  0 x4 y4 1 -x4*v4 -y4*v4];

% 矩阵B包含所有u和v：
B=[u1; v1; u2; v2; u3; v3; u4; v4];

% A * M = B => M = A^-1 * B 此处 M 为一个 8 x 1的向量
M = inv(A) * B;

% 得到的投影变换矩阵如下：
pMatrix = [M(1,1) M(2,1) M(3,1); 
          M(4,1) M(5,1) M(6,1);
          M(7,1) M(8,1) 1    ];

invM = inv(pMatrix);

dimg = zeros(rows1, cols1, channels1, 'uint8');
for i= 1 : rows1
    for j = 1 : cols1
        % 计算 齐次坐标的归一化因子 w 用于从目标图像映射回失真图像
        w = 1 / ( invM(3,1) * j + invM(3,2) * i + 1);
        
        % 反变换
		p =   invM * [w * j; w * i; w];

		x = fix(p(1, 1));
		y = fix(p(2, 1));
        
		if((x >= 1) && (x <= cols2) && (y >= 1) && (y <= rows2))
			for k = 1 : channels2
				dimg(i, j, k) = img2(y, x, k);
			end
		end
    end
end

subplot(1, 3, 1);
imshow(img1);
title("original image");

subplot(1, 3, 2); 
imshow((img2));
title("Geometric Distortion image");

subplot(1, 3, 3); 
imshow((dimg));
title("correct image");