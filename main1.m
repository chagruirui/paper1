%��RGBͼ���ΪHSIͼ��󣬰Ѹ���Ҷ�任��Ϊ��������Ҷ�任ʱ����Ҫ��fftshift()��ifftshift()    (��fft��ifft���˾�ok)
%2022.6.20
%��ͨ��
clc;
clear;
close all;
addpath pingjia;
P=imread('test4.jpg');% ����ͼ��  lena.jpg baboon.png airplane.png   peppers.png   demo.jpg  C256.png XZ.jpg eye.jpg  fxwh.jpg

%  % %ֱ��ͼͼ��ֱ��ͼ��������
%hist3(P);
R=double(P(:,:,1));
G=double(P(:,:,2));
B=double(P(:,:,3));
R_jiami=kafangjianyan(R);
G_jiami=kafangjianyan(G);
B_jiami=kafangjianyan(B);

%%
% yR=ENTROPY(R);
% yG=ENTROPY(G);
% yB=ENTROPY(B);
% R(1,1)=mod(R(1,1)+1,256);
% G(1,1)=mod(G(1,1)+1,256);
% B(1,1)=mod(B(1,1)+1,256);
% P1(:,:,1)=R;
% P1(:,:,2)=G;
% P1(:,:,3)=B;
% figure,imshow(R);title('Rͨ��ԭʼ');% ��ʾͼ��
% figure,imshow(G);title('Gͨ��ԭʼ');% ��ʾͼ��
% figure,imshow(B);title('Bͨ��ԭʼ');% ��ʾͼ��
% figure();imhist(R(:),256);set(gca,'fontsize',18);
% figure();imhist(G(:),256);set(gca,'fontsize',18);
% figure();imhist(B(:),256);set(gca,'fontsize',18);
%P=im2double(P);% ��ͼ��һ����ת��˫����
[M,N,color]=size(P);%��ͼ�񳤿�
figure;imshow(P);title('��ɫԭʼͼƬ');% ��ʾͼ��
P=im2double(P);
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
% figure();imhist(H(:),256);set(gca,'fontsize',18);%ylim([0,3000]);
% figure();imhist(S(:),256);set(gca,'fontsize',18);%ylim([0,1200]);
% figure();imhist(I(:),256);set(gca,'fontsize',18);
%% �������ļ������ϵͳ��Կ
HH= hash(H,'SHA-512');
SS= hash(S,'SHA-512');
HS= [HH;SS];
%7b94d9edb4c26c9baefc83879172a51742a473fffec5fad9d7bc116750b142dd511353fefef8285386fcac36b08cd3e4bfaea82b6c6b80569c70d8355e1bb750
%2919c5e16b17f8fa71a6dcddc5b5a828b24735b90f8c11a140a932cabec9fafa0df68ba85d927a31f5aea9568dd761ae47db0ba40f27d678c7ac97cb98424686
%����
% fid=fopen('Outputdata.txt','wt');
% for i=1:2
% fprintf(fid,'%s \n',HM(i,:));
% end
%D = pdist(HS, 'hamming');%��������
DD1= pdist(HS,'euclidean');%  ŷʽ����
DD1=floor(DD1*10^4)/10^4;     %����4λС��
DD2= pdist(HS, 'chebychev');% �б�ѩ����� 
%DD2=mod(floor(DD2),192);
DD2=floor(DD2*10^4)/10^4;     %����4λС��
R0=DD1+DD2;%������Կ
R2=DD1-DD2;
R3=DD1*DD2;
R4=DD1/DD2;
%% ����ϵͳ�����ĸ��������
K= [DD1,DD2,R0,R2,R3,R4];%����� �������
[X,Y,R,W] = PRICKKey(M,N,K);
 n1=exp(2*1j*pi*X);%�����������
 n2=exp(2*1j*pi*Y);%Ҫ��
%  n3=exp(2*1j*pi*R);%�����������
%  n4=exp(2*1j*pi*W);%Ҫ��

%% ��H���д���(����+��ɢ)
%�滻
H=TIHUAN4(H,R0,R2,R3,R4);
%  figure();imhist(H(:),256);
%  yH=ENTROPY(floor(H.*255));
%%����
DH1=sum(H(:)+DD1);%������������
DH1=mod(round(DH1),96)+48;
H=arnold(H,DH1);

