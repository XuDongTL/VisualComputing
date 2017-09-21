function imSti = stitchImages(images, H)
% STITCHIMAGES stitch images based on homography H
%    images should be n * 1 cell, each contains one image
%    H should be n * 1 cell, each contails one homography H wrt first image

n1 = size(images, 1);
n2 = size(H, 1);
if n1~= n2
    error('numbers of images and H are different');
end

outBox = ones(1,4);

for i=1:n1
    [h, w, ~] = size(images{i});
    imageBox = H{i} * [[1;1;1], [w;1;1], [1;h;1], [w;h;1]];
    x = imageBox(1, :) ./ imageBox(3, :);
    y = imageBox(2, :) ./ imageBox(3, :);
    outBox = [min(outBox(1), floor(min(x))) ...
        max(outBox(2), ceil(max(x))) ...
        min(outBox(3), floor(min(y))) ...
        max(outBox(4), ceil(max(y)))];
end
% compute bounding box based on H
disp(outBox);
minX = outBox(1);
maxX = outBox(2);
minY = outBox(3);
maxY = outBox(4);
rows = maxY - minY + 1;
cols = maxX - minX + 1;

for i=1:n1
    imout{i} = warpImage(images{i}, H{i}, outBox);
end

imSti = uint8(zeros(rows, cols, 3));
for i=1:n1
    imSti = max(imSti, imout{i});
end
end
