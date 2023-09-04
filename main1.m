%将RGB图像变为HSI图像后，把傅里叶变换改为分数域傅里叶变换时，不要动fftshift()和ifftshift()    (把fft和ifft改了就ok)
%2022.6.20
%单通道
clc;
clear;
close all;
addpath pingjia;
P=imread('test4.jpg');% 载入图像  lena.jpg baboon.png airplane.png   peppers.png   demo.jpg  C256.png XZ.jpg eye.jpg  fxwh.jpg

%  % %直方图图像直方图卡方检验
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
% figure,imshow(R);title('R通道原始');% 显示图像
% figure,imshow(G);title('G通道原始');% 显示图像
% figure,imshow(B);title('B通道原始');% 显示图像
% figure();imhist(R(:),256);set(gca,'fontsize',18);
% figure();imhist(G(:),256);set(gca,'fontsize',18);
% figure();imhist(B(:),256);set(gca,'fontsize',18);
%P=im2double(P);% 将图归一化，转换双精度
[M,N,color]=size(P);%求图像长宽
figure;imshow(P);title('彩色原始图片');% 显示图像
P=im2double(P);
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
% figure();imhist(H(:),256);set(gca,'fontsize',18);%ylim([0,3000]);
% figure();imhist(S(:),256);set(gca,'fontsize',18);%ylim([0,1200]);
% figure();imhist(I(:),256);set(gca,'fontsize',18);
%% 根据明文计算混沌系统密钥
HH= hash(H,'SHA-512');
SS= hash(S,'SHA-512');
HS= [HH;SS];
%7b94d9edb4c26c9baefc83879172a51742a473fffec5fad9d7bc116750b142dd511353fefef8285386fcac36b08cd3e4bfaea82b6c6b80569c70d8355e1bb750
%2919c5e16b17f8fa71a6dcddc5b5a828b24735b90f8c11a140a932cabec9fafa0df68ba85d927a31f5aea9568dd761ae47db0ba40f27d678c7ac97cb98424686
%保存
% fid=fopen('Outputdata.txt','wt');
% for i=1:2
% fprintf(fid,'%s \n',HM(i,:));
% end
%D = pdist(HS, 'hamming');%汉明距离
DD1= pdist(HS,'euclidean');%  欧式距离
DD1=floor(DD1*10^4)/10^4;     %保留4位小数
DD2= pdist(HS, 'chebychev');% 切比雪夫距离 
%DD2=mod(floor(DD2),192);
DD2=floor(DD2*10^4)/10^4;     %保留4位小数
R0=DD1+DD2;%计算密钥
R2=DD1-DD2;
R3=DD1*DD2;
R4=DD1/DD2;
%% 混沌系统生成四个随机矩阵
K= [DD1,DD2,R0,R2,R3,R4];%随机数 随机设置
[X,Y,R,W] = PRICKKey(M,N,K);
 n1=exp(2*1j*pi*X);%掩码矩阵生成
 n2=exp(2*1j*pi*Y);%要俩
%  n3=exp(2*1j*pi*R);%掩码矩阵生成
%  n4=exp(2*1j*pi*W);%要俩

%% 对H进行处理(置乱+扩散)
%替换
H=TIHUAN4(H,R0,R2,R3,R4);
%  figure();imhist(H(:),256);
%  yH=ENTROPY(floor(H.*255));
%%置乱
DH1=sum(H(:)+DD1);%计算置乱轮数
DH1=mod(round(DH1),96)+48;
H=arnold(H,DH1);

