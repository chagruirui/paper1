function I_dec= DeFibonacci_Q( C )
C=double(C);
[M1,~]=size(C);
k=M1/64;
dim1Dist = ones(1, k)*64;
%dim1Dist = ones(1, 8)*64;
Rf = mat2cell(C,dim1Dist,dim1Dist);%FEN分成64×64的大小
I_dec = cellfun(@fibonaccix, Rf,'UniformOutput',false);%对每个块进行相同的操作
I_dec=cell2mat(I_dec);
end
function I=fibonaccix(C)
[M,N]=size(C);
for i=1:2:M    
    for j=1:2:N
        A_= [1 -1;-1 2]; 
       %A_=[34 -55;-55 89];
        for n=1:M/2
        Cx=[C(i,j) C(i,j+1)           %小密文矩阵Cx
            C(i+1,j) C(i+1,j+1)];
        fz=Cx*A_^n;
        %fz=Cx*A_;
        D(i,j)=fz(1,1);
        D(i,j+1)=fz(1,2);
        D(i+1,j)=fz(2,1);
        D(i+1,j+1)=fz(2,2);
       end
    end
end
I=mod(D,1);
%I=uint8(I);
end
