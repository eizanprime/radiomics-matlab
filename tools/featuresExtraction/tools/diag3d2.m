function V3=diag3d2(I)
% clear all;
% p=load('testpl.mat');
% I=p.I2;
% I(2,3,3)=1;
%disp('ok');
[L,M,N]=size(I);

m=0;
k=0;
 
for z=1:N 

    for x=1:M       
      
        for y=1:L
            ii=x-1;         
            i=y-1;
            iii=z-1;
            n=0;
                       
            while i<L && ii<M && iii<N
                n=n+1;              
                i=i+1;
                ii=ii+1;
                iii=iii+1;
                if I(i,ii,iii)~=-1
                V(n)=I(i,ii,iii);
                end
                I(i,ii,iii)=-1;
            end
            if exist('V')
             m=m+1;
             V2{m}=V;
             clear V;
            end
        end
    end
    k=k+1;
    m=0;
    if exist('V2')
    V3{k}=V2;
    clear V2;
    end
end

end