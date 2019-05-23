function si2=rotx(si)
%rotation axe x
[y, x, z]=size(si);
si2=zeros(z, x, y);

for i=1:z
    for ii=1:y
        for iii=1:x
         si2(i,iii,ii)=si(ii,iii,i);
        end
    end
end
end