function out=arnold(img,n)
%n置乱次数
%a,b是参数
[h, w]=size(img);
a=11;
b=7;
N=h;

imgn=zeros(h,w);
for i=1:n
    for y=1:h
        for x=1:w           
            xx=mod((x-1)+b*(y-1),N)+1;
            yy=mod(a*(x-1)+(a*b+1)*(y-1),N)+1;        
            imgn(yy,xx)=img(y,x);                
        end
    end
   out=imgn;
end
