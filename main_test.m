%��RGBͼ���ΪHSIͼ��󣬰Ѹ���Ҷ�任��Ϊ��������Ҷ�任ʱ����Ҫ��fftshift()��ifftshift()    (��fft��ifft���˾�ok)
clc;
clear;
close all;
I=imread('lena.jpg');% ����ͼ�� baboon.bmp  lena.jpg
P=im2double(I);% ��ͼ��һ����ת��˫����
% R=P(:,:,1);
% G=P(:,:,2);
% B=P(:,:,3);
% figure();hist(R(:),256);set(gca,'fontsize',18);xlim([0 1]);
% figure();hist(G(:),256);set(gca,'fontsize',18);xlim([0 1]);
% figure();hist(B(:),256);set(gca,'fontsize',18);xlim([0 1]);
[M,N,color]=size(P);%��ͼ�񳤿�
figure;imshow(P);title('��ɫԭʼͼƬ');% ��ʾͼ��
P=fftshift(P);%���ٸ���Ҷ�任���ֵ�������ͼ�񣬽���Ƶ���Ƶ�Ƶ�׵��м�
%figure,imshow(P);title('ͨ�����ٸ���Ҷ�任��Ƶ�����');% ��ʾͼ��
%% RGBתHSI
AA=rgb2hsi(P);%RGBתHSI
%%%%%%��ͨ��
H=AA(:,:,1);%Hͨ��
S=AA(:,:,2);%Sͨ��
I=AA(:,:,3);%Iͨ��
% figure,imshow(H);title('Hͨ��ԭʼ');% ��ʾͼ��
% figure,imshow(S);title('Sͨ��ԭʼ');% ��ʾͼ��
% figure,imshow(I);title('Iͨ��ԭʼ');% ��ʾͼ��
%% �������ļ������ϵͳ��Կ
H1= hash(H,'SHA-512');
S2= hash(S,'SHA-512');
HS= [H1;S2];
%����
% fid=fopen('Outputdata.txt','wt');
% for i=1:2
% fprintf(fid,'%s \n',HM(i,:));
% end
%D = pdist(HM, 'hamming');%��������
D1= pdist(HS,'euclidean');%  ŷʽ����
D1=floor(D1*10^4)/10^4;     %����4λС��
D2= pdist(HS, 'chebychev');% �б�ѩ����� 
D2=mod(floor(D2),192);
R1=D1+D2;%������Կ
R2=D1-D2;
R3=D1*D2;
R4=D1/D2;
%% ����ϵͳ�����ĸ��������
K= [D1,D2,R1,R2,R3,R4];%����� �������
[X,Y,R,W] = PRICKKey(M,N,K);
 n1=exp(2*j*pi*X);%�����������
 n2=exp(2*j*pi*Y);%Ҫ��
 n3=exp(2*j*pi*R);%�����������
 n4=exp(2*j*pi*W);%Ҫ��
%% ��H��Sͨ�����д���
%% h
rounds=1; 
DH1=sum(H(:)+D1);%������������
DH1=mod(floor(DH1),192);
H=arnold(H,DH1);%����

H=FBNQ(H,rounds);%��ɢ
DHD1=mod(DH1,4)*90;
H=imrotate(H, DHD1);%��ʱ����ת90��
H=FBNQ(H,rounds);
%figure,imshow(H);title('Hͨ������');% ��ʾͼ��
%  H=abs(H);
%  figure();hist(H(:),256);set(gca,'fontsize',18);
 %% s
DH2=sum(S(:)+D2);%������������
DH2=mod(floor(DH2),192);
S=arnold(S,DH2);%����

S=ifft2(fft2(S.*n1).*n2);%˫�����λ�������
%figure,imshow(S);title('Sͨ������');% ��ʾͼ��
%  S=abs(S);
%  figure();hist(S(:),256);set(gca,'fontsize',18);
%% ��Iͨ������Ԥ����
%%%%%%����Iͨ��xian����
DH3=sum(abs(I(:))+D1+D2);
DH3=mod(floor(DH3),192);
I=arnold(I,DH3);%arnold�����㷨   %n���Ҵ���a,b�ǲ��� D3�б�ѩ�����
%% ˫�����λ�������
I=ifft2(fft2(sqrt(I).*n3).*n4);
I=ifft2(fft2(I.*exp(2i*pi*H)).*exp(1i*S));
%I=ifft2(fft2(sqrt(I).*exp(2i*pi*H)).*exp(1i*S));%����˫��λ�ĵ�ͨ����ɫͼ�����
figure,imshow(abs(I));title('Iͨ������');% ��ʾͼ��
%% ����Է���
  Is=abs(I);%��ȡ���
  Ix=angle(I);%��ȡ��λ
  figure;
  hist(Is(:),256);set(gca,'fontsize',18);
    figure;
  hist(Ix(:),256);set(gca,'fontsize',18);
 % % %% �����ϵ��
