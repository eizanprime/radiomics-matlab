function [seq]=GLRLMseq(SI,HHHH)
    
    switch HHHH     
        case 0
        case '0  0  1'
            % disp('ok1')
            dir='0 0 1';
            seq=GLR3D_001(SI);
        case '0  1  0'
            % disp('ok2')
            dir='0 1 0';
            seq=GLR3D_010(SI);
        case '1  0  0'
            % disp('ok3')
            dir='1 0 0';
            seq=GLR3D_100(SI);
        case '1  1  0'
            % disp('ok4')
            dir='1 1 0';
            seq=GLR3D_110(SI);
        case '1 -1  0'
            % disp('ok5')
            dir='1 -1 0';
            seq=GLR3D_120(SI);
        case '-1  0  1'
            % disp('ok6')
            dir='-1 0 1';
            seq=GLR3D_201(SI);
        case '0  1  1'
            % disp('ok7')
            dir='0 1 1';
            seq=GLR3D_011(SI);
        case '0 -1  1'
            % disp('ok8')
            dir='0 -1 1';
            seq=GLR3D_021(SI);
        case '1  1  1'
            % disp('ok9')
            dir='1 1 1';
            seq=GLR3D_111(SI);
        case '1 -1  1'
            % disp('ok10')
            dir='1 -1 1';
            seq=GLR3D_121(SI);
        case '1  1 -1'
            % disp('ok11')
            dir='1 1 -1';
            seq=GLR3D_112(SI);
        case '1  0  1'
            % disp('ok12')
            dir='1 0 1';
            seq=GLR3D_101(SI);
        case '1 -1 -1'
            % disp('ok13')
            dir='1 -1 -1';
            seq=GLR3D_122(SI);
        otherwise
            disp('Only 13 directions supported')           
    end
end

function Iv001=GLR3D_001(I)
    %[0 0 1] = [0 0 -1]
    [L,M,N]=size(I);
    for j=1:L
        for jj=1:M
            Iv001{j}{jj}=rotzig(I(j,jj,:));
        end
    end  
end

function Iv010=GLR3D_010(I)
    %0-0 degree [0 1 0] = [0 -1 0]
    [L,M,N]=size(I);
    for jjj=1:N
        for j=1:L
            Iv010{jjj}{j}=I(j,:,jjj);
        end
    end
end

function Iv011=GLR3D_011(I)
    %[0 1 1] = [0 -1 -1]
    I2=rotx(I);
    [L,M,N]=size(I2);
    for j=1:N
        nn=0;
        for k=-(L-1):(M-1)
            d=diag((I2(:,:,j)),k);        
            nn=nn+1;
            Iv011{j}{nn}=rot90(d);
        end
    end    
end

function Iv021=GLR3D_021(I)
    %[0 -1 1] = [0 1 -1]
    I2=rotx(I);
    [L,M,N]=size(I2);
    for j=1:N
        nn=0;
        for k=-(L-1):(M-1)
            d=diag(fliplr(I2(:,:,j)),k);        
            nn=nn+1;
            Iv021{j}{nn}=rot90(d);
        end
    end
end

function Iv100=GLR3D_100(I)
    %90-0 degree [1 0 0] = [-1 0 0]
    [L,M,N]=size(I);
    for jjj=1:N
        for jj=1:M
            Iv100{jjj}{jj}=rot90(I(:,jj,jjj));
        end
    end  
end

function Iv101=GLR3D_101(I)
    %[1 0 1] = [-1 0 -1]
    I2=rotzig(I);
    [L,M,N]=size(I2);
    for j=1:N
        nn=0;
        for k=-(L-1):(M-1)
            d=diag(I2(:,:,j),k);        
            nn=nn+1;
            Iv101{j}{nn}=rot90(d);
        end
    end    
end

function Iv110=GLR3D_110(I)
    %4 directions plan (2D) 
    %45-0 degree [1 1 0] = [-1 -1 0]
    [L,M,N]=size(I);
    for j=1:N
        nn=0;
        for k=-(L-1):(M-1)
            d=diag(I(:,:,j),k);        
            nn=nn+1;
            Iv110{j}{nn}=rot90(d);
        end
    end
end

function Iv111=GLR3D_111(I)
    %[1 1 1]=[-1 -1 -1]
    [L,M,N]=size(I);
    Iv111=diag3d3(I);
end

function Iv112=GLR3D_112(I)
    %[1 1 -1] = [-1 -1 1]
    Iinv=inversez(I);
    [L,M,N]=size(Iinv);
    Iv112=diag3d3(Iinv);    
end

function Iv120=GLR3D_120(I)
    %135-0 degree [1 -1 0] =[-1 1 0]
    [L,M,N]=size(I);
    for j=1:N
        nn=0;
        for k=-(L-1):(M-1)
            d=diag(fliplr(I(:,:,j)),k);        
            nn=nn+1;
            Iv120{j}{nn}=rot90(d);
        end
    end   
end

function Iv121=GLR3D_121(I)
    %[1 -1 1] = [-1 1 -1]
    I2=flip3d(I);
    [L,M,N]=size(I2);
    Iv121=diag3d3(I2);    
end

function Iv122=GLR3D_122(I)
    %[1 1 -1] = [-1 -1 1]
    Iinv=inversez(I);
    Iinv=flip3d(Iinv);
    [L,M,N]=size(Iinv);
    Iv122=diag3d3(Iinv);   
end

function Iv201=GLR3D_201(I)
    %[-1 0 1] = [1 0 -1]
    I2=rotzig(I);
    [L,M,N]=size(I2);
    for j=1:N
        nn=0;
        for k=-(L-1):(M-1)
            d=diag(fliplr(I2(:,:,j)),k);        
            nn=nn+1;
            Iv201{j}{nn}=rot90(d);
        end
    end    
end
