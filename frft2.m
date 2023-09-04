function [out] = frft2(matrix,angles)
temp = zeros(size(matrix));
out = zeros(size(matrix));
for i = 1:size(matrix,1)
    y = matrix(i,:);
    temp(i,:) = frft(y,angles(1));
end
for i = 1:size(matrix,2)
    y = temp(:,i);
    out(:,i) = frft(y,angles(2));
end

