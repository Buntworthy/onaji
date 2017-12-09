function averageDistance = measureAverageDistance(query, features)

    averageDistance = zeros(numel(features), 1);
    
    for iIm = 1:numel(features)
        iDistances = pdist2(reshape(query, 1, 4096), features{iIm}, 'cosine');
        averageDistance(iIm) = mean(iDistances);
    end
end