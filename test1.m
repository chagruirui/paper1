%����ת���Ƿ�����

clc;
clear;
close all;
I1=imread('lena.jpg');% ����ͼ��
figure,imshow(I1);title('ͼƬ');% ��ʾͼ��
A=im2double(I1);% ��ͼ��תΪdouble��ʽ
[m,n,~]=size(I1);
AA=rgb2hsi(A);
H=AA(:,:,1);%Hͨ��
S=AA(:,:,2);%Sͨ��
I=AA(:,:,3);%ͨ��
%H=ZHITH(H);
% [H1 ,Phi11 ,Phi12]=csjia(H);
% [S1 ,Phi21 ,Phi22]=csjia(S);
% [I1 ,Phi31 ,Phi32]=csjia(I);
% figure,imshow(S);title('Hͨ��ԭʼ');% ��ʾͼ��
% figure,imshow(S);title('Sͨ��ԭʼ');% ��ʾͼ��
% figure,imshow(I);title('Iͨ��ԭʼ');% ��ʾͼ��

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
% figure,imshow(R);title('Rͨ��ԭʼ');% ��ʾͼ��
% figure,imshow(G);title('Gͨ��ԭʼ');% ��ʾͼ��
% figure,imshow(B);title('Bͨ��ԭʼ');% ��ʾͼ��
% figure();hist(R(:),256);set(gca,'fontsize',18);xlim([0 255]);
% figure();hist(G(:),256);set(gca,'fontsize',18);xlim([0 255]);
% figure();hist(B(:),256);set(gca,'fontsize',18);xlim([0 255]);
%GG1=hsv2rgb(AA1);

figure,imshow(GG);title('ͼƬ');% ��ʾͼ��

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

