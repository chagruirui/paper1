clc;
clear ;
close all;
A=imread('Lena_256.bmp'); 
imshow(A); title('ԭͼ') 
C=ZHITH(A);
figure,imshow(C);title('�������ͼ��')  %����õ��ļ���ͼ�� 
P=ZHITHX(C);
figure,imshow(P);title('����ͼ��')  %����õ��Ľ���ͼ��
%ԭͼ��ֱ��ͼ
A=double(A);
figure();hist(A(:),256);set(gca,'fontsize',18);
%����ͼ���ֱ��ͼ
A1=double(C);
figure();hist(A1(:),256);set(gca,'fontsize',18);
nu=NPCRUACIBACI(A,A1);%ԭͼ�ͼ���ͼ���NPCRUACIBACI