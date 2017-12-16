run('setup.m');
net = alexnet;
layer = 'fc7';

wholeProposer = WholeRegionProposer();
edgeProposer = EdgeBoxRegionProposer(100);
proposer = MultiRegionProposer(wholeProposer, edgeProposer);
extractor = CNNFeatureExtractor(net, layer);
imageDb = ImageDatabase(root, proposer, extractor);

%% make a query
x = 17;
y= 5;

%query = Query.fromImageRegion(imageDb.Images(x), y);
query = Query.fromNewImageRegion(imageDb.Images(x));

result = imageDb.query(query);
vis.showResults(imageDb, result(1:9, :))