%%��ɢ
DHD1=(mod(floor(DD1),4)+1)*90;%������ת�Ƕ�
H=FBNQ(H,DHD1);%��ɢ
H=imrotate(H,DHD1);%��ʱ����ת90��
H=FBNQ(H,DHD1);
% figure();imhist(H(:),256);
% yH=ENTROPY(floor(H.*255));
%  H_SHANG=floor(H.*255);
%  yH=ENTROPY(H_SHANG);
%  H=abs(H);
% figure,imshow(H);title('Hͨ������');% ��ʾͼ��
%  figure();hist(H(:),256);set(gca,'fontsize',18);
%% Sͨ������ ���滻+��ɢ��
S=TIHUAN4(S,R0,R2,R3,R4);
% figure();imhist(S(:),256);
% yH=ENTROPY(floor(S.*255));
%����
DH2=sum(S(:)+DD2);%������������
DH2=mod(round(DH2),96)+48;
S=arnold(S,DH2);%����
%��ɢ
DHD2=(mod(floor(DD2),4)+1)*90;%������ת�Ƕ�
S=FBNQ(S,DHD2);%��ɢ

S=imrotate(S, DHD2);%��ʱ����ת90��
S=FBNQ(S,DHD2);%����ɢһ��
% figure();imhist(S(:),256);
% yS=ENTROPY(floor(S.*255));
%  S_SHANG=floor(S.*255);
% yS=ENTROPY(S_SHAN);
% figure,imshow(S);title('Sͨ������');% ��ʾͼ��
%  S2=abs(S);
%  figure();hist(S2(:),256);set(gca,'fontsize',18);
%% ��Iͨ������Ԥ����
%%%%%%����Iͨ��xian����
DH3=sum(DD1+DD2);
DH3=mod(round(DH3),96)+48;
I=arnold(I,DH3);%arnold�����㷨   %n���Ҵ���a,b�ǲ��� D3�б�ѩ�����
%% ˫�����λ�������
%%%%%%
DHD3=mod(floor(DH3),4)*90;%������ת�Ƕ�
%I=ifft2(fft2(sqrt(I).*n1).*n2);
a=1;
b=1;
  n3=exp(2*1j*pi*H);%�����������
  n4=exp(2*1j*pi*S);%Ҫ��
I=MYFRFT2(I,n1,n3,DH3,a,b);
I=imrotate(I, DHD3);%��ʱ����ת90��
I=MYFRFT2(I,n2,n4,DH3,a,b);
%I=ifft2(fft2(I.*n3).*n4);%˫�����λ�������

%% ���DRPE����
%I=ifft2(fft2(I.*exp(2i*pi*H)).*exp(2i*pi*S));%����˫��λ�ĵ�ͨ����ɫͼ�����
%% ����
%   I11=abs(I);
%  I_SHANG=floor(I11.*255);
%  yI=ENTROPY(I_SHANG);
%figure,imshow(I11);title('Iͨ������');% ��ʾͼ��
%  figure();hist(I11(:),256);set(gca,'fontsize',18);
%ZFT=ImCoef(I11.*255,2000);
%����
% I(148:180,148:180)=0.0001;
% %116:180,116:180
% %48:180,48:180
% figure,imshow(abs(I));title('Iͨ������');% ��ʾͼ��
%% ����
%  I=ifft2(fft2(sqrt(I).*n3).*n4);
% %I=fracF2D(fracF2D(I.*n1,1,1).*n2,-1,-1);%˫�����λ�������
%  figure,imshow(I);title('Iͨ������');% ��ʾͼ��
%  Is=real(I);%��ȡʵ��
%  Ix=imag(I);%��ȡ�鲿
%  If=angle(I);%��ȡ����
%  Ixw=log(angle(I)*180/pi);%�����λ��
%  Izf= log(abs(I));%��÷�����
% Im=abs(I);%ģ
% IC = Im.*exp(j*(If));%˫���ع�
% %IC = abs(I).*exp(j*(angle(I)));%˫���ع�
%% �ϲ���ͨ�� ��ԭ����ͼ
C(:,:,1)=H;
C(:,:,2)=S;
C(:,:,3)=I;%��ԭͼƬ
 C=abs(C);%���������ʵ������
%  C=hsi2rgb(C);
% C=ifftshift(C);
figure;
imshow(C);title('�����ܽ��');% ��ʾͼ��

C=floor(C.*255);
C=double(C);
%% ֱ��ͼ
%hist3(C);
 % %ֱ��ͼͼ��ֱ��ͼ��������
