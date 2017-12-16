function showResults(imageDb, results)
    nResults = height(results);
    rows = ceil(sqrt(nResults));
    f = figure;
    
    for iResult = 1:nResults
        subplot(rows, rows, iResult)
        imageDb.Images(results.indexes(iResult)).showRegions(results.minRegion(iResult))
        title(results.distances(iResult))
    end

end