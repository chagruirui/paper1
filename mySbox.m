function Sbox=mySbox(x0,y0)
%% 生成S盒子
%x0=0.9;y0=0.9;
x= zeros(1,10000);
y= zeros(1,10000);
for i= 1:10000
    [x1,y1] = SSS_2D(x0,y0);
    x(i)=x1;
    x0=x1;
    y(i)=y1;
    y0=y1;
end
% x = uint8(x*255);
% y = uint8(y*255);  %从x和y中分别选择两个长度为n=256的序列A和B
s = abs(x-y);  %计算序列A和B之间的差值
%C=C(1:10000);
[D,index] = sort(s,'descend');  %将序列C的元素按降序排列取索引值
box1 = index-1;  %计算在序列D中序列C的每一个元素的新位置
%S = E-1;  %计算值从0到255的序列S
%box1=box1./10000;
%Sbox = uint8(reshape(E,100,100));  %将序列S转换为M×N矩阵
Sbox = reshape(box1,100,100);  %将序列S转换为M×N矩阵
%Sbox=arnold(Sbox,75);
end