r_S=ImCoef(Is.*255,2000);
r_X=ImCoef(Ix.*255,2000);

% r_R=ImCoef(R1.*255,2000);
% r_G=ImCoef(G1.*255,2000);
% r_B=ImCoef(B1.*255,2000);
% % %% ��Ϣ��
% xinxishangS=ENTROPY(Is);
% xinxishangX=ENTROPY(Ix);
% y_R=ENTROPY(R11);
% y_G=ENTROPY(G11);
% y_B=ENTROPY(B11);
 %% ����
%I=awgn(I,55);%��ͼ�������20dbw�ĸ�˹����
% I(116:180,116:180)=1;
% figure;
% imshow(abs(I));title('���н��');% ��ʾͼ��
%%  ��������
%I=imnoise(I, 'gaussian', 0, 0.01);%����Ϊ0.01�ĸ�˹����
%I=imnoise(I, 'poisson');%��Ӳ�������
%I=imnoise(I, 'salt & pepper', 0.005);
%I=imnoise(I, 'speckle');%��ӷ���Ϊ0.04�ĳ�������
%  I=abs(I);
%  figure();hist(I(:),256);set(gca,'fontsize',18);
%% ˫�����λ�������
%����Ҫ�ù�����λ��ģ
 n1=conj(n1);% ָ���ϼ��˸�'-'���൱������
 n2=conj(n2);
 n3=conj(n3);% ָ���ϼ��˸�'-'���൱������
 n4=conj(n4); 
%I=(ifft2(fft2(I).*exp(-1i*S)).*exp(-2i*pi*H)).^2;
I=(ifft2(fft2(I).*exp(-1i*S)).*exp(-2i*pi*H));
I=(ifft2(fft2(I).*n4).*n3).^2;%˫�����λ�������
I=iarnold(I,DH3);%������
%% Hͨ����Sͨ����Ϣ����
%   C1=fftshift(C);
%   C1=rgb2hsi(C1);
%   C1=complex(C1);%������ת��Ϊ��������
%   H=C1(:,:,1);%Hͨ��
%   S=C1(:,:,2);%Sͨ��
%   I=C1(:,:,3);%Iͨ��
%% S����
S=ifft2(fft2(S).*n2).*n1;%˫�����λ�������
S=iarnold(S,DH2);

%% H����
H=FBNQX(H,rounds);%��һ����ɢ����
H=imrotate(H, -DHD1);%˳������ת90
H=FBNQX(H,rounds);%��2����ɢ����
H=iarnold(H,DH1);%����

P1(:,:,1)=H;
P1(:,:,2)=S;
P1(:,:,3)=I;%��ԭͼƬ
P1=abs(P1);%���������ʵ������
P1=hsi2rgb(P1);%��ԭͼƬת��ʽ
%figure,imshow(F);title('��ԭͼƬ��ʽת�����');% ��ʾͼ��
P1=ifftshift(P1);%�����ٸ���Ҷ�任���ֵ�������ͼ�񣬽���Ƶ���ƻ�
figure;imshow(P1);title('��ɫ��ԭ');% ��ʾͼ��
%% PSNR
I=imread('lena.jpg');% ����ͼ�� baboon.bmp  lena.jpg
I=im2double(I);% ��ͼ��һ����ת��˫����
%TEST=psnr(I,P1);
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
R1=P1(:,:,1);
G1=P1(:,:,2);
B1=P1(:,:,3);
PSNRr1 = psnr(R,R1) ;
PSNRg1 = psnr(G,G1) ;
PSNRb1 = psnr(B,B1) ;
PSNR1=(PSNRr1+PSNRg1+PSNRb1)/3;

%% MSE
dMSE_R = MSE(R,R1);
dMSE_G = MSE(G,G1);
dMSE_B = MSE(B,B1);