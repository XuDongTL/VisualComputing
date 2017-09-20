function imout = transformImage(im, H)

%size of input image: x is horizontal, y is vertical
dimX = size(im, 2);
dimY = size(im, 1);

% find corners to know size of transfromed image
corners = [1,1; 1,dimY; dimX,dimY; dimX,1];
trdCorner = H * [corners, ones(4,1)]';
minX = 1; minY = 1; maxX = 1; maxY =1;
for i = 1:size(trdCorner,2)
    trdCorner(1,i) = round(trdCorner(1,i) / trdCorner(3,i));
    trdCorner(2,i) = round(trdCorner(2,i) / trdCorner(3,i));
    trdCorner(3,i) = round(trdCorner(3,i) / trdCorner(3,i));
    if trdCorner(1,i) < minX 
        minX = trdCorner(1,i);
    end
    if trdCorner(1,i) > maxX
        maxX = trdCorner(1,i);
    end
    if trdCorner(2,i) < minY 
        minY = trdCorner(2,i);
    end
    if trdCorner(2,i) > maxY
        maxY = trdCorner(2,i);
    end
end
imout= zeros(maxY,maxX,3);
% calculate how many need to shift to allow transformed image inside box
shiftX = 1 - minX;
shiftY = 1 - minY;


for x = 1:maxX+shiftX
    for y = 1:maxY+shiftY
        back = H\[x-shiftX; y-shiftY; 1];
        scale = 1/back(3);
        orgX = round(back(1)*scale);
        orgY = round(back(2)*scale);
        if orgX > 0 && orgY > 0 && orgX <= dimX && orgY <= dimY
            imout(y,x,:) = im(orgY,orgX,:); 
        end
    end
end

imout = uint8(imout);
%figure;
%plot(xv,yv);
end

