net = alexnet;
root = 'C:\Data\family_photos';
filename = 'IMG_20170409_161028.jpg';
layer = 'fc7';

imageData = ImageData(root, filename);
imageData.calculateRegions(@getRegions);
imageData.calculateFeatures(net, layer);
