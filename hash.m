%����ͼ���ϣֵ,����ͼ��Ƚ��������������
function h = hash(inp,meth) 
 % HASH - ʹ���κ�һ�ֽ��������ת��Ϊ��ϢժҪ
% ���ֳ����Ĺ�ϣ�㷨 

inp=inp(:); 
% ���ַ������߼�ת��Ϊ uint8 ��ʽ 
if ischar(inp) || islogical(inp) 
    inp=uint8(inp); 
else %��������������ת��Ϊ uint8 ��ʽ�����ᶪʧ����  
    inp=typecast(inp,'uint8'); 
end 

% verify hash method, with some syntactical forgiveness: 
meth=upper(meth); 
switch meth 
    case 'SHA1' 
        meth='SHA-1'; 
    case 'SHA256' 
        meth='SHA-256'; 
    case 'SHA384' 
        meth='SHA-384'; 
    case 'SHA512' 
        meth='SHA-512'; 
    otherwise 
end 
algs={'MD2','MD5','SHA-1','SHA-256','SHA-384','SHA-512'}; 
if isempty(strmatch(meth,algs,'exact')) 
    error(['Hash algorithm must be ' ... 
        'MD2, MD5, SHA-1, SHA-256, SHA-384, or SHA-512']); 
end 

% create hash 
x=java.security.MessageDigest.getInstance(meth); 
x.update(inp); 
h=typecast(x.digest,'uint8'); 
h=dec2hex(h)'; 
if(size(h,1))==1 % remote possibility: all hash bytes  128, so pad: 
    h=[repmat('0',[1 size(h,2)]);h]; 
end 
h=lower(h(:)'); 

return
