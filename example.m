net = alexnet;
root = 'C:\Data\family_photos';
filename = 'IMG_20170409_161028.jpg';
layer = 'fc7';

proposer = EdgeBoxRegionProposer(10);
extractor = DummyFeatureExtractor();
imageDb = ImageDatabase(root, proposer, extractor);

% make a query
query = Query.fromImageRegion(imageDb.Images(1), 1);
imageDb.query(query)