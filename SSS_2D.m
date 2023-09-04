function [x,y]=SSS_2D(r,k)
% r=1;
% k=11;
x(1)=0.9;
y(1)=0.9;
%  	x(n+1)=sin(21./a*(y(n)+3)*k*x(n)*(1-k*x(n)));
%  	y(n+1)=sin(21./(a*(k*x(n+1)+3)*y(n)*(1-y(n))));
%  	x=sin(21./a*(y+3)*k*x*(1-k*x));
%   	y=sin(21./(a*(k*x+3)*y*(1-y))); 
    x=sin(21/(r*sin(y+3)*sin(pi*k*x)));
	y=sin(21/(r*sin(k*x+3)*sin(pi*y)));
end