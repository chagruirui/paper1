clc;
clear ;
close all;
A=imread('Lena_256.bmp'); 
imshow(A); title('原图') 
C=ZHITH(A);
figure,imshow(C);title('混沌加密图像')  %输出得到的加密图像 
P=ZHITHX(C);
figure,imshow(P);title('解密图像')  %输出得到的解密图像
%原图的直方图
A=double(A);
figure();hist(A(:),256);set(gca,'fontsize',18);
%加密图像的直方图
A1=double(C);
figure();hist(A1(:),256);set(gca,'fontsize',18);
nu=NPCRUACIBACI(A,A1);%原图和加密图像的NPCRUACIBACI