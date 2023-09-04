%测试转换是否无损

clc;
clear;
close all;
I1=imread('lena.jpg');% 载入图像
figure,imshow(I1);title('图片');% 显示图像
A=im2double(I1);% 将图像转为double格式
[m,n,~]=size(I1);
AA=rgb2hsi(A);
H=AA(:,:,1);%H通道
S=AA(:,:,2);%S通道
I=AA(:,:,3);%通道
%H=ZHITH(H);
% [H1 ,Phi11 ,Phi12]=csjia(H);
% [S1 ,Phi21 ,Phi22]=csjia(S);
% [I1 ,Phi31 ,Phi32]=csjia(I);
% figure,imshow(S);title('H通道原始');% 显示图像
% figure,imshow(S);title('S通道原始');% 显示图像
% figure,imshow(I);title('I通道原始');% 显示图像

% H2=csjie(H1,Phi11, Phi12, m, n);
% S2=csjie(S1,Phi21, Phi22, m, n);
% I2=csjie(I1,Phi31, Phi32, m, n);
%H=ZHITHX(H);
AA1(:,:,1)=H;
AA1(:,:,2)=S;
AA1(:,:,3)=I;
AA1=abs(AA1);
GG=hsi2rgb(AA1);
% R=C(:,:,1);
% G=C(:,:,2);
% B=C(:,:,3);
% figure,imshow(R);title('R通道原始');% 显示图像
% figure,imshow(G);title('G通道原始');% 显示图像
% figure,imshow(B);title('B通道原始');% 显示图像
% figure();hist(R(:),256);set(gca,'fontsize',18);xlim([0 255]);
% figure();hist(G(:),256);set(gca,'fontsize',18);xlim([0 255]);
% figure();hist(B(:),256);set(gca,'fontsize',18);xlim([0 255]);
%GG1=hsv2rgb(AA1);

figure,imshow(GG);title('图片');% 显示图像

 psnr1=psnr(A,GG) ;
% %psnr2=psnr(A,GG1) ;
% 
% MSE1=MSE(A,GG);
% % MSE2=MSE(A,GG1);
% 
% dNMSE1 = nmse(A,GG);
% % dNMSE2 = nmse(A,GG1);
% 
% ssim1=ssim(A,GG);
% ssim2=ssim(A,GG1);
% 
% Z = imabsdiff(A,GG);
% figure
% imshow(Z,[])

% Z1 = imabsdiff(A,GG1);
% figure
% imshow(Z1,[])

