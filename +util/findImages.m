function imageFilenames = findImages(folder)
    ext = 'jpg';
    
    imageFiles = dir(fullfile(folder, ['*.', ext]));
    imageFilenames = {imageFiles.name}';
end