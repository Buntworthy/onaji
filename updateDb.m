function updateDb(directory)
    net = alexnet;
    layer = 'fc7';

    % Making the database
    imageFiles = dir(fullfile(directory, '*.jpg'));
    imageFiles = {imageFiles.name}';

    % For each image
    nImages = numel(imageFiles);
    for iIm = 1:nImages
        imFilename = imageFiles{iIm};
        disp(imFilename);
        im = imread(fullfile(directory, imFilename));
        regions = getRegions(im);
        features = extractFeatures(im, regions, net, layer);
        save(fullfile(directory, strrep(imFilename, '.jpg', '.mat')), ...
                'regions', 'features');
    end
    