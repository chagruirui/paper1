% %���Ի���ϵͳ
% clear;
% close all;
% clc;
% 
% P=imread('lena.jpg');% ����ͼ��
% figure;
% imshow(P);
% 
% % P=double(P);
% % R=P(:,:,1);
% % G=P(:,:,2);
% % B=P(:,:,3);
% % %  % %��Ϣ��
% %    H1=ENTROPY(R);
% %    H2=ENTROPY(G);
% %    H3=ENTROPY(B);
% % %ֱ��ͼ   
% % figure();hist(R(:),256);set(gca,'fontsize',18);xlim([0 255]);
% % figure();hist(G(:),256);set(gca,'fontsize',18);xlim([0 255]);
% % figure();hist(B(:),256);set(gca,'fontsize',18);xlim([0 255]);
% %  %����Բ��Գ���
% %  r1=ImCoef(R,2000);
% %  r2=ImCoef(G,2000);
% %  r3=ImCoef(B,2000);
%  %% ����
% C=main_JIA(P);
% figure;
% imshow(C);
% % C=C.*255;
% % C=double(C);
% % R1=C(:,:,1);
% % G1=C(:,:,2);
% % B1=C(:,:,3);
% % %ֱ��ͼ
% % figure();hist(R1(:),256);set(gca,'fontsize',18);xlim([0 255]);
% % figure();hist(G1(:),256);set(gca,'fontsize',18);xlim([0 255]);
% % figure();hist(B1(:),256);set(gca,'fontsize',18);xlim([0 255]);
% % %  % %��Ϣ��
% %    H11=ENTROPY(R1);
% %    H12=ENTROPY(G1);
% %    H13=ENTROPY(B1);
% %   %����Բ��Գ���
% %  r11=ImCoef(R1,2000);
% %  r12=ImCoef(G1,2000);
% %  r13=ImCoef(B1,2000);
%  %% ����
% H1='a77f2ebc86e504771cf45ca8e91d06578fa302a0febf5947b9784b231af10af2e1b5f317a5be04d6dd69ff7326f71f56815a64f7ed70bb91b6959d3ff8b9e0d4';
% S2='22d95024a7b519df8a8b2d031ff9028c281a117e42b74985813df164ee54eca5f2ade0049be02790698dfe562b032232fe0400b4f78fd02a27111800539edae9';
% P1=main_JIE(C,H1,S2);
% figure;
% imshow(P1);
% 
% % %%����ϵͳ
K= [45.4563,344.7865,99,164,79,214];%����� �������
[X,Y,R,W] = PRICKKey(64,64,K);
% %x=unifrnd(0,1,4,4);
% % %  % %��Ϣ��
% %    H11=ENTROPY(R1);
% %    H12=ENTROPY(G1);
% %    H13=ENTROPY(B1);
% % %ԭͼ��ֱ��ͼ
% % P=double(P);
% % figure(3);hist(P(:),256);set(gca,'fontsize',18);xlim([0 255]);
% % %����ͼ���ֱ��ͼ
% % C=double(C);
% % figure(4);hist(C(:),256);set(gca,'fontsize',18);xlim([0 255]);
% % %ͼ��ֱ��ͼ��������
% % [M,N]=size(P);g=M*N/256;
% % fp1=hist(P(:),256);
% % chai1=sum((fp1-g).^2)/g;
% % fc1=hist(C(:),256);
% % chai2=sum((fc1-g).^2)/g;
% % %����Բ��Գ���
% % r1=ImCoef(P,2000);%P����
% % r2=ImCoef(C,2000);%C������
