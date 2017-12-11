run('setup.m');
net = alexnet;
layer = 'fc7';

proposer = EdgeBoxRegionProposer(100);
extractor = CNNFeatureExtractor(net, layer);
imageDb = ImageDatabase(root, proposer, extractor);

%% make a query
x = 30;
y= 5;

query = Query.fromImageRegion(imageDb.Images(x), y);
result = imageDb.query(query);
result = sortrows(result, 3);

imageDb.Images(x).showRegions(y);
%%
for i = 1:10
    figure
    imageDb.Images(result.indexes(i)).showRegions(result.minRegion(i))
    title(result.distances(i))
end