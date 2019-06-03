function n_pqs=cent_moment(p,q,s,im)

 [m n r] = size(im);
 m000=sum(sum(sum(im)));
 
  m100=0;
  m010=0;
  m001=0;
    for x=1:m
        for y=1:n
            for z=1:r
            m100=m100+(x*im(x,y,z));
            m010=m010+(y*im(x,y,z));
            m001=m001+(z*im(x,y,z));
        end 
        end
    end
   xx=m100./m000;
  yy=m010./m000;
  zz=m001./m000;
    
 mu_000 = m000;
 mu_pqs = 0;
      for ii=1:m
        x=ii-xx;
        for jj=1:n
            y=jj-yy;
            for kk=1:r
            z=kk-zz;
                         
            mu_pqs=mu_pqs + (x.^p).*(y.^q).*(z.^s).*(im(ii,jj,kk));
       
            end
        end 
    end

    alpha=((p+q+s)/3)+1;
    n_pqs=mu_pqs./(m000.^alpha);
end
   
