%s盒子加密
function Img_Sbox = sub_byte(Sbox,value)
value=round(value.*10000);
%value = str2double(dec2base(value,10,4));
% b1=mod(value,10);%个
% b2=mod(floor(value/10),10);%十
% b3=mod(floor(value/100),10);%百
% b4=mod(floor(value/1000),10);%千
b1=mod(value,10);%个
b2=mod(floor(value/10),10);%十
b3=mod(floor(value/100),10);%百
b4=mod(floor(value/1000),10);%千
% b5=mod(floor(value/10000),10);%w万
% if b5==0
  row=1+b1*1+b2*10;
  col=1+b3*1+b4*10;
% else
%     row=1;
%     col=1;
% end
%% 用s盒子替换
Img_Sbox = Sbox(row,col);
Img_Sbox=Img_Sbox./10000;
end