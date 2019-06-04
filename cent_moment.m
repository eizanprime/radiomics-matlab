function moments=cent_moment(vol3d, mask, momentvect)

 vol3d = vol3d.*mask; 
 moments = [];
 [m, n, r] = size(vol3d);
 m000=sum(sum(sum(vol3d)));
 
 
  m100=0;
  m010=0;
  m001=0;
    for x=1:m
        for y=1:n
            for z=1:r
            m100=m100+(x*vol3d(x,y,z));
            m010=m010+(y*vol3d(x,y,z));
            m001=m001+(z*vol3d(x,y,z));
        end 
        end
    end
   xx=m100./m000;
  yy=m010./m000;
  zz=m001./m000;
    
 for iter = 1:size(momentvect, 1);
  p = momentvect(iter, 1);
  q = momentvect(iter, 2);
  s = momentvect(iter, 3);
     
 mu_000 = m000;
 mu_pqs = 0;
      for ii=1:m
        x=ii-xx;
        for jj=1:n
            y=jj-yy;
            for kk=1:r
            z=kk-zz;
                         
            mu_pqs=mu_pqs + (x.^p).*(y.^q).*(z.^s).*(vol3d(ii,jj,kk));
       
            end
        end 
    end

    alpha=((p+q+s)/3)+1;
    n_pqs=mu_pqs./(m000.^alpha);
    moments(iter, 1) = n_pqs; 
 end
    
end
   
