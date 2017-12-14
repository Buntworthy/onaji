function distances = calcDistances(im1, im2, net, layer)
    method = 'cosine';

    features1 = getFeatures(im1, net, layer);
    features2 = getFeatures(im2, net, layer);
    sizeFeatures1 = size(features1);
    sizeFeatures2 = size(features2);
    
    features1 = reshape(features1, [], sizeFeatures1(end));
    features2 = reshape(features2, [], sizeFeatures2(end));
    
    distances = pdist2(features1, features2, method);
    distances = reshape(distances, sizeFeatures1(1), sizeFeatures1(2), ...
                            sizeFeatures2(1), sizeFeatures2(2));
end