%%扩散
DHD1=(mod(floor(DD1),4)+1)*90;%计算旋转角度
H=FBNQ(H,DHD1);%扩散
H=imrotate(H,DHD1);%逆时针旋转90°
H=FBNQ(H,DHD1);
% figure();imhist(H(:),256);
% yH=ENTROPY(floor(H.*255));
%  H_SHANG=floor(H.*255);
%  yH=ENTROPY(H_SHANG);
%  H=abs(H);
% figure,imshow(H);title('H通道加密');% 显示图像
%  figure();hist(H(:),256);set(gca,'fontsize',18);
%% S通道加密 （替换+扩散）
S=TIHUAN4(S,R0,R2,R3,R4);
% figure();imhist(S(:),256);
% yH=ENTROPY(floor(S.*255));
%置乱
DH2=sum(S(:)+DD2);%计算置乱轮数
DH2=mod(round(DH2),96)+48;
S=arnold(S,DH2);%置乱
%扩散
DHD2=(mod(floor(DD2),4)+1)*90;%计算旋转角度
S=FBNQ(S,DHD2);%扩散

S=imrotate(S, DHD2);%逆时针旋转90°
S=FBNQ(S,DHD2);%再扩散一轮
% figure();imhist(S(:),256);
% yS=ENTROPY(floor(S.*255));
%  S_SHANG=floor(S.*255);
% yS=ENTROPY(S_SHAN);
% figure,imshow(S);title('S通道加密');% 显示图像
%  S2=abs(S);
%  figure();hist(S2(:),256);set(gca,'fontsize',18);
%% 对I通道进行预处理
%%%%%%处理I通道xian置乱
DH3=sum(DD1+DD2);
DH3=mod(round(DH3),96)+48;
I=arnold(I,DH3);%arnold置乱算法   %n置乱次数a,b是参数 D3切比雪夫距离
%% 双随机相位编码加密
%%%%%%
DHD3=mod(floor(DH3),4)*90;%计算旋转角度
%I=ifft2(fft2(sqrt(I).*n1).*n2);
a=1;
b=1;
  n3=exp(2*1j*pi*H);%掩码矩阵生成
  n4=exp(2*1j*pi*S);%要俩
I=MYFRFT2(I,n1,n3,DH3,a,b);
I=imrotate(I, DHD3);%逆时针旋转90°
I=MYFRFT2(I,n2,n4,DH3,a,b);
%I=ifft2(fft2(I.*n3).*n4);%双随机相位编码加密

%% 最后DRPE加密
%I=ifft2(fft2(I.*exp(2i*pi*H)).*exp(2i*pi*S));%基于双相位的单通道彩色图像加密
%% 测试
%   I11=abs(I);
%  I_SHANG=floor(I11.*255);
%  yI=ENTROPY(I_SHANG);
%figure,imshow(I11);title('I通道加密');% 显示图像
%  figure();hist(I11(:),256);set(gca,'fontsize',18);
%ZFT=ImCoef(I11.*255,2000);
%剪切
% I(148:180,148:180)=0.0001;
% %116:180,116:180
% %48:180,48:180
% figure,imshow(abs(I));title('I通道加密');% 显示图像
%% 测试
%  I=ifft2(fft2(sqrt(I).*n3).*n4);
% %I=fracF2D(fracF2D(I.*n1,1,1).*n2,-1,-1);%双随机相位编码加密
%  figure,imshow(I);title('I通道加密');% 显示图像
%  Is=real(I);%提取实部
%  Ix=imag(I);%提取虚部
%  If=angle(I);%提取幅角
%  Ixw=log(angle(I)*180/pi);%获得相位谱
%  Izf= log(abs(I));%获得幅度谱
% Im=abs(I);%模
% IC = Im.*exp(j*(If));%双谱重构
% %IC = abs(I).*exp(j*(angle(I)));%双谱重构
%% 合并三通道 复原加密图
C(:,:,1)=H;
C(:,:,2)=S;
C(:,:,3)=I;%复原图片
 C=abs(C);%复数矩阵变实数矩阵
%  C=hsi2rgb(C);
% C=ifftshift(C);
figure;
imshow(C);title('最后加密结果');% 显示图像

C=floor(C.*255);
C=double(C);
%% 直方图
%hist3(C);
 % %直方图图像直方图卡方检验
