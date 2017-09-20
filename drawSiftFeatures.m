% 
%   Copyright (C) 2016  Starsky Wong <sununs11@gmail.com>
% 
%   Note: The SIFT algorithm is patented in the United States and cannot be
%   used in commercial products without a license from the University of
%   British Columbia.  For more information, refer to the file LICENSE
%   that accompanied this distribution.

function [] = drawFeatures( img, loc, a, b )
% Function: Draw sift feature points and with special a and b
figure;
imshow(img);
hold on;
plot(loc(:,2),loc(:,1),'sy');
plot(loc(a,2),loc(a,1),'sb');
plot(loc(b,2),loc(b,1),'sr');
end