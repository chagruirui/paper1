function  I_enc= Fibonacci_Q( R )
R=double(R);
[M1,~]=size(R);
k=M1/64;
dim1Dist = ones(1, k)*64;
Rf = mat2cell(R,dim1Dist,dim1Dist);%FEN分成64×64的大小
I_enc = cellfun(@fibonacci, Rf,'UniformOutput',false);%对每个块进行相同的操作
I_enc=cell2mat(I_enc);
end
%% 
function I=fibonacci(R)
[M,N]=size(R);
for i=1:2:M         
     for j=1:2:N   %对2*2的子块Cx操作
        A=[2 1;1 1];
        % A=[n+1 n;n n-1];%Fibonacci_Q
       %A=[89 55;55 34];       
       for n=1:N/2
        Cx=[R(i,j) R(i,j+1)
            R(i+1,j) R(i+1,j+1)];  %子块定义
        fz=Cx*A^n;
        %fz=Cx*A;
        C(i,j)=fz(1,1);
        C(i,j+1)=fz(1,2);
        C(i+1,j)=fz(2,1);
        C(i+1,j+1)=fz(2,2);
        end
     end
end
I=mod(C,1);
%I=uint8(I);
end