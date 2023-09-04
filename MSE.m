function dMSE = MSE(P1,P2)
% ����mse(�������)
% P1:��һ��ͼ��
% P2:�ڶ���ͼ��
% dMSE:��������ͼ�񣬼���������

if (size(P1,1) ~= size(P2,1)) or (size(P1,2) ~= size(P2,2))
    error('P1 <> P2');
    dMSE = 0;
    return ;
end
P1=double(P1);
P2=double(P2);
M = size(P1,1);
N = size(P2,2);
d1 = 0;
for i = 1:M
    for j = 1:N
        d1 = d1 + (P1(i,j) - P2(i,j)).^2;
    end
end
dMSE = d1/(M*N);
return
