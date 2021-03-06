function [imout, translate] = warpImage (image, H, outBox)
% WARPIMAGE - this function warp give image based on homography matrix H

% calculate the final image dimension
bb_minX = outBox(1);
bb_maxX = outBox(2);
bb_minY = outBox(3);
bb_maxY = outBox(4);

% calculat the mesh grid in the new image
[U,V] = meshgrid(bb_minX:bb_maxX, bb_minY:bb_maxY);
%[U,V] = meshgrid(-1000:1000, -1000:1000);
[nrows, ncols] = size(U);

% calcuate the inverse of homography matrix
Hi = inv(H);

% vectorize the matrix to avoid slow for loop in matlab
% map back the coordinate of point in orginal image
u = U(:);
v = V(:);
x1 = Hi(1,1) * u + Hi(1,2) * v + Hi(1,3);
y1 = Hi(2,1) * u + Hi(2,2) * v + Hi(2,3);
w1 = 1./(Hi(3,1) * u + Hi(3,2) * v + Hi(3,3));
U(:) = x1 .* w1;
V(:) = y1 .* w1;

% bilinear interpolation to get more accurate image color
interp_mode = 'linear';
imout(nrows, ncols, 3) = 1;
imout(:,:,1) = interp2(double(image(:,:,1)),U,V,interp_mode);
imout(:,:,2) = interp2(double(image(:,:,2)),U,V,interp_mode);
imout(:,:,3) = interp2(double(image(:,:,3)),U,V,interp_mode);
imout = uint8(imout);
end
