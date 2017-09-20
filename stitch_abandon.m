function imout = stitch_abandon(im1, im2)

figure;
imshow(im1);
figure;
imshow(im2);

if size(im1,2) > size(im2,2)
    sizeX = size(im1,2);
else
    sizeX = size(im2,2);
end

if size(im1,1) > size(im2,1)
    sizeY = size(im1,1);
else
    sizeY = size(im2,1);
end

imout = zeros(sizeY, sizeX, 3);
for i = 1:sizeX
    for j = 1:sizeY
        if j > size(im1,1) 
            imout(j,i,:) = im2(j,i,:);
        end
        if j > size(im2,1)
            imout(j,i,:) = im1(j,i,:);
        end 
        if i > size(im1,2)
            imout(j,i,:) = im2(j,i,:);
        end
        if i > size(im2,2)
            imout(j,i,:) = im1(j,i,:);
        end
        if (j < size(im2,1)) && (j < size(im1,1)) && (i < size(im1,2)) ...
                && (i < size(im2,2))
            imout(j,i,:) = (im1(j,i,:) + im2(j,i,:))/2;
        end
    end
end

imout = uint8(imout);

figure;
imshow(imout);
end
