function features = extractFeatures(im, regions, net, layer)

    inSize = net.Layers(1).InputSize;
    nFeatures = net.Layers(strcmp({net.Layers.Name}, layer)).OutputSize;
    nRegions = size(regions, 1);
    features = zeros(nRegions, nFeatures, 'single');
    
    for iRegion = 1:nRegions
        imCrop = imcrop(im, regions(iRegion, :));
        imInput = imresize(imCrop, inSize(1:2));
        featureVector = net.activations(imInput, layer, 'OutputAs', 'channels');
        features(iRegion, :) = featureVector;
    end
end