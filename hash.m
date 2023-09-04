%计算图像哈希值,用于图像比较搜索，计算距离
function h = hash(inp,meth) 
 % HASH - 使用任何一种将输入变量转换为消息摘要
% 几种常见的哈希算法 

inp=inp(:); 
% 将字符串和逻辑转换为 uint8 格式 
if ischar(inp) || islogical(inp) 
    inp=uint8(inp); 
else %将其他所有内容转换为 uint8 格式而不会丢失数据  
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
