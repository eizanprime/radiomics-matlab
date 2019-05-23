function Iv=diag3d3(I)
[L,M,N]=size(I);

for z=1:N
    n=1;
    for x=-(L-1):(M-1)        
        DIA{z,n}=diag(I(:,:,z),x);
        n=n+1;
    end
    
end

[M, N]=size(DIA);

for i=1:N
    %[aa,bb]=size(DIA{1,i});
    %I2=zeros(M,aa);
    I2=[];
    for ii=1:M
        lig=rot90(DIA{ii,i});
        I2=[I2;lig];        
    end

    [l,m]=size(I2);

        nn=0;
        if m>1
            for k=-(l-1):(m-1)
                
                d=diag(I2,k);            
                nn=nn+1;             
                Iv{i}{nn}=rot90(d);

            end
        else
            for k=1:l
            nn=nn+1;
            d=I2(k);
            Iv{i}{nn}=rot90(d);
            end
        end
end

%[M, N]=size(V3);

    
% for a=1:M
%     for x=1:N
%         V3{x}=[];
%         [xx,yy]=size(DIA{a,x});        
%         b=1;
% 
%         for i=a:xx
% 
%             v=DIA{i,x}(b);          
%             V3{x}=[V3{x}, v];
%             b=b+1;
%         end
% 
%     end
%     
%     V4{a}=V3;
%     clear V3;
% end
    

end