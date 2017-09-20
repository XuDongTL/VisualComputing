function ptsOut = transferPoint(ptsIn, h)

ptsOut = zeros(size(ptsIn,1), 2);
for i=1:size(ptsIn, 1)
    point = [ptsIn(i, :) 1];
    point2 = (h * point')';
    ptsOut(i,1) = point2(1) / point2(3);
    ptsOut(i,2) = point2(2) / point2(3);
end

end
