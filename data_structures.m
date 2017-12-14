%% Data structures and experiments
% Each image will need sets of features cached to disk. Each image will
% have mutliple features at different locations. Each location defined by a
% bounding box. Total number of features might vary per image.
%
% For each image:
%   MxN array where M = number of features, N = 4 + 4096
%
%   Number of features defined by grid search/region proposals. Bounding
%   boxes are only really for the benefit of testing (i.e. checking overlap
%   with ground truth).

%% Experiments
%
%   How will our overall system and experiments work? Define a set of
%   search features in an N_s x 4096 matrix. For each image in the database
%   then calculate the distance to the image's set of features. Return the
%   closest results
%
% How to define the search/query features?
%   Search either by image region/s or image/s. Start off with a set of
%   image regions defined by bouding boxes.
%
% How to measure the distance to the image features.
%   Different possible search strategies. But basically for each query
%   vector, compute distance to each features vector, then aggregate to a
%   single number by some method.
%
net = alexnet;
cacheDirectory = 'C:\Data\family_photos';
dbTable = loadDbFeatures(cacheDirectory);
%% API
%   The api required to do a basic query (for testing, just a visual check)
%   might look something like:
filename = 'IMG_20170724_141442';
dbTable(strcmp(filename, dbTable.filename), :) = [];
queryImage = fullfile(cacheDirectory, [filename, '.jpg']);

im = imread(queryImage);
imshow(im);
bbox = getrect();
imCrop = imcrop(im, bbox);
imInput = imresize(imCrop, [227, 227]);

queryFeatures = getFeatures(imInput, net, 'fc7');
%%
[distances, minRegions] = measureDistance(queryFeatures, dbTable.features);
% Gallery(dbTable{:,1}, distances)
result = [distances, (1:height(dbTable))', minRegions];
result = sortrows(result);
for i = 1:5
    drawBestBox(dbTable, result(i,2), result(i,3));
end

%%
% meanDist = measureAverageDistance(queryFeatures, dbTable.features);
% result = [meanDist, (1:height(dbTable))'];
% result = sortrows(result);
% root = 'C:\Data\family_photos';
% for i = 1:5
%     figure
%     im = imread(fullfile(root, [dbTable.filename{i}, '.jpg']));
%     imshow(im)
% end