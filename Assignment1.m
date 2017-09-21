% EE5731 Visual Computing Assigment 1

clear; close all;
% Read images from 'images' folder.
cwd=cd;
cwd(cwd=='\')='/';
% store kent vale images
workingDir = fullfile(cwd, 'images');
imageNames = dir(fullfile(workingDir,'*.jpg'));
imageNames = {imageNames.name}';
imageNames = cell(imageNames);
image = cell(size(imageNames));

for i=1:size(imageNames)
    imageName = char(imageNames(i));
    image{i} = imread(imageName); % Store all images in image
end

% store checker board images
workingDir = fullfile(cwd, 'homo_images');
imageNamesHomo = dir(fullfile(workingDir,'*.jpg'));
imageNamesHomo = {imageNamesHomo.name}';
imageHomo = cell(size(imageNamesHomo));

for i=1:size(imageNamesHomo)
    imageName = char(imageNamesHomo(i));
    imageHomo{i} = imread(imageName); % Store all images in image
end

%% Part 1: SIFT Features and Descriptors
% Extrace location
[des1,loc1] = getFeatures(image{1}); 
first = 40; second = 80;
drawSiftFeatures(image{1}, loc1, first, second);
figure('Name', 'Features descriptors of two selected SIFT features');
subplot(2,1,1); bar(des1(first,:)); title('first feature descriptor');  
subplot(2,1,2); bar(des1(second,:)); title('second feature descriptor');

%% Part 2: Matching SIFT Keypoints of 2 Images
[des2,loc2] = getFeatures(image{2}); 
[des3,loc3] = getFeatures(image{3}); 

% match features using nearest neighbor
matched = matchSiftFeatures(des2,des3);

% draw first 100 matchings
num2draw = 100;
drawSiftMatched(matched ,image{2}, image{3}, loc2, loc3, num2draw);

% find locations in matched features
num2output = 100;
[pts2, pts3] = findPointsOfMatched(matched, loc2, loc3, num2output);

% compute Homography from matched features
h23 = solveHomography(pts2(1:4,:), pts3(1:4,:));

% transfer each point based on homography
pts = transformPoint(pts3, h23);
ptsErr = (round(pts) - round(pts2));

% display wrong matching
wrong = 20; %TODO: findout wrong matching, maybe using homography
figure;  % Draw features
subplot(2,1,1); bar(des2(wrong,:)); title('feature descriptor in first image');  
subplot(2,1,2); bar(des3(wrong,:)); title('feature descriptor in second image');
drawSiftMatched(matched ,image{2}, image{3}, loc2, loc3, num2draw);

% display correct matching
correct = 30;
figure;  % Draw features
subplot(2,1,1); bar(des2(correct,:)); title('feature descriptor in first image');  
subplot(2,1,2); bar(des3(correct,:)); title('feature descriptor in first image');  

%% Part 3: Homography
% open a GUI
homography();
%double edge is because inaccurate homography, when homography is
%calculated inaccurately, this will cause the double edge in the image.

%% Part 4: Manual Homography + Sticthing
% open a GUI
part4();