H1=double(C(:,:,1));
S1=double(C(:,:,2));
I1=double(C(:,:,3));
H_jiami=kafangjianyan(H1);
S_jiami=kafangjianyan(S1);
I_jiami=kafangjianyan(I1);
% figure();hist(G1(:),256);set(gca,'fontsize',18);
% figure();hist(B1(:),256);set(gca,'fontsize',18);
%% % % %% �����ϵ��
% r_R=ImCoef(R1.*255,2000);
% r_G=ImCoef(G1.*255,2000);
% r_B=ImCoef(B1.*255,2000);
%% ����
% I_s= C(:,:,1);
% I_s(116:180,116:180)=0.0001;
% I_h =C(:,:,2);
% I_h(116:180,116:180)=0.0001;
% I_i =C(:,:,3);
% I_i(116:180,116:180)=0.0001;
% CC1(:,:,1) = I_s;
% CC1(:,:,2) = I_h;
% CC1(:,:,3) = I_i;
%  figure;
%  imshow(abs(CC1));title('���н��');% ��ʾͼ��
%% �������
%I=imnoise(I, 'gaussian', 0, 0.001);%����Ϊ0.01�ĸ�˹����
%I=imnoise(I, 'salt & pepper', 0.005);%��������
%I=imnoise(I, 'speckle');%��ӷ���Ϊ0.04�ĳ�������
%I=awgn(I,30,'measured','dB');%��ӹ���Ϊԭʼ�ź�x���ʵ�1/10�������������Сȡ����x
%% ���ܵ�һ��
% H(116:180,116:180)=0;
% S(116:180,116:180)=0;
% I(116:180,116:180)=0;
%I=(ifft2(fft2(I).*exp(-2i*pi*S)).*exp(-2i*pi*H));
%% ˫�����λ�������
%����Ҫ�ù�����λ��ģ
 n1=conj(n1);% ָ���ϼ��˸�'-'���൱������
 n2=conj(n2);
 n3=conj(n3);% ָ���ϼ��˸�'-'���൱������
 n4=conj(n4); 

I=MYFRFT2X(I,n2,n4,DH3,a,b);
I=imrotate(I, -DHD3);%˳������ת90
I=MYFRFT2X(I,n1,n3,DH3,a,b);
  %I=(ifft2(fft2(I).*n4).*n3);%˫�����λ�������
   % I=(ifft2(fft2(I).*n2).*n1).^2;%˫�����λ�������
I1=iarnold(I,DH3);%������
%figure;imshow(I);title('Iͨ��������');% ��ʾͼ��
%% Hͨ����Sͨ����Ϣ���ܣ���ɢ+���ң�
%   C1=fftshift(C);
%   C1=rgb2hsi(C1);
%   C1=complex(C1);%������ת��Ϊ��������
%   H=CC1(:,:,1);%Hͨ��
%   S=CC1(:,:,2);%Sͨ��
%   I=CC1(:,:,3);%Iͨ��
H=FBNQX(H,DHD1);%��һ����ɢ����
H=imrotate(H, -DHD1);%˳������ת90
H=FBNQX(H,DHD1);%��2����ɢ����
%%����
H=iarnold(H,DH1);%����
%%�滻����
H1=TIHUAN4X(H,R0,R2,R3,R4);

%% Sͨ������(��ɢ+�滻)
S=FBNQX(S,DHD2);%��һ����ɢ����
S=imrotate(S, -DHD2);%˳������ת90
S=FBNQX(S,DHD2);%�ڶ���
%%���ҽ���
S=iarnold(S,DH2);
%%�滻����
S1=TIHUAN4X(S,R0,R2,R3,R4);

%% �ϲ�
PP(:,:,1)=H1;
PP(:,:,2)=S1;
PP(:,:,3)=I1;%��ԭͼƬ
PP=abs(PP);%���������ʵ������
PP=hsi2rgb(PP);%��ԭͼƬת��ʽ
%figure,imshow(F);title('��ԭͼƬ��ʽת�����');% ��ʾͼ��
PP=ifftshift(PP);%�����ٸ���Ҷ�任���ֵ�������ͼ�񣬽���Ƶ���ƻ�
figure;imshow(PP);title('��ɫ��ԭ');% ��ʾͼ��
%% PSNR
II=imread('fxwh.jpg');% ����ͼ��  lena.jpg baboon.png airplane.png   peppers.png demo.jpg C256.png XZ.jpg eye.jpg skin.jpg
II=im2double(II);% ��ͼ��һ����ת��˫����
MSE = MSE(II,PP);
PSNR_TEST=psnr(II,PP);
ssimval = ssim(II,PP);
% R=II(:,:,1);
% G=II(:,:,2);
% B=II(:,:,3);
% R1=PP(:,:,1);
% G1=PP(:,:,2);
% B1=PP(:,:,3);
% PSNRr1 = psnr(R,R1) ;
% PSNRg1 = psnr(G,G1) ;
% PSNRb1 = psnr(B,B1) ;
% PSNR1=(PSNRr1+PSNRg1+PSNRb1)/3;
 
%% MSE
% dMSE_R = MSE(R,R1);
% dMSE_G = MSE(G,G1);
% dMSE_B = MSE(B,B1);