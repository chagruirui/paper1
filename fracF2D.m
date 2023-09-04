%二维分数阶Fouirer变换
function F2D=fracF2D(f2D,ac,ar)
[M,N] = size(f2D);
F2D = zeros(M,N);
if ac == 0
   F2D = f2D;
else
   for k = 1:N
     F2D(:,k) = frft(f2D(:,k),ac);
   end;
end;
F2D = conj(F2D');
if ar ~= 0
    for k = 1:M
    F2D(:,k) = frft(F2D(:,k),ar);
    end;
end;
F2D = conj(F2D');
