function dataTable = loadDbFeatures(directory)

    dataTable = table;
    
    % Making the database
    dataFiles = dir(fullfile(directory, '*.mat'));
    dataFiles = {dataFiles.name}';

    % For each image
    nImages = numel(dataFiles);
    for iIm = 1:nImages
        dataFilename = dataFiles{iIm};
        disp(dataFilename);
        data = load(fullfile(directory, dataFilename));
        
        dataTable.filename(iIm) = {strrep(dataFilename, '.mat', '')};
        dataTable.regions(iIm) = {data.regions};
        dataTable.features(iIm) = {data.features};
    end
end