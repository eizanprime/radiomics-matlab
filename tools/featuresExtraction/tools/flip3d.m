function seq=flip3d(si)
seq=zeros(size(si,1), size(si,2), size(si,3));

for i=1:size(si,3)
    A=si(:,:,i);
    seq(:,:,i)=fliplr(A);
end
end