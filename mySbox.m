function Sbox=mySbox(x0,y0)
%% ����S����
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
% y = uint8(y*255);  %��x��y�зֱ�ѡ����������Ϊn=256������A��B
s = abs(x-y);  %��������A��B֮��Ĳ�ֵ
%C=C(1:10000);
[D,index] = sort(s,'descend');  %������C��Ԫ�ذ���������ȡ����ֵ
box1 = index-1;  %����������D������C��ÿһ��Ԫ�ص���λ��
%S = E-1;  %����ֵ��0��255������S
%box1=box1./10000;
%Sbox = uint8(reshape(E,100,100));  %������Sת��ΪM��N����
Sbox = reshape(box1,100,100);  %������Sת��ΪM��N����
%Sbox=arnold(Sbox,75);
end