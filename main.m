%%
net = alexnet;
layer = 'fc7';

%%
scale = 2;
imSize = [scale*227, scale*227];
% im1 = imread('118900.jpg');
im2 = imread('C:\Data\family_photos\IMG_20170416_161647.jpg');
% im1 = imresize(im1, imSize);
im2 = imresize(im2, imSize);

%%
% distanceMap = calcDistances(im1, im2, net, layer);
% [val, idx] = getMinDistances(distanceMap);
% montage(cat(4, im1, im2));
% drawMatches(idx, val, [15, 15])

%%
images = dir('C:\Users\Justin\Desktop\temp\*.jpg');
filenames = {images.name}';
for iFile = 1:numel(filenames)
    disp(iFile)
    im = imread(fullfile('C:\Users\Justin\Desktop\temp\', filenames{iFile}));
    im = imresize(im, imSize);
    [val, idx] = getMinDistances(calcDistances(im, im2, net, layer));
    distances(iFile) = mean(val);
end