function drawBestBox(dbTable, iIm, iRegion)
    figure
    root = 'C:\Data\family_photos';
    im = imread(fullfile(root, [dbTable.filename{iIm}, '.jpg']));
    region = dbTable.regions{iIm}(iRegion, :);
    im = insertObjectAnnotation(im, 'rectangle', region, '', 'LineWidth', 10);
    imshow(im)
end