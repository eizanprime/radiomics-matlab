function Iinv=inversez(I)
    [L,M,N]=size(I);
    Iinv=zeros(L,M,N);
    for i=1:N
        Iinv(:,:,i)=I(:,:,(N-i+1));
    end
end