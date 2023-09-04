function rgb = hsi2rgb(hsi)
% rgb = hsi2rgb(hsi)把一幅HSI图像转换为RGB图像，
% 输入图像是一个彩色像素的M×N×3的数组，
% 其中每一个彩色像素都在特定空间位置的彩色图像中对应红、绿、蓝三个分量。
% 假如所有的RGB分量是均衡的，那么HSI转换就是未定义的。
% 输入图像可能是double（取值范围是[0, 1]），uint8或 uint16。
%
% 输出HSI图像是double，
% 其中hsi(:, :, 1)是色度分量，它的范围是除以2*pi后的[0, 1]；
% hsi(:, :, 2)是饱和度分量，范围是[0, 1]；
% hsi(:, :, 3)是亮度分量，范围是[0, 1]。

% 抽取图像分量
hsi = im2double(hsi);
H = hsi(:, :, 1)*2*pi;
S = hsi(:, :, 2);
I = hsi(:, :, 3);

% 执行转换方程
%定义rgb数组
R=zeros(size(hsi,1),size(hsi,2));
G=zeros(size(hsi,1),size(hsi,2));
B=zeros(size(hsi,1),size(hsi,2));
%分区域进行转换
idx=find((0<=H)&(H<2*pi/3));
B(idx)=I(idx).*(1-S(idx));
R(idx)=I(idx).*(1+S(idx).*cos(H(idx))./cos(pi/3-H(idx)));
G(idx)=3*I(idx)-(R(idx)+B(idx));

idx=find((2*pi/3<=H)&(H<4*pi/3));
R(idx)=I(idx).*(1-S(idx));
G(idx)=I(idx).*(1+S(idx).*cos(H(idx)-2*pi/3)./cos(pi-H(idx)));
B(idx)=3*I(idx)-(R(idx)+G(idx));

idx=find((4*pi/3<=H)&(H<2*pi));
G(idx)=I(idx).*(1-S(idx));
B(idx)=I(idx).*(1+S(idx).*cos(H(idx)-4*pi/3)./cos(5*pi/3-H(idx)));
R(idx)=3*I(idx)-(G(idx)+B(idx));


%将rgb分量合称为一个rgb图像
rgb = cat(3, R, G, B);
rgb=max(min(rgb,1),0);
