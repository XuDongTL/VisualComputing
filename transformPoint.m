function ptsOut = transformPoint(ptsIn, h)
% This function return points after rigid transfer from homography h
% Input points should have two columns where y follows x
% Output points also have two columins.

ptsOut = zeros(size(ptsIn,1), 2);
for i=1:size(ptsIn, 1)
    point = [ptsIn(i, :) 1];
    point2 = (h * point')';
    ptsOut(i,1) = point2(1) / point2(3);
    ptsOut(i,2) = point2(2) / point2(3);
end

end
