
function imageRes = imresize3D(image, dim, methode)

    tmpImage = zeros(dim(1), dim(2), size(image,3));
    for iSli = 1:size(image,3)       
        tmpImage(:,:,iSli) = imresize(image(:,:,iSli), [dim(1), dim(2)], 'Method', methode);        
    end
    
    imageRes = zeros(dim');
    for iSli = 1:dim(1)        
        tmp = tmpImage(iSli,:,:);
        tmp2 = reshape(tmp,size(tmp,2),size(tmp,3));   
        tmp3 = imresize(tmp2, [dim(2), dim(3)], 'Method', methode);    

        imageRes(iSli,:,:) = tmp3;
    end  
end