H1=double(C(:,:,1));
S1=double(C(:,:,2));
I1=double(C(:,:,3));
H_jiami=kafangjianyan(H1);
S_jiami=kafangjianyan(S1);
I_jiami=kafangjianyan(I1);
% figure();hist(G1(:),256);set(gca,'fontsize',18);
% figure();hist(B1(:),256);set(gca,'fontsize',18);
%% % % %% 相关性系数
% r_R=ImCoef(R1.*255,2000);
% r_G=ImCoef(G1.*255,2000);
% r_B=ImCoef(B1.*255,2000);
%% 剪切
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
%  imshow(abs(CC1));title('剪切结果');% 显示图像
%% 添加噪声
%I=imnoise(I, 'gaussian', 0, 0.001);%方差为0.01的高斯噪声
%I=imnoise(I, 'salt & pepper', 0.005);%椒盐噪声
%I=imnoise(I, 'speckle');%添加方差为0.04的乘性噪声
%I=awgn(I,30,'measured','dB');%添加功率为原始信号x功率的1/10的噪声，具体大小取决于x
%% 解密第一步
% H(116:180,116:180)=0;
% S(116:180,116:180)=0;
% I(116:180,116:180)=0;
%I=(ifft2(fft2(I).*exp(-2i*pi*S)).*exp(-2i*pi*H));
%% 双随机相位编码解密
%解码要用共轭相位掩模
 n1=conj(n1);% 指数上加了个'-'，相当于求共轭
 n2=conj(n2);
 n3=conj(n3);% 指数上加了个'-'，相当于求共轭
 n4=conj(n4); 

I=MYFRFT2X(I,n2,n4,DH3,a,b);
I=imrotate(I, -DHD3);%顺势正旋转90
I=MYFRFT2X(I,n1,n3,DH3,a,b);
  %I=(ifft2(fft2(I).*n4).*n3);%双随机相位解码解密
   % I=(ifft2(fft2(I).*n2).*n1).^2;%双随机相位解码解密
I1=iarnold(I,DH3);%反置乱
%figure;imshow(I);title('I通道解码结果');% 显示图像
%% H通道和S通道信息解密（扩散+置乱）
%   C1=fftshift(C);
%   C1=rgb2hsi(C1);
%   C1=complex(C1);%将矩阵转换为复数矩阵
%   H=CC1(:,:,1);%H通道
%   S=CC1(:,:,2);%S通道
%   I=CC1(:,:,3);%I通道
H=FBNQX(H,DHD1);%第一轮扩散解密
H=imrotate(H, -DHD1);%顺势正旋转90
H=FBNQX(H,DHD1);%第2轮扩散解密
%%置乱
H=iarnold(H,DH1);%置乱
%%替换解密
H1=TIHUAN4X(H,R0,R2,R3,R4);

%% S通道解密(扩散+替换)
S=FBNQX(S,DHD2);%第一轮扩散解密
S=imrotate(S, -DHD2);%顺势正旋转90
S=FBNQX(S,DHD2);%第二轮
%%置乱解密
S=iarnold(S,DH2);
%%替换解密
S1=TIHUAN4X(S,R0,R2,R3,R4);

%% 合并
PP(:,:,1)=H1;
PP(:,:,2)=S1;
PP(:,:,3)=I1;%复原图片
PP=abs(PP);%复数矩阵变实数矩阵
PP=hsi2rgb(PP);%复原图片转格式
%figure,imshow(F);title('复原图片格式转换结果');% 显示图像
PP=ifftshift(PP);%反快速傅立叶变换部分调整整幅图像，将零频点移回
figure;imshow(PP);title('彩色复原');% 显示图像
%% PSNR
II=imread('fxwh.jpg');% 载入图像  lena.jpg baboon.png airplane.png   peppers.png demo.jpg C256.png XZ.jpg eye.jpg skin.jpg
II=im2double(II);% 将图归一化，转换双精度
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