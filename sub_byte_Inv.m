%s盒子解密
function Img_array = sub_byte_Inv(value,Sbox)
value=round(value*10000);%四舍五入
[rowj,colj] = find(Sbox==value);
% if (rowj==1)&(colj==1)
%     Img_array=10000;
% else
Img_array = (rowj-1)+(colj-1)*100;
% end
Img_array=Img_array./10000;
end