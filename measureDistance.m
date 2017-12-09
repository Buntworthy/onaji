function [distances, minRegion] = measureDistance(query, features)

    distances = zeros(numel(features), 1);
    minRegion = zeros(numel(features), 1);
    for iIm = 1:numel(features)
        iDistances = pdist2(reshape(query, 1, 4096), features{iIm}, 'cosine');
        [distances(iIm), minRegion(iIm)] = min(iDistances);
    end
end