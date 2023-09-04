%将RGB图像变为HSI图像后，把傅里叶变换改为分数域傅里叶变换时，不要动fftshift()和ifftshift()    (把fft和ifft改了就ok)
clc;
clear;
close all;
I=imread('lena.jpg');% 载入图像 baboon.bmp  lena.jpg
P=im2double(I);% 将图归一化，转换双精度
% R=P(:,:,1);
% G=P(:,:,2);
% B=P(:,:,3);
% figure();hist(R(:),256);set(gca,'fontsize',18);xlim([0 1]);
% figure();hist(G(:),256);set(gca,'fontsize',18);xlim([0 1]);
% figure();hist(B(:),256);set(gca,'fontsize',18);xlim([0 1]);
[M,N,color]=size(P);%求图像长宽
figure;imshow(P);title('彩色原始图片');% 显示图像
P=fftshift(P);%快速傅立叶变换部分调整整幅图像，将零频点移到频谱的中间
%figure,imshow(P);title('通过快速傅里叶变换零频点居中');% 显示图像
%% RGB转HSI
AA=rgb2hsi(P);%RGB转HSI
%%%%%%分通道
H=AA(:,:,1);%H通道
S=AA(:,:,2);%S通道
I=AA(:,:,3);%I通道
% figure,imshow(H);title('H通道原始');% 显示图像
% figure,imshow(S);title('S通道原始');% 显示图像
% figure,imshow(I);title('I通道原始');% 显示图像
%% 根据明文计算混沌系统密钥
H1= hash(H,'SHA-512');
S2= hash(S,'SHA-512');
HS= [H1;S2];
%保存
% fid=fopen('Outputdata.txt','wt');
% for i=1:2
% fprintf(fid,'%s \n',HM(i,:));
% end
%D = pdist(HM, 'hamming');%汉明距离
D1= pdist(HS,'euclidean');%  欧式距离
D1=floor(D1*10^4)/10^4;     %保留4位小数
D2= pdist(HS, 'chebychev');% 切比雪夫距离 
D2=mod(floor(D2),192);
R1=D1+D2;%计算密钥
R2=D1-D2;
R3=D1*D2;
R4=D1/D2;
%% 混沌系统生成四个随机矩阵
K= [D1,D2,R1,R2,R3,R4];%随机数 随机设置
[X,Y,R,W] = PRICKKey(M,N,K);
 n1=exp(2*j*pi*X);%掩码矩阵生成
 n2=exp(2*j*pi*Y);%要俩
 n3=exp(2*j*pi*R);%掩码矩阵生成
 n4=exp(2*j*pi*W);%要俩
%% 对H和S通道进行处理
%% h
rounds=1; 
DH1=sum(H(:)+D1);%计算置乱轮数
DH1=mod(floor(DH1),192);
H=arnold(H,DH1);%置乱

H=FBNQ(H,rounds);%扩散
DHD1=mod(DH1,4)*90;
H=imrotate(H, DHD1);%逆时针旋转90°
H=FBNQ(H,rounds);
%figure,imshow(H);title('H通道加密');% 显示图像
%  H=abs(H);
%  figure();hist(H(:),256);set(gca,'fontsize',18);
 %% s
DH2=sum(S(:)+D2);%计算置乱轮数
DH2=mod(floor(DH2),192);
S=arnold(S,DH2);%置乱

S=ifft2(fft2(S.*n1).*n2);%双随机相位编码加密
%figure,imshow(S);title('S通道加密');% 显示图像
%  S=abs(S);
%  figure();hist(S(:),256);set(gca,'fontsize',18);
%% 对I通道进行预处理
%%%%%%处理I通道xian置乱
DH3=sum(abs(I(:))+D1+D2);
DH3=mod(floor(DH3),192);
I=arnold(I,DH3);%arnold置乱算法   %n置乱次数a,b是参数 D3切比雪夫距离
%% 双随机相位编码加密
I=ifft2(fft2(sqrt(I).*n3).*n4);
I=ifft2(fft2(I.*exp(2i*pi*H)).*exp(1i*S));
%I=ifft2(fft2(sqrt(I).*exp(2i*pi*H)).*exp(1i*S));%基于双相位的单通道彩色图像加密
figure,imshow(abs(I));title('I通道加密');% 显示图像
%% 相关性分析
  Is=abs(I);%提取振幅
  Ix=angle(I);%提取相位
  figure;
  hist(Is(:),256);set(gca,'fontsize',18);
    figure;
  hist(Ix(:),256);set(gca,'fontsize',18);
 % % %% 相关性系数
r_S=ImCoef(Is.*255,2000);
r_X=ImCoef(Ix.*255,2000);

% r_R=ImCoef(R1.*255,2000);
% r_G=ImCoef(G1.*255,2000);
% r_B=ImCoef(B1.*255,2000);
% % %% 信息熵
% xinxishangS=ENTROPY(Is);
% xinxishangX=ENTROPY(Ix);
% y_R=ENTROPY(R11);
% y_G=ENTROPY(G11);
% y_B=ENTROPY(B11);
 %% 剪切
%I=awgn(I,55);%向图像中添加20dbw的高斯噪声
% I(116:180,116:180)=1;
% figure;
% imshow(abs(I));title('剪切结果');% 显示图像
%%  噪声攻击
%I=imnoise(I, 'gaussian', 0, 0.01);%方差为0.01的高斯噪声
%I=imnoise(I, 'poisson');%添加泊松噪声
%I=imnoise(I, 'salt & pepper', 0.005);
%I=imnoise(I, 'speckle');%添加方差为0.04的乘性噪声
%  I=abs(I);
%  figure();hist(I(:),256);set(gca,'fontsize',18);
%% 双随机相位编码解密
%解码要用共轭相位掩模
 n1=conj(n1);% 指数上加了个'-'，相当于求共轭
 n2=conj(n2);
 n3=conj(n3);% 指数上加了个'-'，相当于求共轭
 n4=conj(n4); 
%I=(ifft2(fft2(I).*exp(-1i*S)).*exp(-2i*pi*H)).^2;
I=(ifft2(fft2(I).*exp(-1i*S)).*exp(-2i*pi*H));
I=(ifft2(fft2(I).*n4).*n3).^2;%双随机相位解码解密
I=iarnold(I,DH3);%反置乱
%% H通道和S通道信息解密
%   C1=fftshift(C);
%   C1=rgb2hsi(C1);
%   C1=complex(C1);%将矩阵转换为复数矩阵
%   H=C1(:,:,1);%H通道
%   S=C1(:,:,2);%S通道
%   I=C1(:,:,3);%I通道
%% S解码
S=ifft2(fft2(S).*n2).*n1;%双随机相位解码解密
S=iarnold(S,DH2);

%% H解码
H=FBNQX(H,rounds);%第一轮扩散解密
H=imrotate(H, -DHD1);%顺势正旋转90
H=FBNQX(H,rounds);%第2轮扩散解密
H=iarnold(H,DH1);%置乱

P1(:,:,1)=H;
P1(:,:,2)=S;
P1(:,:,3)=I;%复原图片
P1=abs(P1);%复数矩阵变实数矩阵
P1=hsi2rgb(P1);%复原图片转格式
%figure,imshow(F);title('复原图片格式转换结果');% 显示图像
P1=ifftshift(P1);%反快速傅立叶变换部分调整整幅图像，将零频点移回
figure;imshow(P1);title('彩色复原');% 显示图像
%% PSNR
I=imread('lena.jpg');% 载入图像 baboon.bmp  lena.jpg
I=im2double(I);% 将图归一化，转换双精度
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