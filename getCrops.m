function [crops, labels] = getCrops(labelData)
    filenames = labelData{:, 1};
    count = 1;
    for iIm = 1:numel(filenames)
        im = imread(filenames{iIm});
        
        for iTag = 1:(width(labelData) - 1)
            bboxes = labelData{:, 1 + iTag}{iIm};
            if isempty(bboxes)
                continue;
            end
            
            for iBox = 1:size(bboxes, 1)
                crops{count} = imcrop(im, bboxes(iBox, :));
                labels{count} = labelData.Properties.VariableNames{1 + iTag};
                count = count + 1;
            end
        end
    end
            
end