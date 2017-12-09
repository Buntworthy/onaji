function [val, idx] = getMinDistances(distanceMap)
% distanceMap size x1, y1, x2, y2
% return min distance for each x1, y1
% And corresponding x2, y2 index

    [x1, y1, x2, y2] = size(distanceMap);
    nFeatures1 = x1*y1;
    flatDist = reshape(distanceMap, nFeatures1, []);
    [val, linIdx] = min(flatDist, [], 2);
    [xInd1, yInd1] = ind2sub([x1, y1], (1:nFeatures1)');
    [xInd2, yInd2] = ind2sub([x2, y2], linIdx);
    idx = [xInd1, yInd1, xInd2, yInd2];
    
end