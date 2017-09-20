function [ matched ] = matchSiftFeatures( des1, des2 )
% Using the method given in the paper and to accelerate in the Matlab
% Compute the angle between two vectors to match two descriptors 
% This could be computed by dot product two normalized vectors.

distRatio = 0.6;  % Was given 0.8 in paper, but 0.6 give better performance

des2prime = des2';
n = size(des1, 1);
matched = zeros(1,n);

for i = 1 : n
   dot = des1(i, :) * des2prime;
   [value, index] = sort(acos(dot));  % Compute arccos to get theta
   if (value(1) < distRatio * value(2))
      matched(i) = index(1);
   else
      matched(i) = 0;
   end
end

%TODO: RANSAC

end