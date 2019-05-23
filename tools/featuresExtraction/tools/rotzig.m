function si2=rotzig(si)
%rotation sur l'axe y
[y, x, z]=size(si);
si2=zeros(y, z, x);

for i=1:y
    for ii=1:x
        for iii=1:z
         si2(i,iii,ii)=si(i,ii,iii);
        end
    end
end
end