function [pts1, pts2] = findPointsOfMatched(matched, loc1, loc2, num2output)
% FINDPOINTSOFMATCHED find num2output amout of matched pairs 
% from two SIFT features extract before. 
%    matched is given in matchSiftFeature function
%    loc1 contains all SIFT features in the first image
%    loc2 contains all SIFT features in the second image

numMatched = sum(matched~=0);
if numMatched < num2output
    num2output = numMatched;
    disp('Only to output %d matched points', numMatched);
end

n = size(matched,2);
pts1 = zeros(num2output, 2);
pts2 = zeros(num2output, 2);
index = 1;
for i=1:n
    if (matched(i) > 0)
       pts1(index,:) = loc1(i,:);
       pts2(index,:) = loc2(matched(i),:);
       index = index + 1;
    end
    if index > num2output % only return required matching pairs
        return
    end
end

end
