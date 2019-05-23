function [rez, S] = surf_perso(I)

    I2 = I(:);
    
    neigb = [-1;
             +1;
             -size(I,1); 
             +size(I,1);
             -size(I,1)*size(I,2);
             +size(I,1)*size(I,2)];

    tmp = zeros(size(I2));
    for x = 1:size(I2,1)
        if I2(x) == 1
            neigb2 = x + neigb;

            ins = neigb2 > 0 & neigb2 <= size(I2,1);
            nbr_de_ngb = sum(ins);

            if nbr_de_ngb < size(neigb,1)
                tmp(x) = 0.5;
            else          
                neigb2((ins .* neigb2) == 0) = [];

                nbr_de_1 = sum(I2(neigb2));

                tmp(x) = nbr_de_1/nbr_de_ngb;
            end
        end
    end

    rez = zeros(size(I));
    rez(find(tmp>0 & tmp<1)) = 1;
    
    S = size(find(rez == 1),1);

end