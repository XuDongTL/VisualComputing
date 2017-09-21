function v = solveHomography(pts1, pts2)
% This function returns homography matrix H
% pts2 = H * pts1
% pts1 and pts2 should have two columns, y follows x in each ros

n1 = size(pts1, 1);
n2 = size(pts2, 1);
if ~(n1==n2) % check dimentionality of two
    error('Error. number of points in each input should be equal');
end
% construct A matrix
X = pts1(:, 1); Y = pts1(:, 2);
x = pts2(:, 1); y = pts2(:, 2);
zero = zeros(n1, 3);
inputXY = [X Y ones(n1, 1)];
rows1 = [inputXY zero -x.*X -x.*Y -x];
rows2 = [zero inputXY -y.*X -y.*Y -y];

% A is constructed as transpose of A to make sure m larger than n for SVD
% Hence U is actually V of real A
A = [rows1; rows2]; % constructed A matrix, it is transpose of real A.

[~, ~, V] = svd(A); % solve svd
v = V(:,end);
v = v / norm(v);
v = reshape(v, 3, 3)'; %because reshape function order goes down then right
end